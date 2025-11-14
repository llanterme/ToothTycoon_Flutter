import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class AddChildBottomSheetModern extends StatefulWidget {
  final Function refreshPage;

  const AddChildBottomSheetModern({
    Key? key,
    required this.refreshPage,
  }) : super(key: key);

  @override
  State<AddChildBottomSheetModern> createState() => _AddChildBottomSheetModernState();
}

class _AddChildBottomSheetModernState extends State<AddChildBottomSheetModern> {
  final TextEditingController _nameEditController = TextEditingController();

  bool _isDateOfBirthSet = false;
  bool _isLoading = false;

  File? _selImageFile;
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      title: 'Add child',
      maxHeight: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Camera/Image Picker
          Center(
            child: GestureDetector(
              onTap: _openImagePickerDialog,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: _selImageFile == null
                    ? Center(
                        child: Image.asset(
                          'assets/icons/ic_camera.png',
                          height: 40,
                          width: 40,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_selImageFile!),
                      ),
              ),
            ),
          ),
          SizedBox(height: Spacing.lg),

          // Name Field
          AppTextField(
            controller: _nameEditController,
            hintText: 'Name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            maxLength: 100,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            ],
          ),
          SizedBox(height: Spacing.md),

          // Date of Birth
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  SizedBox(width: Spacing.lg),
                  Text(
                    !_isDateOfBirthSet
                        ? 'Date of Birth'
                        : '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _isDateOfBirthSet
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Spacing.xl),

          // Done Button
          AppButton(
            text: 'Done',
            onPressed: () => _validateForm() ? _submit() : null,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
          SizedBox(height: Spacing.md),

          // Cancel Button
          AppButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            isFullWidth: true,
            variant: AppButtonVariant.text,
          ),
        ],
      ),
    );
  }

  void _openImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(Spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.image, size: 42),
                  title: Text(
                    'Gallery',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: _pickImageFromGallery,
                ),
                SizedBox(height: Spacing.sm),
                ListTile(
                  leading: Icon(Icons.photo_camera, size: 42),
                  title: Text(
                    'Camera',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: _pickImageFromCamera,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (imageFile != null) {
        _selImageFile = File(imageFile.path);
      }
    });
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      if (imageFile != null) {
        _selImageFile = File(imageFile.path);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _isDateOfBirthSet = true;
      });
    }
  }

  bool _validateForm() {
    if (_selImageFile == null) {
      Utils.showAlertDialog(context, 'Please select image');
      return false;
    }

    if (_nameEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(context, 'Please enter name');
      return false;
    }

    if (!_isDateOfBirthSet) {
      Utils.showAlertDialog(context, 'Please select date of birth');
      return false;
    } else {
      final date2 = DateTime.now();
      final difference = date2.difference(selectedDate).inDays;
      int differenceInYears = (difference / 365).floor();
      if (differenceInYears < 1) {
        Utils.showAlertDialog(context, 'Required child age minimum 1 year');
        return false;
      }
    }

    return true;
  }

  void _submit() async {
    // Check token before action
    if (!await AuthErrorHandler.checkTokenBeforeAction()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      String name = _nameEditController.text.trim();
      String dateOfBirth = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      String imagePath = _selImageFile!.path;

      // Use ApiClient for multipart request with automatic token handling
      Response response = await ApiClient().postMultipart(
        '/child/add',
        fields: {
          'name': name,
          'date_of_birth': dateOfBirth,
        },
        files: {
          'img': imagePath,
        },
      );

      setState(() => _isLoading = false);

      if (ApiClient().isSuccessResponse(response)) {
        AuthErrorHandler.showSuccess('Child added successfully!');
        Navigator.pop(context);
        widget.refreshPage();
      } else {
        // Handle 401 errors automatically by ApiClient
        if (response.statusCode == 401) {
          // ApiClient already handled logout and redirect
          return;
        }

        String message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to add child');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }
}
