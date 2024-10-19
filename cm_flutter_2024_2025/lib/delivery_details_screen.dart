import 'package:cm_flutter_2024_2025/models/delivery.dart';
import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryDetailsScreen extends StatelessWidget{
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeliveryRoute? currentDelivery=context.watch<DeliveryRouteBloc>().state;
    print(currentDelivery);
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:currentDelivery==null?
              const [
                Text("All packages have been delivered!",style:TextStyle(fontSize: 20))
              ]:const [
                Text("abcdef")
              ]),
        ),
      )
    );
  }
}