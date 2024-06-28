import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/src/utils/lat_lng.dart' as latlng;
import 'package:google_maps_flutter/google_maps_flutter.dart';

export 'dart:async' show Completer;

export 'package:flutterflow_ui/src/utils/lat_lng.dart' show LatLng;
export 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;

enum GoogleMapStyle {
  standard,
  silver,
  retro,
  dark,
  night,
  aubergine,
}

enum GoogleMarkerColor {
  red,
  orange,
  yellow,
  green,
  cyan,
  azure,
  blue,
  violet,
  magenta,
  rose,
}

@immutable
class MarkerImage {
  const MarkerImage({
    required this.imagePath,
    required this.isAssetImage,
    this.size = 20.0,
  });
  final String imagePath;
  final bool isAssetImage;
  final double size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarkerImage &&
          imagePath == other.imagePath &&
          isAssetImage == other.isAssetImage &&
          size == other.size);

  @override
  int get hashCode => Object.hash(imagePath, isAssetImage, size);
}

class FlutterFlowMarker {
  const FlutterFlowMarker(this.markerId, this.location, [this.onTap]);
  final String markerId;
  final latlng.LatLng location;
  final Future Function()? onTap;
}

/// A widget that displays a Google Map.
class FlutterFlowGoogleMap extends StatefulWidget {
  /// Creates a [FlutterFlowGoogleMap] widget.
  const FlutterFlowGoogleMap({
    required this.controller,
    this.onCameraIdle,
    this.initialLocation,
    this.markers = const [],
    this.markerColor = GoogleMarkerColor.red,
    this.markerImage,
    this.mapType = MapType.normal,
    this.style = GoogleMapStyle.standard,
    this.initialZoom = 12,
    this.allowInteraction = true,
    this.allowZoom = true,
    this.showZoomControls = true,
    this.showLocation = true,
    this.showCompass = false,
    this.showMapToolbar = false,
    this.showTraffic = false,
    this.centerMapOnMarkerTap = false,
    super.key,
  });

  /// A [Completer] that completes with a [GoogleMapController] instance.
  final Completer<GoogleMapController> controller;

  /// An optional callback function that will be called when the camera movement
  /// has ended and the map is idle.
  final Function(latlng.LatLng)? onCameraIdle;

  /// The initial location to center the map on.
  final latlng.LatLng? initialLocation;

  /// An iterable of [FlutterFlowMarker] objects that represent markers to be
  /// displayed on the map.
  final Iterable<FlutterFlowMarker> markers;

  /// The color of the markers.
  final GoogleMarkerColor markerColor;

  /// A custom image to be used as the marker icon.
  final MarkerImage? markerImage;

  /// The type of map to be displayed.
  final MapType mapType;

  /// The style of the map.
  final GoogleMapStyle style;

  /// The initial zoom level of the map.
  final double initialZoom;

  /// Determines whether the user can interact with the map.
  final bool allowInteraction;

  /// Determines whether the user can zoom in and out of the map.
  final bool allowZoom;

  /// Determines whether to show zoom controls on the map.
  final bool showZoomControls;

  /// Determines whether to show the user's current location on the map.
  final bool showLocation;

  /// Determines whether to show a compass on the map.
  final bool showCompass;

  /// Determines whether to show a toolbar with map-related actions.
  final bool showMapToolbar;

  /// Determines whether to show traffic data on the map.
  final bool showTraffic;

  /// Determines whether to center the map on the tapped marker.
  final bool centerMapOnMarkerTap;

  @override
  State<StatefulWidget> createState() => _FlutterFlowGoogleMapState();
}

class _FlutterFlowGoogleMapState extends State<FlutterFlowGoogleMap> {
  double get initialZoom => max(double.minPositive, widget.initialZoom);
  LatLng get initialPosition =>
      widget.initialLocation?.toGoogleMaps() ?? const LatLng(0.0, 0.0);

  late Completer<GoogleMapController> _controller;
  BitmapDescriptor? _markerDescriptor;
  late LatLng currentMapCenter;

  void initializeMarkerBitmap() {
    final markerImage = widget.markerImage;

    if (markerImage == null) {
      _markerDescriptor = BitmapDescriptor.defaultMarkerWithHue(
        googleMarkerColorMap[widget.markerColor]!,
      );
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final markerImageSize = Size.square(markerImage.size);
      var imageProvider = markerImage.isAssetImage
          ? Image.asset(markerImage.imagePath).image
          : CachedNetworkImageProvider(markerImage.imagePath);
      if (!kIsWeb) {
        // workaround for https://github.com/flutter/flutter/issues/34657 to
        // enable marker resizing on Android and iOS.
        final targetHeight =
            (markerImage.size * MediaQuery.of(context).devicePixelRatio)
                .toInt();
        imageProvider = ResizeImage(
          imageProvider,
          height: targetHeight,
          policy: ResizeImagePolicy.fit,
          allowUpscaling: true,
        );
      }
      final imageConfiguration =
          createLocalImageConfiguration(context, size: markerImageSize);
      imageProvider
          .resolve(imageConfiguration)
          .addListener(ImageStreamListener((img, _) async {
        final bytes = await img.image.toByteData(format: ImageByteFormat.png);
        if (bytes != null && mounted) {
          _markerDescriptor = BitmapDescriptor.fromBytes(
            bytes.buffer.asUint8List(),
            size: markerImageSize,
          );
          setState(() {});
        }
      }));
    });
  }

  void onCameraIdle() => widget.onCameraIdle?.call(currentMapCenter.toLatLng());

  @override
  void initState() {
    super.initState();
    currentMapCenter = initialPosition;
    _controller = widget.controller;
    initializeMarkerBitmap();
  }

  @override
  void didUpdateWidget(FlutterFlowGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild the marker bitmap if the marker image changes.
    if (widget.markerImage != oldWidget.markerImage) {
      initializeMarkerBitmap();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => AbsorbPointer(
      absorbing: !widget.allowInteraction,
      child: GoogleMap(
        onMapCreated: (controller) async {
          _controller.complete(controller);
          await controller.setMapStyle(googleMapStyleStrings[widget.style]);
        },
        onCameraIdle: onCameraIdle,
        onCameraMove: (position) => currentMapCenter = position.target,
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: initialZoom,
        ),
        mapType: widget.mapType,
        zoomGesturesEnabled: widget.allowZoom,
        zoomControlsEnabled: widget.showZoomControls,
        myLocationEnabled: widget.showLocation,
        compassEnabled: widget.showCompass,
        mapToolbarEnabled: widget.showMapToolbar,
        trafficEnabled: widget.showTraffic,
        markers: widget.markers
            .map(
              (m) => Marker(
                markerId: MarkerId(m.markerId),
                position: m.location.toGoogleMaps(),
                icon: _markerDescriptor ?? BitmapDescriptor.defaultMarker,
                onTap: () async {
                  if (widget.centerMapOnMarkerTap) {
                    final controller = await _controller.future;
                    await controller.animateCamera(
                      CameraUpdate.newLatLng(m.location.toGoogleMaps()),
                    );
                    currentMapCenter = m.location.toGoogleMaps();
                    onCameraIdle();
                  }
                  await m.onTap?.call();
                },
              ),
            )
            .toSet(),
      ));
}

extension ToGoogleMapsLatLng on latlng.LatLng {
  LatLng toGoogleMaps() => LatLng(latitude, longitude);
}

extension GoogleMapsToLatLng on LatLng {
  latlng.LatLng toLatLng() => latlng.LatLng(latitude, longitude);
}

Map<GoogleMapStyle, String> googleMapStyleStrings = {
  GoogleMapStyle.standard: '[]',
  GoogleMapStyle.silver:
      r'[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]',
  GoogleMapStyle.retro:
      r'[{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]',
  GoogleMapStyle.dark:
      r'[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]',
  GoogleMapStyle.night:
      r'[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]',
  GoogleMapStyle.aubergine:
      r'[{"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#64779e"}]},{"featureType":"administrative.province","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"color":"#334e87"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#023e58"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#283d6a"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f9ba5"}]},{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#023e58"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#3C7680"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"road","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2c6675"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#b0d5ce"}]},{"featureType":"road.highway","elementType":"labels.text.stroke","stylers":[{"color":"#023e58"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"transit","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"transit.line","elementType":"geometry.fill","stylers":[{"color":"#283d6a"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#3a4762"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#4e6d70"}]}]',
};

Map<GoogleMarkerColor, double> googleMarkerColorMap = {
  GoogleMarkerColor.red: 0.0,
  GoogleMarkerColor.orange: 30.0,
  GoogleMarkerColor.yellow: 60.0,
  GoogleMarkerColor.green: 120.0,
  GoogleMarkerColor.cyan: 180.0,
  GoogleMarkerColor.azure: 210.0,
  GoogleMarkerColor.blue: 240.0,
  GoogleMarkerColor.violet: 270.0,
  GoogleMarkerColor.magenta: 300.0,
  GoogleMarkerColor.rose: 330.0,
};
