import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:tooth_tycoon/bottomsheet/loginBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/resetPasswordBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/signupBottomSheet.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/widgets/videoPlayerWidget.dart';

/// Modern redesigned Welcome Screen with Material 3 styling
/// Preserves all existing functionality while enhancing the UI/UX
class WelcomeScreenModern extends StatefulWidget {
  const WelcomeScreenModern({super.key});

  @override
  State<WelcomeScreenModern> createState() => _WelcomeScreenModernState();
}

class _WelcomeScreenModernState extends State<WelcomeScreenModern> {
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  final String _welcomeAnimationPath = 'assets/videos/welcome_animation.mp4';
  final double ratio = 832 / 726;

  @override
  void dispose() {
    _pageController.dispose();
    currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacing.gapVerticalMd,
              _buildAppAnimation(size),
              Spacing.gapVerticalLg,
              _buildSlider(),
              Spacing.gapVerticalMd,
              _buildPageIndicator(),
              const Spacer(),
              _buildSignupButton(colorScheme),
              Spacing.gapVerticalMd,
              _buildLoginButton(colorScheme),
              Spacing.gapVerticalXl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppAnimation(Size size) {
    return Container(
      padding: Spacing.horizontalMd,
      child: VideoPlayerWidget(
        height: size.height * 0.28,
        width: (size.height * 0.28) * ratio,
        videoPath: _welcomeAnimationPath,
      ),
    );
  }

  Widget _buildSlider() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          currentPage.value = index;
        },
        children: [
          _buildSlide(
            title: 'Welcome to\nTooth Tycoon',
            description: 'What is the going rate for a tooth?\nYou decide!',
          ),
          _buildSlide(
            title: 'Welcome to\nTooth Tycoon',
            description: 'Your kids will learn to build their own\nempire from an early age to eventually\nbecome a Tooth Tycoon',
          ),
          _buildSlide(
            title: 'Welcome to\nTooth Tycoon',
            description: 'Share these milestone and newly acquired\nmoney smarts with friends and family',
          ),
          _buildSlide(
            title: 'Welcome to\nTooth Tycoon',
            description: 'Use tooth money to teach your children\nabout the magic of compound interest',
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({required String title, required String description}) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: Spacing.horizontalLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Spacing.gapVerticalMd,
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return CirclePageIndicator(
      itemCount: 4,
      currentPageNotifier: currentPage,
      dotColor: Colors.white.withValues(alpha: 0.4),
      selectedDotColor: Colors.white,
      selectedSize: 10,
      size: 8,
    );
  }

  Widget _buildSignupButton(ColorScheme colorScheme) {
    return Padding(
      padding: Spacing.horizontalXl,
      child: AppButton(
        text: 'Sign Up',
        onPressed: _openSignupBottomSheet,
        isFullWidth: true,
        customColor: Colors.white,
        customTextColor: colorScheme.primary,
        size: AppButtonSize.large,
      ),
    );
  }

  Widget _buildLoginButton(ColorScheme colorScheme) {
    return Padding(
      padding: Spacing.horizontalXl,
      child: AppButton(
        text: 'Login',
        onPressed: _openLoginBottomSheet,
        variant: AppButtonVariant.outline,
        isFullWidth: true,
        customColor: Colors.white,
        customTextColor: Colors.white,
        size: AppButtonSize.large,
      ),
    );
  }

  void _openSignupBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SignupBottomSheet(
          loginFunction: _openLoginBottomSheet,
        ),
      ),
    );
  }

  void _openLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LoginBottomSheet(
          signupFunction: _openSignupBottomSheet,
          resetPasswordFunction: _openResetPasswordBottomSheet,
          loginFunction: _openSignupBottomSheet,
        ),
      ),
    );
  }

  void _openResetPasswordBottomSheet(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ResetPasswordBottomSheet(
          email: email,
          loginFunction: _openLoginBottomSheet,
        ),
      ),
    );
  }
}
