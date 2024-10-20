  import 'dart:convert';

  import 'package:cm_flutter_2024_2025/models/delivery.dart';
  import 'package:cm_flutter_2024_2025/models/driver.dart';
  import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:hive/hive.dart';

  part 'delivery_route.g.dart';

  Future<Box<DeliveryRoute>> get _currentDeliveryRouteBox async =>
    await Hive.openBox<DeliveryRoute>("current_delivery_route");

  Future<Box<Delivery>> get _pastDeliveriesBox async =>
    await Hive.openBox<Delivery>("past_deliveries");

  @HiveType(typeId: 6)
  class DeliveryRoute extends Equatable{
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
    List<Delivery> deliveries;

    @HiveField(6)
    int current_delivery=0;

    DeliveryRoute(this.id,this.deliveries);

    DeliveryRoute.copy(this.id,this.driver,this.startTime,this.endTime,this.totalDistance,this.deliveries,this.current_delivery);

    Delivery? getCurrentDelivery(){
      if (current_delivery>=deliveries.length){
        return null;
      }else{
        return deliveries[current_delivery];
      }
    }

    //will be ignoring fields I am sure are empty at starting up
    DeliveryRoute.fromJson(Map<String,dynamic> json):
      id = json["id"] as int,
      totalDistance=json["totalDistance"]==null?null:json["totalDistance"] as int,
      deliveries=(json["deliveries"] as List).map((deliveryJson)=>Delivery.fromJson(deliveryJson)).toList();
      

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

    @override
    List<Object?> get props => [id,current_delivery,deliveries];

    @override
    int get hashCode => current_delivery.hashCode ^ deliveries.hashCode;

    DeliveryRoute copywith({
      int? id,
      Driver? driver,
      DateTime? startTime,
      DateTime? endTime,
      int? totalDistance,
      List<Delivery>? deliveries,
      int? current_delivery
    }){
      return DeliveryRoute.copy(
        id??this.id,
        driver??this.driver,
        startTime??this.startTime,
        endTime??this.endTime,
        totalDistance??this.totalDistance,
        deliveries??this.deliveries,
        current_delivery??this.current_delivery
      );
    }
  }

  //current delivery route
  class DeliveryRouteBloc extends Bloc<DeliveryRouteEvent,DeliveryRoute?> {
    DeliveryRouteBloc() : super(null){
      on<DeliveryRouteReceivedEvent>(_onRouteReceived);
      on<DeliveryRouteProgressEvent>(_onRouteProgress);
    }

    Future<void> _onRouteReceived(DeliveryRouteReceivedEvent event,Emitter<DeliveryRoute?> emit) async{
      var box=await _currentDeliveryRouteBox;
      box.clear();
      box.add(event.deliveryRoute);
      emit(event.deliveryRoute);
    }

    Future<void> _onRouteProgress(DeliveryRouteProgressEvent event,Emitter<DeliveryRoute?> emit) async{
      var currentDeliveryRoute=await _currentDeliveryRouteBox;
      var pastDeliveries=await _pastDeliveriesBox;
      var deliveryRoute=state?.copywith(); //by getting the state only once, we'll be slightly safer against the state changing mid-operation

      if(deliveryRoute!=null){
        bool result=deliveryRoute.confirmCurrentDelivery(event.pin);//to make sure the state update occurs correctly
        
        currentDeliveryRoute.clear();
        //check if finished
        if(deliveryRoute.getCurrentDelivery()!=null){
          //make sure localdb is updated (in case he closes the app mid-route)
          await currentDeliveryRoute.add(deliveryRoute);
          emit(deliveryRoute);
        }else{
          pastDeliveries.addAll(deliveryRoute.deliveries);
          emit(null);
        }
      }
    }
  }


  class DeliveryRouteEvent{}
  class DeliveryRouteReceivedEvent extends DeliveryRouteEvent{
    final DeliveryRoute deliveryRoute;
    DeliveryRouteReceivedEvent(this.deliveryRoute);
  } //load current route
  class DeliveryRouteProgressEvent extends DeliveryRouteEvent{
    final int pin;
    DeliveryRouteProgressEvent(this.pin);
  } //change to next delivery (clears delivery route if it concludes last delivery)