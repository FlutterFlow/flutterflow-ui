import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

const _kSupportedVideoMimes = {'video/mp4', 'video/mpeg'};

bool _isVideoPath(String path) =>
    _kSupportedVideoMimes.contains(mime(path.split('?').first));

class FlutterFlowMediaDisplay extends StatelessWidget {
  /// Creates a [FlutterFlowMediaDisplay] widget.
  ///
  /// - [path] parameter specifies the path of the media content.
  /// - [imageBuilder] parameter is a function that takes a [String] path and returns a widget to display an image.
  /// - [videoPlayerBuilder] parameter is a function that takes a [String] path and returns a widget to display a video player.
  const FlutterFlowMediaDisplay({
    super.key,
    required this.path,
    required this.imageBuilder,
    required this.videoPlayerBuilder,
  });

  final String path;
  final Widget Function(String) imageBuilder;
  final Widget Function(String) videoPlayerBuilder;

  @override
  Widget build(BuildContext context) =>
      _isVideoPath(path) ? videoPlayerBuilder(path) : imageBuilder(path);
}
