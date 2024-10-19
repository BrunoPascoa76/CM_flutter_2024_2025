import 'package:cm_flutter_2024_2025/secrets.dart';
import 'package:cm_flutter_2024_2025/zoom_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  LatLng? _currentPosition;
  bool isMapRead = false;
  final openRouteService = OpenRouteService(apiKey: MAP_ORS_API_KEY);

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    debugPrint('initializing location');
    _checkLocationPermission();
    LatLng currentPosition = await _getCurrentLocation();
    setState(() {
      _currentPosition = currentPosition;
    });

    Future.delayed(const Duration(seconds: 3), () {
      _mapController.move(currentPosition, 5);
      _drawRoute(currentPosition.latitude, currentPosition.longitude);
    });
  }

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    debugPrint('current location -> ${position.latitude}');
    return LatLng(position.latitude, position.longitude);
  }

  void _drawRoute(double lat, double long) async {
    // Define start and end coordinates
    debugPrint('drawing the route');
    var startCoordinate = ORSCoordinate(latitude: lat, longitude: long);
    var endCoordinate = const ORSCoordinate(latitude: 41.15, longitude: -8.62);
    try {
      // Fetch route coordinates
      final List<ORSCoordinate> routeCoordinates =
          await openRouteService.directionsRouteCoordsGet(
        startCoordinate: startCoordinate,
        endCoordinate: endCoordinate,
      );
      // Convert ORSCoordinates to LatLng for Flutter Map
      setState(() {
        _routePoints = routeCoordinates
            .map((coord) => LatLng(coord.latitude, coord.longitude))
            .toList();
      });
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
  }

  void _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    debugPrint('checking?');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ZoomCubit, double>(
      listener: (context, zoomLevel) {
        final center = _mapController.camera.center;
        _mapController.move(center, zoomLevel);
      },
      child: BlocBuilder<ZoomCubit, double>(
        builder: (context, zoomLevel) {
          return _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentPosition ?? const LatLng(40.64, -8.65),
                    initialZoom: zoomLevel,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: MAP_USER_AGENT_PACKAGE_NAME,
                    ),
                    CurrentLocationLayer(),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 2.0,
                          color: const Color.fromARGB(255, 0, 45, 129),
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
