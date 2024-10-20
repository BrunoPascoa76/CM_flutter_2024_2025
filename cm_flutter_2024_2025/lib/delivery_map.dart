import 'package:cm_flutter_2024_2025/map.dart';
import 'package:cm_flutter_2024_2025/map_zoom_cubit.dart';
import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:cm_flutter_2024_2025/secrets.dart';
import 'package:cm_flutter_2024_2025/utils/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DeliveryMapScreen extends StatelessWidget {
  const DeliveryMapScreen({super.key});

  Future<void> downloadMapRegion(BuildContext context, double rangeInKm) async {
    Position currentPosition = await Geolocator.getCurrentPosition();

    final centerCoordinate = LatLng(currentPosition.latitude,
        currentPosition.longitude); // Center coordinate
    debugPrint('started downloading region around: ${currentPosition} ');
    final region = CircleRegion(centerCoordinate, rangeInKm * 1000);

    const store = FMTCStore('mapStore');
    await store.manage.reset(); // Clear cached map data first

    final downloadableRegion = region.toDownloadable(
        minZoom: 3,
        maxZoom: 10,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: MAP_USER_AGENT_PACKAGE_NAME,
        ));
    debugPrint(store.stats.toString());
    final progressStream = store.download.startForeground(
        region: downloadableRegion,
        skipExistingTiles: true,
        maxReportInterval: const Duration(seconds: 8));

    progressStream.listen((progress) {
      if (context.mounted) {
        debugPrint(
            'Download progress: ${progress.estRemainingDuration.inMinutes} minutes remained');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Download progress: ${progress.estRemainingDuration.inMinutes} minutes remained')));
      }
    }, onDone: () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Map download complete.')),
        );
      }
    }, onError: (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $error')),
        );
      }
    });
    if (!context.mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: const MapScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'zoomIn',
            onPressed: () => context.read<MapZoomCubit>().zoomIn(),
            tooltip: 'Zoom In',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'zoomOut',
            onPressed: () => context.read<MapZoomCubit>().zoomOut(),
            tooltip: 'Zoom Out',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20),
          BlocConsumer<DeliveryRouteBloc, DeliveryRoute?>(
            listener: (context,state){
              if(state==null){
                Navigator.pop(context);
              }
            },
            builder: (context,state){
              if(state!=null){ //just as prevention
                return FloatingActionButton(
                  heroTag: "qrCode",
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QrCodeScanner())),
                  tooltip: 'Scan QR Code',
                  child: const Icon(Icons.qr_code));
                }else{
                  return const SizedBox(height: 0); //just because I need to return something
                }
              },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => downloadMapRegion(context, 1),
            tooltip: 'Download Map Data',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
