import 'package:cm_flutter_2024_2025/delivery_details_screen.dart';
import 'package:cm_flutter_2024_2025/delivery_map.dart';
import 'package:cm_flutter_2024_2025/utils/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'lobby.dart';
import 'map_zoom_cubit.dart';
import 'models/address.dart';
import 'models/client_details.dart';
import 'models/delivery.dart';
import 'models/delivery_route.dart';
import 'models/driver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('mapStore').manage.create();

  await Hive.initFlutter();
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(ClientDetailsAdapter());
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(DriverAdapter());
  Hive.registerAdapter(DeliveryRouteAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late PageController pageController;
  int activePageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapZoomCubit>(create: (_) => MapZoomCubit()),
        BlocProvider<QrCodeBloc>(create: (_) => QrCodeBloc()),
        BlocProvider<DeliveryRouteBloc>(create: (_) => DeliveryRouteBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/deliveryMap': (context) => PageView(
              controller: pageController,
              children: const [DeliveryDetailsScreen(), DeliveryMapScreen()]),
        },
        home: Scaffold(
          body: PageView(
            controller: pageController,
            children: const [Lobby(), DeliveryDetailsScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: activePageIndex,
            onTap: (index) {
              setState(() {
                activePageIndex = index;
              });
              pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.motorcycle),
                label: 'Lobby',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining),
                label: 'Delivery Details',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
