import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class FlutterFlowPdfViewer extends StatefulWidget {
  const FlutterFlowPdfViewer({
    Key? key,
    this.networkPath,
    this.assetPath,
    this.width,
    this.height,
    this.horizontalScroll = false,
  })  : assert((networkPath != null) ^ (assetPath != null)),
        super(key: key);

  final String? networkPath;
  final String? assetPath;
  final double? width;
  final double? height;
  final bool horizontalScroll;

  @override
  _FlutterFlowPdfViewerState createState() => _FlutterFlowPdfViewerState();
}

class _FlutterFlowPdfViewerState extends State<FlutterFlowPdfViewer> {
  PdfController? controller;
  String get networkPath => widget.networkPath ?? '';
  String get assetPath => widget.assetPath ?? '';

  void initializeController() =>
      controller = networkPath.isNotEmpty || assetPath.isNotEmpty
          ? PdfController(
              document: assetPath.isNotEmpty
                  ? PdfDocument.openAsset(assetPath)
                  : PdfDocument.openData(InternetFile.get(networkPath)),
            )
          : null;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void didUpdateWidget(FlutterFlowPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.networkPath != widget.networkPath) {
      initializeController();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width,
        height: widget.height,
        child: controller != null
            ? PdfView(
                controller: controller!,
                scrollDirection:
                    widget.horizontalScroll ? Axis.horizontal : Axis.vertical,
                builders: PdfViewBuilders<DefaultBuilderOptions>(
                  options: DefaultBuilderOptions(),
                  documentLoaderBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  pageLoaderBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  errorBuilder: (_, __) => Container(),
                ),
              )
            : Container(),
      );
}
