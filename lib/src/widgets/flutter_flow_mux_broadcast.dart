import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';
import 'flutter_flow_widgets.dart';

/// A widget that helps to create a live stream using the Mux API.
class FlutterFlowMuxBroadcast extends StatefulWidget {
  const FlutterFlowMuxBroadcast({
    super.key,
    required this.isCameraInitialized,
    required this.isStreaming,
    required this.durationString,
    this.borderRadius = BorderRadius.zero,
    required this.controller,
    required this.videoConfig,
    required this.onCameraRotateButtonTap,
    required this.startButtonText,
    required this.onStartButtonTap,
    required this.onStopButtonTap,
    required this.startButtonOptions,
    required this.startButtonIcon,
    required this.liveText,
    required this.liveTextStyle,
    required this.liveIcon,
    required this.liveTextBackgroundColor,
    this.liveContainerBorderRadius = BorderRadius.zero,
    required this.durationTextStyle,
    required this.durationTextBackgroundColor,
    this.durationContainerBorderRadius = BorderRadius.zero,
    required this.rotateButtonIcon,
    required this.rotateButtonColor,
    required this.stopButtonColor,
    required this.stopButtonIcon,
  });

  /// Whether the camera is initialized or not.
  final bool isCameraInitialized;

  /// Whether the video is currently being streamed or not.
  final bool isStreaming;

  /// The duration of the video stream.
  final String? durationString;

  /// The border radius of the widget.
  final BorderRadius borderRadius;

  /// The controller for the live stream.
  final LiveStreamController? controller;

  /// The configuration for the video stream.
  final VideoConfig videoConfig;

  /// Callback function when the camera rotate button is tapped.
  final Function onCameraRotateButtonTap;

  /// The text for the start button.
  final String startButtonText;

  /// Callback function when the start button is tapped.
  final Function onStartButtonTap;

  /// Callback function when the stop button is tapped.
  final Function onStopButtonTap;

  /// The options for the start button.
  final FFButtonOptions startButtonOptions;

  /// The icon for the start button.
  final Widget startButtonIcon;

  /// The text for the live indicator.
  final String liveText;

  /// The style for the live indicator text.
  final TextStyle liveTextStyle;

  /// The icon for the live indicator.
  final Widget liveIcon;

  /// The background color for the live indicator.
  final Color liveTextBackgroundColor;

  /// The border radius for the live indicator container.
  final BorderRadius liveContainerBorderRadius;

  /// The style for the duration text.
  final TextStyle durationTextStyle;

  /// The background color for the duration text.
  final Color durationTextBackgroundColor;

  /// The border radius for the duration text container.
  final BorderRadius durationContainerBorderRadius;

  /// The icon for the rotate button.
  final Widget rotateButtonIcon;

  /// The color for the rotate button.
  final Color rotateButtonColor;

  /// The color for the stop button.
  final Color stopButtonColor;

  /// The icon for the stop button.
  final Widget stopButtonIcon;

  @override
  State<FlutterFlowMuxBroadcast> createState() =>
      _FlutterFlowMuxBroadcastState();
}

class _FlutterFlowMuxBroadcastState extends State<FlutterFlowMuxBroadcast>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller?.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final isStreaming = widget.controller?.isStreaming ?? false;
      if (isStreaming) {
        widget.onStopButtonTap();
      }
      widget.controller?.stop();
    } else if (state == AppLifecycleState.resumed) {
      widget.controller?.startPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCameraInitialized
        ? ClipRRect(
            borderRadius: widget.borderRadius,
            child: CameraPreview(
              controller: widget.controller!,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: widget.isStreaming
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    onTap: () => widget.onStopButtonTap(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.stopButtonColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: widget.stopButtonIcon,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => widget.onCameraRotateButtonTap(),
                                  child: CircleAvatar(
                                    radius:
                                        (widget.rotateButtonIcon as Icon).size,
                                    backgroundColor: widget.rotateButtonColor,
                                    child: Center(
                                      child: widget.rotateButtonIcon,
                                    ),
                                  ),
                                ),
                                FFButtonWidget(
                                  onPressed: () => widget.onStartButtonTap(),
                                  text: widget.startButtonText,
                                  icon: widget.startButtonIcon,
                                  options: widget.startButtonOptions,
                                )
                              ],
                            ),
                    ),
                    widget.isStreaming
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: widget.liveTextBackgroundColor,
                                  borderRadius:
                                      widget.liveContainerBorderRadius,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.liveIcon,
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.liveText,
                                        style: widget.liveTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: widget.durationTextBackgroundColor,
                                  borderRadius:
                                      widget.durationContainerBorderRadius,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    widget.durationString ?? '00:00:00',
                                    style: widget.durationTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
