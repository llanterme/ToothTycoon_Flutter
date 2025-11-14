import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';
import 'package:video_player/video_player.dart';

/// Modern history screen showing tooth pull history with interactive mouth video
class HistoryScreenModern extends StatefulWidget {
  const HistoryScreenModern({super.key});

  @override
  State<HistoryScreenModern> createState() => _HistoryScreenModernState();
}

class _HistoryScreenModernState extends State<HistoryScreenModern> {
  VideoPlayerController? _videoPlayerController;
  double ratio = 800 / 600;
  String _mouthOpenVideoPath = 'assets/videos/mouth_open_video.mp4';

  bool _isVideoVisible = true;
  bool _isClickable = true;
  bool _isDataAvail = true;

  int _currentValue = 0;
  String _toothName = '';
  String _collectedDate = '';

  List<TeethList>? _teethListList;

  @override
  void initState() {
    super.initState();
    if (CommonResponse.pullHistoryData != null) {
      _currentValue = CommonResponse.pullHistoryData!.amount;
      if (CommonResponse.pullHistoryData!.teethList != null &&
          CommonResponse.pullHistoryData!.teethList!.isNotEmpty) {
        _teethListList = CommonResponse.pullHistoryData!.teethList;
        _initController('', '');
      }
    } else {
      _isDataAvail = false;
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isDataAvail) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Spacing.radiusXl),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/ic_no_data.png',
                height: 200,
                width: 200,
              ),
              Spacing.gapVerticalMd,
              Text(
                'No history available',
                style: TextStyle(
                  fontSize: 19,
                  color: colorScheme.onSurface,
                  fontFamily: 'Avenir',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Spacing.radiusXl),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Text(
                  'Tap a tooth to view history',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildMouthWidget(colorScheme),
              if (_toothName.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: Text(
                    _toothName,
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onPrimary,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ),
                Spacing.gapVerticalSm,
                _buildInfoCard(
                  colorScheme,
                  'Date collected',
                  _collectedDate,
                ),
                Spacing.gapVerticalSm,
                _buildInfoCard(
                  colorScheme,
                  'Current value',
                  '${CommonResponse.budget?.symbol ?? "\$"}$_currentValue',
                ),
              ],
              Spacing.gapVerticalMd,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMouthWidget(ColorScheme colorScheme) {
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
        children: List.generate(
          10,
          (i) => _buildToothArea(i + 1, isTop: true),
        ),
      ),
    );
  }

  Widget _buildBottomTeeth() {
    return SizedBox(
      height: 65,
      child: Row(
        children: List.generate(
          10,
          (i) => _buildToothArea(i + 11, isTop: false),
        ),
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

  Widget _buildInfoCard(ColorScheme colorScheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir',
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onToothTap(int toothNumber) {
    if (!_isClickable) return;

    _mouthOpenVideoPath =
        'assets/videos/toothSelectionVideo/${_getToothVideoFile(toothNumber)}';
    _isClickable = false;
    _initController(toothNumber.toString(), _getToothName(toothNumber));
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

  void _initController(String teethNumber, String toothName) async {
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
              _toothName = toothName;
              if (teethNumber.isNotEmpty) {
                _getTeethHistory(teethNumber);
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

  void _getTeethHistory(String teethNumber) {
    String collectedDate = '';
    if (_teethListList != null && _teethListList!.isNotEmpty) {
      for (final teethData in _teethListList!) {
        if (teethNumber == teethData.teethNumber) {
          collectedDate = teethData.pullDate;
          break;
        }
      }

      if (collectedDate.isNotEmpty) {
        setState(() {
          _collectedDate = collectedDate;
        });
      } else {
        Utils.showToast(message: 'Data not found', durationInSecond: 3);
        setState(() {
          _collectedDate = '---';
        });
      }
    } else {
      Utils.showToast(message: 'Data not found', durationInSecond: 3);
      setState(() {
        _collectedDate = '---';
      });
    }
  }
}
