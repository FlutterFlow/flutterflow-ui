import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// A widget that displays an expanded image view.
class FlutterFlowExpandedImageView extends StatelessWidget {
  /// Creates a [FlutterFlowExpandedImageView].
  ///
  /// - [image] parameter is required and represents the image to be displayed.
  /// - [allowRotation] parameter determines whether rotation is allowed for the image.
  /// - [useHeroAnimation] parameter determines whether to use a hero animation when transitioning to the expanded image view.
  /// - [tag] parameter is an optional tag used for the hero animation.
  const FlutterFlowExpandedImageView({
    super.key,
    required this.image,
    this.allowRotation = false,
    this.useHeroAnimation = true,
    this.tag,
  });

  final Widget image;
  final bool allowRotation;
  final bool useHeroAnimation;
  final Object? tag;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: PhotoView.customChild(
                minScale: 1.0,
                maxScale: 3.0,
                enableRotation: allowRotation,
                heroAttributes: useHeroAnimation
                    ? PhotoViewHeroAttributes(tag: tag!)
                    : null,
                onScaleEnd: (context, details, value) {
                  if (value.scale! < 0.3) {
                    Navigator.pop(context);
                  }
                },
                child: image,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
