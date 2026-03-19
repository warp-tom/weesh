---
name: weesh-mapbox-patterns
description: >
  Mapbox Maps Flutter patterns for Weesh. Use when working on maps,
  location tracking, driver pins, routing overlays, or offline map tiles.
  Covers MapWidget lifecycle, annotation layers, low-signal caching.
triggers:
  - "mapbox"
  - "map"
  - "location"
  - "routing"
  - "geolocator"
  - "driver pin"
  - "annotation"
  - "offline tiles"
---

# Weesh Mapbox Patterns Skill

## Package Version (from pubspec.yaml)

```yaml
mapbox_maps_flutter: ^2.19.1
```

## MapWidget Lifecycle

Always store the `MapboxMap` controller as a field — it's needed for all
post-init operations. Dispose cleanly to avoid memory leaks.

```dart
class ActiveTripMap extends StatefulWidget { ... }

class _ActiveTripMapState extends State<ActiveTripMap> {
  MapboxMap? _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey('active_trip_map'),
      styleUri: MapboxStyles.MAPBOX_STREETS,
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(widget.center.lng, widget.center.lat)),
        zoom: 14.5,
      ),
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(MapboxMap controller) {
    _mapboxMap = controller;
    _addDriverAnnotation();
  }

  @override
  void dispose() {
    _mapboxMap = null; // let GC collect
    super.dispose();
  }
}
```

## Point Annotation Layer (Driver/Rider Pins)

Use `PointAnnotationManager` for moveable pins. One manager per pin type.

```dart
late PointAnnotationManager _driverPinManager;
late PointAnnotation _driverPin;

Future<void> _addDriverAnnotation() async {
  _driverPinManager = await _mapboxMap!.annotations
      .createPointAnnotationManager();

  final byte = await rootBundle.load('assets/icons/driver_pin.png');
  _driverPin = await _driverPinManager.create(
    PointAnnotationOptions(
      geometry: Point(coordinates: Position(driver.lng, driver.lat)),
      image: byte.buffer.asUint8List(),
      iconSize: 1.2,
    ),
  );
}

// Update pin position on location stream event
Future<void> _updateDriverPosition(LatLng newPos) async {
  await _driverPinManager.update(
    _driverPin..geometry = Point(coordinates: Position(newPos.lng, newPos.lat)),
  );
}
```

## Real-Time Location Updates → Annotation

Wire Supabase realtime driver location into the map:

```dart
// In State.initState or a ConsumerStatefulWidget's ref.listen
ref.listen(driverLocationProvider(driverId), (_, next) {
  next.whenData((latLng) => _updateDriverPosition(latLng));
});
```

## Riverpod Provider for User Location

```dart
@riverpod
Stream<LatLng> userLocation(Ref ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  ).map((pos) => LatLng(lat: pos.latitude, lng: pos.longitude));
}
```

## Offline Map Tile Caching (Province Use Case)

Pre-download a tile region when the device has connectivity before going
into a rural area:

```dart
Future<void> cacheProvinceRegion(CoordinateBounds bounds) async {
  final offlineManager = await OfflineManager.create();
  await offlineManager.loadTileRegion(
    'province_cache',
    TileRegionLoadOptions(
      geometry: bounds.toGeoJson(),
      descriptors: [TilesetDescriptor(options: TilesetDescriptorOptions(
        styleURI: MapboxStyles.MAPBOX_STREETS,
        minZoom: 10,
        maxZoom: 16,
      ))],
    ),
    (progress) => debugPrint('Cache: ${progress.completedResourceCount}/${progress.requiredResourceCount}'),
  );
}
```

Trigger this on app startup when connectivity is available, using the
region bounding box for the primary service area.

## Tricycle Custom Routing Profile

Mapbox custom profiles for tricycle routing are referenced by name in
route API calls. Use a feature flag/config until the custom profile is live:

```dart
const String kDefaultRoutingProfile = 'mapbox/driving'; // fallback
const String kTricycleRoutingProfile = 'weesh/tricycle'; // custom profile

Future<void> fetchRoute(LatLng from, LatLng to) async {
  // Use tricycle profile once published on Mapbox account
  final profileKey = kFeatureFlags.tricycleRouting
      ? kTricycleRoutingProfile
      : kDefaultRoutingProfile;
  // ... Mapbox Directions API call
}
```

## Map Style

Use the Weesh brand Map style:
- Street style for normal use: `MapboxStyles.MAPBOX_STREETS`
- Dark/night mode: `MapboxStyles.DARK`
- Satellite for delivery confirmation: `MapboxStyles.SATELLITE_STREETS`

Never use a hardcoded style URL string — use `MapboxStyles` constants.

## Checklist

- [ ] `MapboxMap` controller stored as a field, nulled on dispose
- [ ] `PointAnnotationManager` created per pin type after map init
- [ ] Location stream connected to Riverpod provider, not raw Geolocator in widget
- [ ] Offline tile cache triggered on network availability
- [ ] Public Mapbox token stored via `--dart-define=MAPBOX_PUBLIC_TOKEN=...`
  (not hardcoded)
