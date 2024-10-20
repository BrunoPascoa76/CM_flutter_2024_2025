import 'package:cm_flutter_2024_2025/map.dart';
import 'package:cm_flutter_2024_2025/utils/qr_code_scanner.dart';
import 'package:cm_flutter_2024_2025/zoom_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryMapScreen extends StatelessWidget {
  const DeliveryMapScreen({super.key});

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
            onPressed: () => context.read<ZoomCubit>().zoomIn(),
            tooltip: 'Zoom In',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'zoomOut',
            onPressed: () => context.read<ZoomCubit>().zoomOut(),
            tooltip: 'Zoom Out',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: "qrCode",
            onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>QrCodeScanner())),
            tooltip: 'Scan QR Code',
            child: const Icon(Icons.qr_code)
          )
        ],
      ),
    );
  }
}
