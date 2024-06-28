import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/src/utils/flutter_flow_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart' hide NavigationDecision;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// A widget that displays web content in a WebView.
class FlutterFlowWebView extends StatefulWidget {
  /// Creates a [FlutterFlowWebView] widget.
  ///
  /// - [content] parameter specifies the web content to be displayed.
  /// - [width] and [height] parameters specify the dimensions of the WebView.
  /// - [bypass] parameter determines whether to bypass the WebView and open the content in the default browser.
  /// - [horizontalScroll] parameter determines whether to enable horizontal scrolling in the WebView.
  /// - [verticalScroll] parameter determines whether to enable vertical scrolling in the WebView.
  /// - [html] parameter determines whether the content is HTML.
  const FlutterFlowWebView({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.bypass = false,
    this.horizontalScroll = false,
    this.verticalScroll = false,
    this.html = false,
  });

  /// The web content to be displayed in the WebView.
  final String content;

  /// The width of the WebView.
  final double? width;

  /// The height of the WebView.
  final double? height;

  /// Determines whether to bypass the WebView and open the content in the default browser.
  final bool bypass;

  /// Determines whether to enable horizontal scrolling in the WebView.
  final bool horizontalScroll;

  /// Determines whether to enable vertical scrolling in the WebView.
  final bool verticalScroll;

  /// Determines whether the content is HTML.
  final bool html;

  @override
  State<FlutterFlowWebView> createState() => _FlutterFlowWebViewState();
}

class _FlutterFlowWebViewState extends State<FlutterFlowWebView> {
  @override
  Widget build(BuildContext context) => WebViewX(
        key: webviewKey,
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: widget.height ?? MediaQuery.sizeOf(context).height,
        ignoreAllGestures: false,
        initialContent: widget.content,
        initialMediaPlaybackPolicy:
            AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
        initialSourceType: widget.html
            ? SourceType.html
            : widget.bypass
                ? SourceType.urlBypass
                : SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          if (controller.connector is WebViewController && isAndroid) {
            final androidController =
                controller.connector.platform as AndroidWebViewController;
            await androidController.setOnShowFileSelector(_androidFilePicker);
          }
        },
        navigationDelegate: (request) async {
          if (isAndroid) {
            if (request.content.source
                .startsWith('https://api.whatsapp.com/send?phone')) {
              String url = request.content.source;

              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        webSpecificParams: const WebSpecificParams(
          webAllowFullscreenContent: true,
        ),
        mobileSpecificParams: MobileSpecificParams(
          debuggingEnabled: false,
          gestureNavigationEnabled: true,
          mobileGestureRecognizers: {
            if (widget.verticalScroll)
              const Factory<VerticalDragGestureRecognizer>(
                VerticalDragGestureRecognizer.new,
              ),
            if (widget.horizontalScroll)
              const Factory<HorizontalDragGestureRecognizer>(
                HorizontalDragGestureRecognizer.new,
              ),
          },
          androidEnableHybridComposition: true,
        ),
      );

  Key get webviewKey => Key(
        [
          widget.content,
          widget.width,
          widget.height,
          widget.bypass,
          widget.horizontalScroll,
          widget.verticalScroll,
          widget.html,
        ].map((s) => s?.toString() ?? '').join(),
      );

  Future<List<String>> _androidFilePicker(
    final FileSelectorParams params,
  ) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }
}
