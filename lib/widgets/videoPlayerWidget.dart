import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final double height;
  final double width;
  final String videoPath;
  final bool isVideoLooping;

  const VideoPlayerWidget({
    required this.height,
    required this.width,
    required this.videoPath,
    this.isVideoLooping = false,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;

  late bool _isVideoLooping;

  late double _height;
  late double _width;

  late String _videoPath;

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
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            )
          : Container(),
    );
  }

  void _initController() async {
    _videoPlayerController = VideoPlayerController.asset(_videoPath);
    _videoPlayerController?.setLooping(_isVideoLooping);
    _videoPlayerController?.initialize();
    _videoPlayerController?.play();
    _videoPlayerController?.setVolume(0.0);
  }
}
