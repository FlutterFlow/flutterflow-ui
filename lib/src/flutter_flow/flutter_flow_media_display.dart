import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

const _kSupportedVideoMimes = {'video/mp4', 'video/mpeg'};

bool _isVideoPath(String path) =>
    _kSupportedVideoMimes.contains(mime(path.split('?').first));

class FlutterFlowMediaDisplay extends StatelessWidget {
  const FlutterFlowMediaDisplay({
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
