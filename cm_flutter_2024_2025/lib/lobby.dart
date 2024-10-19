import 'models/Address.dart';
import 'models/ClientDetails.dart';
import 'models/Delivery.dart';
import 'models/DeliveryRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  LobbyState createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  bool isReady = false;

  void _onReadyPressed(DeliveryRouteBloc DeliveryRouteBloc) {
    //handle ready stuff
    isReady = true;
    if (isReady) {
      Delivery delivery1 = Delivery(
        1,
        ClientDetails(
          101,
          "João Silva",
          "+351 912 345 678"
        ),
        Address(
          201,
          "Rua das Flores, 123",
          "Lisboa",
          "Lisboa",
          1000,
          "Portugal",
          38.7223, 
          -9.1393
        ),
        Address(
          202,
          "Avenida da Liberdade, 456",
          "Lisboa",
          "Lisboa",
          1250,
          "Portugal",
          38.7184,
          -9.1418
        ),
        "abc123", // pinHash
        DateTime.now()
      );        

      Delivery delivery2 = Delivery(
        2,
        ClientDetails(
          102,
          "Maria Santos",
          "+351 923 456 789"
        ),
        Address(
          203,
          "Rua do Comércio, 78",
          "Porto",
          "Porto",
          4050,
          "Portugal",
          41.1494,
          -8.6107
        ),
        Address(
          204,
          "Praça da Ribeira, 90",
          "Porto",
          "Porto",
          4050,
          "Portugal",
          41.1409,
          -8.6132
        ),
        "xyz789", // pinHash
        DateTime.now()
      );

      DeliveryRoute deliveryRoute=DeliveryRoute(1,[delivery1,delivery2]);
      DeliveryRouteBloc.add(DeliveryRouteReceivedEvent(deliveryRoute));
      Navigator.pushNamed(context, '/deliveryMap');
    } else {
      // Handle the condition when not ready
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not ready yet!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryRouteBloc=BlocProvider.of<DeliveryRouteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){_onReadyPressed(deliveryRouteBloc);},
          child: const Text('Ready to deliver'),
        ),
      ),
    );
  }
}