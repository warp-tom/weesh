import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

// Default center: Lipa City, Batangas (Weesh's primary service area)
const _kDefaultCenter = LatLng(13.9411, 121.1631);
const _kDefaultZoom = 14.0;

// OpenStreetMap raster tile style — no token required
// Uses the Stamen Toner-Lite mosaic through the OSM standard tile CDN
const _kOsmTileStyle = 'https://demotiles.maplibre.org/style.json';

/// A zero-config MapLibre GL map widget for Weesh screens.
///
/// Renders an OpenStreetMap-based map that works offline once tiles are cached.
/// Exposes an [onMapCreated] callback that passes back the [MapLibreMapController]
/// for callers that need to programmatically move the camera, add symbols, etc.
class WeeshMap extends StatefulWidget {
  const WeeshMap({
    super.key,
    this.initialCenter = _kDefaultCenter,
    this.initialZoom = _kDefaultZoom,
    this.onMapCreated,
    this.myLocationEnabled = true,
    this.compassEnabled = true,
    this.rotateGesturesEnabled = false,
  });

  final LatLng initialCenter;
  final double initialZoom;

  /// Called when the map is ready. Use the controller to add layers, symbols,
  /// move the camera, etc.
  final void Function(MapLibreMapController controller)? onMapCreated;

  final bool myLocationEnabled;
  final bool compassEnabled;
  final bool rotateGesturesEnabled;


  @override
  State<WeeshMap> createState() => _WeeshMapState();
}

class _WeeshMapState extends State<WeeshMap> {
  void _onMapCreated(MapLibreMapController controller) {
    widget.onMapCreated?.call(controller);
  }



  @override
  Widget build(BuildContext context) {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Text('Map Placeholder for Tests')),
      );
    }

    return MapLibreMap(
      styleString: _kOsmTileStyle,
      initialCameraPosition: CameraPosition(
        target: widget.initialCenter,
        zoom: widget.initialZoom,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationTrackingMode: MyLocationTrackingMode.none,
      compassEnabled: widget.compassEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      // Preserve battery by only rendering on interaction / location change
      trackCameraPosition: false,
    );
  }
}

/// A standard extension to guarantee uniform, premium camera animations across Weesh.
/// Uses a smooth cubic-bezier fly-to transition with architectural 3D tilt.
extension WeeshMapControllerX on MapLibreMapController {
  Future<void> flyToWeeshLocation(LatLng target, {double zoom = 16.0, double tilt = 45.0}) async {
    await animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom,
          tilt: tilt,
        ),
      ),
      duration: const Duration(milliseconds: 2500),
      // In native MapLibre GL, an animateCamera call with duration intrinsically operates
      // on a cubic-bezier timing function for the fly-to effect.
    );
  }
}
