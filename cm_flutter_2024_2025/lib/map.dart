import 'package:cm_flutter_2024_2025/map_zoom_cubit.dart';
import 'package:cm_flutter_2024_2025/models/address.dart';
import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:cm_flutter_2024_2025/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      context.read<MapZoomCubit>().setZoom(15);
      _mapController.move(currentPosition, context.read<MapZoomCubit>().state);
      final Address destinationAddress = context
          .read<DeliveryRouteBloc>()
          .state!
          .getCurrentDelivery()!
          .deliveryAddress;
      final LatLng deliveryLatLong =
          LatLng(destinationAddress.latitude, destinationAddress.longitude);
      _drawRoute(currentPosition, deliveryLatLong);
    });
  }

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    debugPrint('current location -> ${position.latitude}');
    return LatLng(position.latitude, position.longitude);
  }

  void _drawRoute(LatLng start, LatLng end) async {
    // Define start and end coordinates
    debugPrint('drawing the route');
    var startCoordinate =
        ORSCoordinate(latitude: start.latitude, longitude: start.longitude);
    var endCoordinate =
        ORSCoordinate(latitude: end.latitude, longitude: end.longitude);
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

      // Calculate the bearing (direction) from start to end
      double bearing = Geolocator.bearingBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );
      if (!mounted) return;
      // Move the camera to the start position with the correct bearing
      _mapController.moveAndRotate(
          start, context.read<MapZoomCubit>().state, bearing);
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
    return BlocListener<MapZoomCubit, double>(
      listener: (context, zoomLevel) {
        final center = _mapController.camera.center;
        _mapController.move(center, zoomLevel);
      },
      child: BlocBuilder<MapZoomCubit, double>(
        builder: (context, zoomLevel) {
          return _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentPosition ?? const LatLng(40.64, -8.65),
                    initialZoom: context.read<MapZoomCubit>().state,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        context.read<MapZoomCubit>().setZoom(position.zoom);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: MAP_USER_AGENT_PACKAGE_NAME,
                      tileProvider:
                          const FMTCStore('mapStore').getTileProvider(),
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
