import 'package:cm_flutter_2024_2025/delivery_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'lobby.dart';
import 'models/Address.dart';
import 'models/ClientDetails.dart';
import 'models/Delivery.dart';
import 'models/DeliveryRoute.dart';
import 'models/Driver.dart';
import 'zoom_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ZoomCubit>(create: (_) => ZoomCubit()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Lobby(),
          '/deliveryMap': (context) => const DeliveryMapScreen(),
        },
      ),
    );
  }
}
