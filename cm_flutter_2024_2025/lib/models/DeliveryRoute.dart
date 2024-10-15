import 'dart:convert';

import 'package:cm_flutter_2024_2025/models/Delivery.dart';
import 'package:cm_flutter_2024_2025/models/Driver.dart';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

part 'DeliveryRoute.g.dart';

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