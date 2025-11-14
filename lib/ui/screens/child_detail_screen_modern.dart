import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/screens/badges_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/history_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/summary_screen_modern.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

/// Modern child detail screen with tabbed interface
/// Shows Summary, History, and Badges tabs for selected child
class ChildDetailScreenModern extends StatefulWidget {
  const ChildDetailScreenModern({super.key});

  @override
  State<ChildDetailScreenModern> createState() =>
      _ChildDetailScreenModernState();
}

class _ChildDetailScreenModernState extends State<ChildDetailScreenModern> {
  static const String KEY_SUMMARY_SCREEN = 'SUMMARY_SCREEN';
  static const String KEY_HISTORY_SCREEN = 'HISTORY_SCREEN';
  static const String KEY_BADGE_SCREEN = 'BADGE_SCREEN';

  String _selectedTab = KEY_SUMMARY_SCREEN;
  String _childName = '';
  String _childAge = '';

  @override
  void initState() {
    super.initState();
    _childName = CommonResponse.childData?.name ?? '';
    _childAge = CommonResponse.childData?.age.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: Column(
            children: [
              _buildAppBar(colorScheme),
              _buildHeader(colorScheme),
              Spacing.gapVerticalMd,
              _buildTabBar(colorScheme, isDark),
              Spacing.gapVerticalMd,
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onPrimary),
            onPressed: _onBackPress,
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded),
                    Spacing.gapHorizontalSm,
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _childName,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    fontFamily: 'Avenir',
                  ),
                ),
                Spacing.gapVerticalXs,
                Text(
                  '$_childAge year old',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
          ),
          if (_selectedTab == KEY_HISTORY_SCREEN)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondaryContainer,
                border: Border.all(
                  color: colorScheme.onPrimary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: (CommonResponse.childData?.img ?? '')
                        .endsWith("default.jpg")
                    ? Image.asset(
                        "assets/images/default.jpeg",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        CommonResponse.childData?.img ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTab('Summary', KEY_SUMMARY_SCREEN, colorScheme, isDark),
          _buildTab('History', KEY_HISTORY_SCREEN, colorScheme, isDark),
          _buildTab('Badges', KEY_BADGE_SCREEN, colorScheme, isDark),
        ],
      ),
    );
  }

  Widget _buildTab(
      String title, String key, ColorScheme colorScheme, bool isDark) {
    final isSelected = _selectedTab == key;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = key;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.secondaryContainer
                : colorScheme.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onPrimary.withValues(alpha: 0.9),
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case KEY_SUMMARY_SCREEN:
        return const SummaryScreenModern();
      case KEY_HISTORY_SCREEN:
        return const HistoryScreenModern();
      case KEY_BADGE_SCREEN:
        return const BadgesScreenModern();
      default:
        return const SummaryScreenModern();
    }
  }

  void _onBackPress() {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_VIEW_CHILD);
  }

  Future<void> _logout() async {
    await PreferenceHelper().setLoginResponse('');
    await PreferenceHelper().setIsUserLogin(false);
    if (mounted) {
      NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
    }
  }
}
