import 'package:cm_flutter_2024_2025/delivery_details_screen.dart';
import 'package:cm_flutter_2024_2025/delivery_map.dart';
import 'package:cm_flutter_2024_2025/utils/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'lobby.dart';
import 'models/address.dart';
import 'models/client_details.dart';
import 'models/delivery.dart';
import 'models/delivery_route.dart';
import 'models/driver.dart';
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
    final pageController = PageController(
      initialPage: 1,
      keepPage: true
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<ZoomCubit>(create: (_) => ZoomCubit()),
        BlocProvider<QrCodeBloc>(create: (_)=>QrCodeBloc()),
        BlocProvider<DeliveryRouteBloc>(create: (_)=>DeliveryRouteBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Lobby(),
          '/deliveryMap': (context) => PageView(
            controller:pageController,
            children:const [DeliveryDetailsScreen(),DeliveryMapScreen()]
          ),
        },
      ),
    );
  }
}
