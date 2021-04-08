import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/addChildPostDataModel.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class AddChildBottomSheet extends StatefulWidget {
  final Function refreshPage;

  AddChildBottomSheet({this.refreshPage});

  @override
  _AddChildBottomSheetState createState() => _AddChildBottomSheetState();
}

class _AddChildBottomSheetState extends State<AddChildBottomSheet> {
  APIService _apiService = APIService();

  bool _isDateOfBirthSet = false;
  bool _isLoading = false;

  int amountCounter = 0;

  File _selImageFile;

  DateTime selectedDate = DateTime.now();

  TextEditingController _nameEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.maybeOf(context).size.height * 0.75,
      width: MediaQuery.maybeOf(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textTitle(),
          _cameraWidget(),
          _name(),
          _dateOfBirth(),
          Spacer(),
          _doneBtn(),
          _cancelBtn(),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Add child',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _cameraWidget() {
    return InkWell(
      onTap: () => _openImagePickerDialog(),
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.COLOR_LIGHT_GREY,
        ),
        child: Center(
          child: _selImageFile == null
              ? Image.asset(
                  'assets/icons/ic_camera.png',
                  height: 40,
                  width: 40,
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(_selImageFile),
                ),
        ),
      ),
    );
  }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: TextFormField(
        controller: _nameEditController,
        maxLines: 1,
        keyboardType: TextInputType.name,
        maxLength: 100,
        inputFormatters: [
          new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
        ],
        style: TextStyle(
            color: AppColors.COLOR_TEXT_BLACK,
            fontFamily: 'Avenir',
            fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.COLOR_LIGHT_GREY,
          isDense: true,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(30),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Name',
          hintStyle: TextStyle(
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontSize: 14),
          prefix: SizedBox(
            width: 10,
          ),
          suffix: SizedBox(
            width: 10,
          ),
        ),
      ),
    );
  }

  Widget _dateOfBirth() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        width: MediaQuery.maybeOf(context).size.width,
        height: 50,
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_LIGHT_GREY,
          borderRadius: const BorderRadius.all(
            const Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              !_isDateOfBirthSet
                  ? 'Date of Birth'
                  : '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColors.COLOR_TEXT_BLACK,
                  fontFamily: 'Avenir',
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doneBtn() {
    return InkWell(
      onTap: () => _validateForm() ? _submit() : null,
      child: Container(
        height: 50,
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_BTN_BLUE,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: _isLoading
              ? _loader()
              : Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Avenir',
                  ),
                ),
        ),
      ),
    );
  }

  Widget _cancelBtn() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 50,
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePickerDialog() {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _galleryBtn(),
          SizedBox(
            height: 10,
          ),
          _cameraBtn(),
        ],
      ),
    );
  }

  Widget _galleryBtn() {
    return InkWell(
      onTap: () => _pickImageFromGallery(),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.image,
              size: 42,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Gallery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cameraBtn() {
    return InkWell(
      onTap: () => _pickImageFromCamera(),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.photo_camera,
              size: 42,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Camera',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loader() {
    return Container(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  void _openImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: _imagePickerDialog(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    Navigator.pop(context);
    PickedFile _imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _selImageFile = File(_imageFile.path);
    });
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);
    PickedFile _imageFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _selImageFile = File(_imageFile.path);
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1970),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _isDateOfBirthSet = true;
      });
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
    setState(() {
      _isLoading = true;
    });

    String token = await PreferenceHelper().getAccessToken();
    String authToken = 'Bearer $token';

    String name = _nameEditController.text.trim();
    String dateOfBirth =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    String imagePath = _selImageFile.path;

    AddChildPostData addChildPostData = AddChildPostData();
    addChildPostData.name = name;
    addChildPostData.dateOfBirth = dateOfBirth;
    addChildPostData.imagePath = imagePath;

    Response response =
        await _apiService.addChildApiCall(addChildPostData, authToken);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);

      if (widget.refreshPage != null) {
        widget.refreshPage();
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      BotToast.showText(
        text: message,
        contentColor: AppColors.COLOR_PRIMARY,
        duration: Duration(seconds: 3),
      );
    }
  }
}
