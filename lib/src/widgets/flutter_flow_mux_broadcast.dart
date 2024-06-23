import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';
import 'flutter_flow_widgets.dart';

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

  final bool isCameraInitialized;
  final bool isStreaming;
  final String? durationString;
  final BorderRadius borderRadius;
  final LiveStreamController? controller;
  final VideoConfig videoConfig;
  final Function onCameraRotateButtonTap;
  final String startButtonText;
  final Function onStartButtonTap;
  final Function onStopButtonTap;
  final FFButtonOptions startButtonOptions;
  final Widget startButtonIcon;
  final String liveText;
  final TextStyle liveTextStyle;
  final Widget liveIcon;
  final Color liveTextBackgroundColor;
  final BorderRadius liveContainerBorderRadius;
  final TextStyle durationTextStyle;
  final Color durationTextBackgroundColor;
  final BorderRadius durationContainerBorderRadius;
  final Widget rotateButtonIcon;
  final Color rotateButtonColor;
  final Color stopButtonColor;
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
