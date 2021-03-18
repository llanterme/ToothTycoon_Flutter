import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final double height;
  final double width;
  final String videoPath;
  final bool isVideoLooping;

  VideoPlayerWidget(
      {this.height, this.width, this.videoPath, this.isVideoLooping = false});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _videoPlayerController;

  bool _isVideoLooping = false;

  double _height = 0;
  double _width = 0;

  String _videoPath = '';

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _width = widget.width;
    _videoPath = widget.videoPath;
    _isVideoLooping = widget.isVideoLooping;
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.COLOR_PRIMARY,
      height: _height,
      width: _width,
      child: _videoPlayerController != null
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.size != null
                  ? _videoPlayerController.value.aspectRatio
                  : 1.0,
              child: VideoPlayer(_videoPlayerController),
            )
          : Container(),
    );
  }

  void _initController() async {
    _videoPlayerController = VideoPlayerController.asset(_videoPath);
    _videoPlayerController.setLooping(_isVideoLooping);
    _videoPlayerController.initialize();
    _videoPlayerController.play();
    _videoPlayerController.setVolume(0.0);
  }
}
