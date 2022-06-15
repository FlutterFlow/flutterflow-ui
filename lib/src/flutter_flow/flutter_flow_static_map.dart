import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_search/colors/color.dart' show RgbColor;
import 'package:mapbox_search/mapbox_search.dart';

import 'lat_lng.dart';

class FlutterFlowStaticMap extends StatelessWidget {
  const FlutterFlowStaticMap({
    required this.location,
    required this.apiKey,
    required this.style,
    required this.width,
    required this.height,
    this.fit,
    this.borderRadius = BorderRadius.zero,
    this.markerColor,
    this.markerUrl,
    this.cached = false,
    this.zoom = 12,
    this.tilt = 0,
    this.rotation = 0,
  });

  final LatLng location;
  final String apiKey;
  final MapBoxStyle style;
  final double width;
  final double height;
  final BoxFit? fit;
  final BorderRadius borderRadius;
  final Color? markerColor;
  final String? markerUrl;
  final bool cached;
  final int zoom;
  final int tilt;
  final int rotation;

  @override
  Widget build(BuildContext context) {
    final imageWidth = width.clamp(1, 1280).toInt();
    final imageHeight = height.clamp(1, 1280).toInt();
    final imagePath = getStaticMapImageURL(location, apiKey, style, imageWidth,
        imageHeight, markerColor, markerUrl, zoom, rotation, tilt);
    return ClipRRect(
      borderRadius: borderRadius,
      child: cached
          ? CachedNetworkImage(
              imageUrl: imagePath,
              width: width,
              height: height,
              fit: fit,
            )
          : Image.network(
              imagePath,
              width: width,
              height: height,
              fit: fit,
            ),
    );
  }
}

String getStaticMapImageURL(
  LatLng location,
  String apiKey,
  MapBoxStyle style,
  int width,
  int height,
  Color? markerColor,
  String? markerURL,
  int zoom,
  int rotation,
  int tilt,
) {
  final finalLocation = Location(
    lat: location.latitude.clamp(-90, 90).toDouble(),
    lng: location.longitude.clamp(-180, 180).toDouble(),
  );
  final finalRotation = rotation.clamp(-180, 180).round();
  final finalTilt = tilt.clamp(0, 60).round();
  final finalZoom = zoom.clamp(0, 22).round();
  final mapStyle = style;
  final image = StaticImage(apiKey: apiKey);
  if (markerColor == null && (markerURL == null || markerURL.trim().isEmpty)) {
    return image.getStaticUrlWithoutMarker(
      center: finalLocation,
      style: mapStyle,
      width: width.round(),
      height: height.round(),
      zoomLevel: finalZoom,
      bearing: finalRotation,
      pitch: finalTilt,
    );
  } else {
    return image.getStaticUrlWithMarker(
      marker: markerURL == null || markerURL.trim().isEmpty
          ? MapBoxMarker(
              markerColor: RgbColor(
                markerColor!.red,
                markerColor.green,
                markerColor.blue,
              ),
              markerLetter: MakiIcons.circle.value,
              markerSize: MarkerSize.MEDIUM,
            )
          : null,
      markerUrl: markerURL,
      center: finalLocation,
      style: mapStyle,
      width: width.round(),
      height: height.round(),
      zoomLevel: finalZoom,
      bearing: finalRotation,
      pitch: finalTilt,
    );
  }
}
