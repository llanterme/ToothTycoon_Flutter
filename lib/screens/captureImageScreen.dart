import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb and defaultTargetPlatform
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/pullToothResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CaptureImageScreen extends StatefulWidget {
  final String? teethNumber;

  CaptureImageScreen({this.teethNumber});

  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen>
    with WidgetsBindingObserver {
  APIService _apiService = APIService();
  CameraController? controller;

  bool _isLoading = false;
  bool _isFrontCamera = true;
  bool _isImageCapture = false;
  bool _isSimulator = false;

  String? imagePath;

  List<CameraDescription> cameras = [];

  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkSimulator();
    _initCamera();
  }

  // Check if running on simulator
  Future<void> _checkSimulator() async {
    if (Platform.isIOS) {
      // iOS Simulator detection
      _isSimulator = !Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')
          ? defaultTargetPlatform == TargetPlatform.iOS
          : true;
    } else if (Platform.isAndroid) {
      // Android Emulator detection - check for common emulator properties
      _isSimulator = await _isAndroidEmulator();
    }
    setState(() {});
    print('Running on simulator: $_isSimulator');
  }

  Future<bool> _isAndroidEmulator() async {
    // Android emulators typically have these characteristics
    return Platform.environment['ANDROID_EMULATOR'] == 'true' ||
           await availableCameras().then((cameras) => cameras.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    double ratio = 16 / 9;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPress();
        }
      },
      child: Scaffold(
        bottomNavigationBar: _customBottomAppBar(),
        backgroundColor: AppColors.COLOR_PRIMARY.withValues(alpha: 0.8),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.COLOR_LIGHT_RED,
          child: Center(
            child: Image.asset(
              'assets/icons/ic_capture_image.png',
              height: 42,
              width: 42,
            ),
          ),
          onPressed: () => _onTakePictureButtonPressed(),
        ),
        body: SafeArea(
          child: _isLoading
              ? _loadingPage()
              : _isImageCapture
                  ? _imageWidget()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: controller != null
                          ? _cameraPreviewWidget()
                          : Container(),
                    ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.width * (16 / 9),
            child: _isSimulator
                ? Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 100, color: Colors.grey[600]),
                          SizedBox(height: 20),
                          Text(
                            'Simulator Mode\nCamera Preview',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                : (controller != null && controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: CameraPreview(controller!),
                      )
                    : Center(child: CircularProgressIndicator())),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              end: const Alignment(0.0, 0.4),
              begin: const Alignment(0.0, -1),
              colors: <Color>[
                AppColors.COLOR_PRIMARY.withValues(alpha: 0.8),
                AppColors.COLOR_PRIMARY.withValues(alpha: 0.0),
              ],
            )),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'One last step',
                  style: TextStyle(
                      fontSize: 33, color: Colors.white, fontFamily: 'Avenir'),
                ),
                Text(
                  'Show me your smile',
                  style: TextStyle(
                      fontSize: 19, color: Colors.white, fontFamily: 'Avenir'),
                ),
              ],
            ),
          ),
        )
      ],
    );

    /*if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }*/
  }

  BottomAppBar _customBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: AppColors.COLOR_PRIMARY,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/icons/ic_cancel.png',
              height: 18,
              width: 18,
            ),
            onPressed: () {
              _onBackPress();
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/ic_change_camera.png',
              height: 18,
              width: 18,
            ),
            onPressed: () =>
                _isFrontCamera ? _setRearCamera() : _setFromCamera(),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.file(
        File(imagePath!),
        fit: BoxFit.fill,
      ),
    );
  }

  void _initCamera() async {
    WidgetsBinding.instance.addObserver(this);

    // Skip camera initialization on simulator
    if (_isSimulator) {
      print('Simulator detected - skipping camera initialization');
      return;
    }

    availableCameras().then((value) {
      cameras = value;
      if (cameras.isEmpty) {
        print('No cameras available');
        setState(() {
          _isSimulator = true;
        });
        return;
      }
      controller = CameraController(cameras[1], ResolutionPreset.medium,
          enableAudio: false);
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

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        //showInSnackBar('Camera error ${controller.value.errorDescription}');
        //showToast('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print('Camera Exception : $e');
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
        print('Image Path $imagePath');
        _submitTooth();
        //if (filePath != null) showInSnackBar('Picture saved to $filePath');
        //if (filePath != null) showToast('Picture saved to $filePath');
      }
    });
  }

  Future<String?> _takePicture() async {
    // If running on simulator, use a dummy image
    if (_isSimulator) {
      print('Simulator mode - using dummy image');
      return await _createDummyImage();
    }

    if (controller == null || !controller!.value.isInitialized) {
      //showInSnackBar('Error: select a camera first.');
      //showToast('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile picture = await controller!.takePicture();
      await picture.saveTo(filePath);
    } on CameraException catch (e) {
      print('Take Picture Exception $e');
      return null;
    }
    return filePath;
  }

  // Create a dummy image file for simulator testing
  Future<String?> _createDummyImage() async {
    try {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/dummy_${timestamp()}.txt';

      // Create a simple text file as placeholder
      // In production, you could copy an actual image from assets
      final File dummyFile = File(filePath);
      await dummyFile.writeAsString('Dummy tooth image - Simulator Mode\nTimestamp: ${timestamp()}');

      print('Created dummy image at: $filePath');
      return filePath;
    } catch (e) {
      print('Error creating dummy image: $e');
      return null;
    }
  }

  void _setFromCamera() {
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

  Widget _loadingPage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.COLOR_PRIMARY,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _onBackPress() {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_PULL_TOOTH);

     }

  void _submitTooth() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    String childId = CommonResponse.childId.toString();
    String teethNumber = CommonResponse.selectedTooth;

    String year = _currentDate.year.toString();
    String month = _currentDate.month <= 9
        ? '0${_currentDate.month}'
        : _currentDate.month.toString();
    String day = _currentDate.day <= 9
        ? '0${_currentDate.day}'
        : _currentDate.day.toString();

    String pullDate = '$year-$month-$day';

    Response response = await _apiService.pullTeethApiCall(
        childId, teethNumber, pullDate, authToken, imagePath ?? '');
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      if (responseData['status'] == 1) {
        PullToothResponse pullToothResponse =
            PullToothResponse.fromJson(responseData);

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
          contentColor: AppColors.COLOR_PRIMARY,
          duration: Duration(seconds: 3),
        );
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
