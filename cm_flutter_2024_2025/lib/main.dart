import 'package:cm_flutter_2024_2025/map.dart';
import 'package:cm_flutter_2024_2025/models/Address.dart';
import 'package:cm_flutter_2024_2025/models/ClientDetails.dart';
import 'package:cm_flutter_2024_2025/models/Delivery.dart';
import 'package:cm_flutter_2024_2025/models/DeliveryRoute.dart';
import 'package:cm_flutter_2024_2025/models/Driver.dart';
import 'package:cm_flutter_2024_2025/utils/QrCodeScanner.dart';
import 'package:cm_flutter_2024_2025/zoom_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(ClientDetailsAdapter());
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(DriverAdapter());
  Hive.registerAdapter(DeliveryRouteAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ZoomCubit>(create: (_) => ZoomCubit()),
          BlocProvider<QrCodeBloc>(create: (_)=>QrCodeBloc()),
          BlocProvider<DeliveryRouteBloc>(create: (_)=>DeliveryRouteBloc()),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            onPressed: () => context.read<ZoomCubit>().zoomIn(),
            tooltip: 'Zoom In',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<ZoomCubit>().zoomOut(),
            tooltip: 'Zoom Out',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
