import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/pullToothResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

/// Modern camera screen for capturing tooth photos
class CaptureImageScreenModern extends StatefulWidget {
  final String? teethNumber;

  const CaptureImageScreenModern({super.key, this.teethNumber});

  @override
  State<CaptureImageScreenModern> createState() =>
      _CaptureImageScreenModernState();
}

class _CaptureImageScreenModernState extends State<CaptureImageScreenModern>
    with WidgetsBindingObserver {
  final APIService _apiService = APIService();
  CameraController? controller;

  bool _isLoading = false;
  bool _isFrontCamera = true;
  bool _isImageCapture = false;

  String? imagePath;
  List<CameraDescription> cameras = [];
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
        backgroundColor: colorScheme.primary.withValues(alpha: 0.8),
        body: SafeArea(
          child: _isLoading
              ? _buildLoadingScreen(colorScheme)
              : _isImageCapture
                  ? _buildImagePreview()
                  : _buildCameraView(colorScheme),
        ),
        floatingActionButton: !_isLoading
            ? FloatingActionButton.large(
                backgroundColor: colorScheme.secondaryContainer,
                onPressed: _onTakePictureButtonPressed,
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 32,
                  color: colorScheme.onSecondaryContainer,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: !_isLoading
            ? _buildBottomBar(colorScheme)
            : null,
      ),
    );
  }

  Widget _buildLoadingScreen(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildCameraView(ColorScheme colorScheme) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.onPrimary,
        ),
      );
    }

    // Calculate proper scale to fill screen without distortion
    final size = MediaQuery.of(context).size;
    final screenRatio = size.height / size.width;
    final cameraRatio = controller!.value.aspectRatio;

    // Calculate scale factor to fill the screen
    // Camera aspect ratio is width/height, so we need to invert it for comparison
    final scale = screenRatio > cameraRatio
        ? screenRatio / cameraRatio
        : cameraRatio / screenRatio;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Center(
              child: AspectRatio(
                aspectRatio: cameraRatio,
                child: CameraPreview(controller!),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  'One last step',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    fontFamily: 'Avenir',
                  ),
                ),
                Spacing.gapVerticalXs,
                Text(
                  'Show me your smile',
                  style: TextStyle(
                    fontSize: 19,
                    color: colorScheme.onPrimary,
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Image.file(
      File(imagePath!),
      fit: BoxFit.cover,
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onPrimary,
                size: 28,
              ),
              onPressed: _onBackPress,
            ),
            const SizedBox(width: 72), // Space for FAB
            IconButton(
              icon: Icon(
                Icons.flip_camera_ios_rounded,
                color: colorScheme.onPrimary,
                size: 28,
              ),
              onPressed: () =>
                  _isFrontCamera ? _setRearCamera() : _setFrontCamera(),
            ),
          ],
        ),
      ),
    );
  }

  void _initCamera() async {
    WidgetsBinding.instance.addObserver(this);

    availableCameras().then((value) {
      cameras = value;
      if (cameras.isEmpty) {
        return;
      }
      controller = CameraController(
        cameras[1],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      controller!.initialize().then(
            (value) => onNewCameraSelected(controller!.description),
          );
    });
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    controller!.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      debugPrint('Camera Exception: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onTakePictureButtonPressed() {
    _takePicture().then((String? filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          CommonResponse.capturedImagePath = imagePath ?? '';
          _isImageCapture = true;
        });
        _submitTooth();
      }
    });
  }

  Future<String?> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile picture = await controller!.takePicture();
      await picture.saveTo(filePath);
    } on CameraException catch (e) {
      debugPrint('Take Picture Exception: $e');
      return null;
    }
    return filePath;
  }

  void _setFrontCamera() {
    setState(() {
      _isFrontCamera = true;
      onNewCameraSelected(cameras[1]);
    });
  }

  void _setRearCamera() {
    setState(() {
      _isFrontCamera = false;
      onNewCameraSelected(cameras[0]);
    });
  }

  void _onBackPress() {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_PULL_TOOTH);
  }

  void _submitTooth() async {
    setState(() {
      _isLoading = true;
    });

    final token = await PreferenceHelper().getAccessToken();
    final authToken = '${Constants.VAL_BEARER} $token';

    final childId = CommonResponse.childId.toString();
    final teethNumber = CommonResponse.selectedTooth;

    final year = _currentDate.year.toString();
    final month = _currentDate.month <= 9
        ? '0${_currentDate.month}'
        : _currentDate.month.toString();
    final day = _currentDate.day <= 9
        ? '0${_currentDate.day}'
        : _currentDate.day.toString();

    final pullDate = '$year-$month-$day';

    final response = await _apiService.pullTeethApiCall(
        childId, teethNumber, pullDate, authToken, imagePath ?? '');
    final responseData = json.decode(response.body);
    final message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      if (responseData['status'] == 1) {
        final pullToothResponse = PullToothResponse.fromJson(responseData);
        CommonResponse.pullToothData = pullToothResponse.data;

        setState(() {
          _isLoading = false;
        });

        NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_ANALYSING_SCREEN);
      } else {
        setState(() {
          _isLoading = false;
        });
        BotToast.showText(
          text: message,
          duration: const Duration(seconds: 3),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      BotToast.showText(
        text: message,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
