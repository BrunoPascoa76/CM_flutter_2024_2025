import 'dart:convert';

import 'package:cm_flutter_2024_2025/models/Delivery.dart';
import 'package:cm_flutter_2024_2025/models/Driver.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'DeliveryRoute.g.dart';

Future<Box<DeliveryRoute>> get _currentDeliveryRouteBox async =>
  await Hive.openBox<DeliveryRoute>("current_delivery_route");

Future<Box<Delivery>> get _pastDeliveriesBox async =>
  await Hive.openBox<Delivery>("past_deliveries");

@HiveType(typeId: 6)
class DeliveryRoute {
  @HiveField(0)
  int id;

  @HiveField(1)
  Driver? driver;

  @HiveField(2)
  DateTime? startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  int? totalDistance;

  @HiveField(5)
  List<Delivery> deliveries=[];

  @HiveField(6)
  int current_delivery=0;

  DeliveryRoute(this.id);

  Delivery? getCurrentDelivery(){
    if (current_delivery<deliveries.length){
      return null;
    }else{
      return deliveries[current_delivery];
    }
  }

  bool confirmCurrentDelivery(int pin){
    String pinHashed=sha256.convert(utf8.encode(pin.toString())).toString();
    Delivery? currentDelivery=getCurrentDelivery();

    if (currentDelivery==null){
      return false;
    }

    if(currentDelivery.pinHash==pinHashed){
      currentDelivery.status=="delivered";
      currentDelivery.actualDeliveryTime==DateTime.now();
      current_delivery+=1;
      return true;
    }else{
      return false;
    }
  }
}

//current delivery route
class DeliveryRouteBloc extends Bloc<DeliveryRouteEvent,DeliveryRoute?> {
  DeliveryRouteBloc() : super(null){
    on<DeliveryRouteLoadEvent>(_onRouteLoad);
    on<DeliveryRouteProgressEvent>(_onRouteProgress);
  }

  Future<void> _onRouteLoad(DeliveryRouteLoadEvent event,Emitter<DeliveryRoute?> emit) async{
    var box=await _currentDeliveryRouteBox;
    emit(box.get(0));
  }

  Future<void> _onRouteProgress(DeliveryRouteProgressEvent event,Emitter<DeliveryRoute?> emit) async{
    var current_delivery_route=await _currentDeliveryRouteBox;
    var past_deliveries=await _pastDeliveriesBox;
    var deliveryRoute=state; //by getting the state only once, we'll be slightly safer against the state changing mid-operation

    if(deliveryRoute!=null){
      deliveryRoute.confirmCurrentDelivery(event.pin);
      
      //check if finished
      if(deliveryRoute.getCurrentDelivery()!=null){
        //make sure localdb is updated (in case he closes the app mid-route)
        current_delivery_route.putAt(0,deliveryRoute);
        emit(state);
      }else{
        current_delivery_route.clear();
        past_deliveries.addAll(deliveryRoute.deliveries);
        emit(null);
      }
    }
  }
}


class DeliveryRouteEvent{}
class DeliveryRouteLoadEvent extends DeliveryRouteEvent{} //load current route
class DeliveryRouteProgressEvent extends DeliveryRouteEvent{
  final int pin;
  DeliveryRouteProgressEvent(this.pin);
} //change to next delivery (clears delivery route if it concludes last delivery)