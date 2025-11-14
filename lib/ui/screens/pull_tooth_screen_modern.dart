import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:video_player/video_player.dart';

/// Modern pull tooth screen with interactive mouth video
class PullToothScreenModern extends StatefulWidget {
  const PullToothScreenModern({super.key});

  @override
  State<PullToothScreenModern> createState() => _PullToothScreenModernState();
}

class _PullToothScreenModernState extends State<PullToothScreenModern> {
  VideoPlayerController? _videoPlayerController;
  double ratio = 800 / 600;
  String _mouthOpenVideoPath = 'assets/videos/mouth_open_video.mp4';
  String _toothName = '';
  String _teethDescription = '';

  bool _isVideoVisible = true;
  bool _isClickable = true;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _initController('', '');
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(colorScheme),
                _buildTitle(colorScheme),
                _buildInstruction(colorScheme),
                _buildMouthWidget(),
                if (_toothName.isNotEmpty) ...[
                  _buildToothInfo(colorScheme),
                  Spacing.gapVerticalXl,
                  _buildPullToothButton(colorScheme),
                ],
                Spacing.gapVerticalMd,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onPrimary),
        onPressed: _onBackPress,
      ),
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Text(
        'Select a tooth',
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _buildInstruction(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Text(
        'Tap to select a tooth',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildMouthWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Stack(
        children: [
          Center(
            child: _isVideoVisible
                ? _buildVideoPlayer()
                : Image.asset(
                    'assets/icons/ic_mouth_open.png',
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: (MediaQuery.of(context).size.height * 0.40) * ratio,
                    fit: BoxFit.fill,
                  ),
          ),
          _buildClickableRegions(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: (MediaQuery.of(context).size.height * 0.40) * ratio,
      child: AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController!),
      ),
    );
  }

  Widget _buildClickableRegions() {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: (MediaQuery.of(context).size.height * 0.40) * ratio,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.0700),
            _buildTopTeeth(),
            const Spacer(),
            _buildBottomTeeth(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0700),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTeeth() {
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(10, (i) => _buildToothArea(i + 1, isTop: true)),
      ),
    );
  }

  Widget _buildBottomTeeth() {
    return SizedBox(
      height: 65,
      child: Row(
        children: List.generate(10, (i) => _buildToothArea(i + 11, isTop: false)),
      ),
    );
  }

  Widget _buildToothArea(int toothNumber, {required bool isTop}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onToothTap(toothNumber),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildToothInfo(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _toothName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
              fontFamily: 'Avenir',
            ),
          ),
          Spacing.gapVerticalSm,
          Text(
            _teethDescription,
            style: TextStyle(
              fontSize: 20,
              color: colorScheme.onPrimary,
              fontFamily: 'Avenir',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPullToothButton(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: AppButton(
        text: 'Pull Tooth',
        onPressed: () => NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_CAPTURE_IMAGE),
        isFullWidth: true,
        customColor: colorScheme.secondaryContainer,
        customTextColor: colorScheme.onSecondaryContainer,
      ),
    );
  }

  void _onToothTap(int toothNumber) {
    if (!_isClickable) return;

    _mouthOpenVideoPath =
        'assets/videos/toothSelectionVideo/${_getToothVideoFile(toothNumber)}';
    _isClickable = false;
    CommonResponse.selectedTooth = toothNumber.toString();
    _initController(_getToothName(toothNumber), _getToothDescription(toothNumber));
  }

  String _getToothVideoFile(int toothNumber) {
    if (toothNumber <= 10) {
      return 't$toothNumber.mp4';
    } else {
      return 'b${toothNumber - 10}.mp4';
    }
  }

  String _getToothName(int toothNumber) {
    const toothMap = {
      1: Constants.TEETH_SECOND_MOLAR,
      2: Constants.TEETH_FIRST_MOLAR,
      3: Constants.TEETH_CUSPID,
      4: Constants.TEETH_LATERAL_INCISOR,
      5: Constants.TEETH_CENTRAL_INCISOR,
      6: Constants.TEETH_CENTRAL_INCISOR,
      7: Constants.TEETH_LATERAL_INCISOR,
      8: Constants.TEETH_CUSPID,
      9: Constants.TEETH_FIRST_MOLAR,
      10: Constants.TEETH_SECOND_MOLAR,
    };

    if (toothNumber <= 10) {
      return toothMap[toothNumber] ?? '';
    } else {
      return toothMap[toothNumber - 10] ?? '';
    }
  }

  String _getToothDescription(int toothNumber) {
    const descMap = {
      1: Constants.DESCRIPTION_SECOND_MOLAR,
      2: Constants.DESCRIPTION_FIRST_MOLAR,
      3: Constants.DESCRIPTION_CUSPID,
      4: Constants.DESCRIPTION_LATERAL_INCISOR,
      5: Constants.DESCRIPTION_CENTRAL_INCISOR,
      6: Constants.DESCRIPTION_CENTRAL_INCISOR,
      7: Constants.DESCRIPTION_LATERAL_INCISOR,
      8: Constants.DESCRIPTION_CUSPID,
      9: Constants.DESCRIPTION_FIRST_MOLAR,
      10: Constants.DESCRIPTION_SECOND_MOLAR,
    };

    if (toothNumber <= 10) {
      return descMap[toothNumber] ?? '';
    } else {
      return descMap[toothNumber - 10] ?? '';
    }
  }

  void _initController(String toothName, String teethDescription) async {
    final controller = VideoPlayerController.asset(_mouthOpenVideoPath);
    controller.setLooping(false);
    await controller.initialize();
    controller.setVolume(0.0);

    if (mounted) {
      setState(() {
        _videoPlayerController = controller;
        _videoPlayerController!.play();
        _videoPlayerController!.addListener(() {
          if (!_videoPlayerController!.value.isPlaying) {
            setState(() {
              _isVideoVisible = false;
              _isClickable = true;
              if (_isInit) {
                _playFirstMollerVideo();
                _isInit = false;
              } else {
                _toothName = toothName;
                _teethDescription = teethDescription;
              }
            });
          } else {
            setState(() {
              _isVideoVisible = true;
              _isClickable = false;
            });
          }
        });
      });
    }
  }

  void _playFirstMollerVideo() {
    _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t9.mp4';
    _isClickable = false;
    _initController(Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
  }

  void _onBackPress() {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
