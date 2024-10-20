import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:cm_flutter_2024_2025/utils/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<StatefulWidget> createState() => DeliveryDetailsScreenState();
}

class DeliveryDetailsScreenState extends State<DeliveryDetailsScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child:BlocConsumer<DeliveryRouteBloc,DeliveryRoute?>(listener:(context,state){},builder:(context,state){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:state==null?
                const [
                  Text("All packages have been delivered!",style:TextStyle(fontSize: 20))
                ]:[
                  infoField("Name",state.deliveries[state.current_delivery].clientDetails.clientName),
                  infoField("Phone number",state.deliveries[state.current_delivery].clientDetails.phoneNumber),
                  infoField("State",state.deliveries[state.current_delivery].deliveryAddress.state),
                  infoField("City",state.deliveries[state.current_delivery].deliveryAddress.city),
                  infoField("Street",state.deliveries[state.current_delivery].deliveryAddress.street),
                  Expanded(child: Padding(
                    padding:const EdgeInsets.only(left:8,right:8,bottom:10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child:ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QrCodeScanner())),
                        label:const Text("Confirm Delivery"),
                        icon:const Icon(Icons.qr_code))
                    )
                  ))
                ]);
          })
        ),
      )
    );
  }
}

Widget infoField(String name,String value){
  return Padding(
    padding: const EdgeInsets.only(bottom:8,left:8,right:8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      Text("$name:",style:const TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
      Text(value),
    ]),
  );
}