import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/ui/bottom_sheets/add_child_bottom_sheet_modern.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/models/responseModel/childListResponse.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class ViewChildrenScreenModern extends StatefulWidget {
  const ViewChildrenScreenModern({Key? key}) : super(key: key);

  @override
  State<ViewChildrenScreenModern> createState() => _ViewChildrenScreenModernState();
}

class _ViewChildrenScreenModernState extends State<ViewChildrenScreenModern> {
  bool _isLoading = false;
  bool _isDataAvail = true;

  List<ChildData>? _childList;

  @override
  void initState() {
    super.initState();
    _getChildList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                  ),
                )
              : !_isDataAvail
                  ? _buildNoDataWidget(theme, colorScheme)
                  : _buildContent(theme, colorScheme),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(theme, colorScheme),
              SizedBox(height: Spacing.lg),
              Text(
                'View Children',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
            itemCount: _childList?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildChildCard(_childList![index], theme, colorScheme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _onBackPress,
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
        ),
        IconButton(
          onPressed: _openAddChildBottomSheet,
          icon: Icon(Icons.person_add, color: colorScheme.onPrimary),
        ),
      ],
    );
  }

  Widget _buildChildCard(ChildData childData, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: EdgeInsets.only(bottom: Spacing.md),
      child: ListTile(
        contentPadding: EdgeInsets.all(Spacing.md),
        onTap: () {
          CommonResponse.childId = childData.id;
          CommonResponse.childData = childData;
          CommonResponse.childName = childData.name;
          NavigationService.instance.navigateToReplacementNamed(
            Constants.KEY_ROUTE_CHILD_DETAIL,
          );
        },
        leading: AppAvatar(
          size: 56,
          imageUrl: childData.img.endsWith("default.jpg") ? null : childData.img,
          imagePath: childData.img.endsWith("default.jpg") ? "assets/images/default.jpeg" : null,
        ),
        title: Text(
          childData.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${childData.age} year old',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: SizedBox(
          width: 80,
          child: AppBadge(
            text: '${childData.teethCount}',
            backgroundColor: Color(0xFFFFF9C4),
            textColor: colorScheme.onSurface,
            size: AppBadgeSize.large,
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataWidget(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(theme, colorScheme),
              SizedBox(height: Spacing.lg),
              Text(
                'View Children',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: EmptyState(
            icon: Icon(Icons.people_outline, size: 60),
            title: 'No children have been added yet',
            description: 'Add your first child to get started',
            actionText: 'Add Child',
            onActionPressed: _openAddChildBottomSheet,
          ),
        ),
      ],
    );
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
  }

  void _openAddChildBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddChildBottomSheetModern(
          refreshPage: _getChildList,
        ),
      ),
    );
  }

  void _getChildList() async {
    setState(() => _isLoading = true);

    try {
      // Use ApiClient with automatic token handling
      Response response = await ApiClient().post('/child');

      if (ApiClient().isSuccessResponse(response)) {
        dynamic responseData = json.decode(response.body);
        var dataList = responseData[Constants.KEY_DATA];

        if (dataList != null && (dataList as List).isNotEmpty) {
          ChildListResponse childListResponse = ChildListResponse.fromJson(responseData);
          setState(() {
            _childList = childListResponse.data;
            _isDataAvail = _childList != null && _childList!.isNotEmpty;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _isDataAvail = false;
          });
        }
      } else {
        // Handle 401 errors - ApiClient will redirect automatically
        if (response.statusCode == 401) {
          return;
        }

        setState(() => _isLoading = false);
        String message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to load children');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }
}
