import 'package:cm_flutter_2024_2025/models/address.dart';
import 'package:cm_flutter_2024_2025/models/client_details.dart';
import 'package:hive/hive.dart';

part 'delivery.g.dart';

@HiveType(typeId: 5)
class Delivery {
  @HiveField(0)
  int id;

  @HiveField(1)
  ClientDetails clientDetails;

  @HiveField(2)
  Address pickupAddress;

  @HiveField(3)
  Address deliveryAddress;

  @HiveField(5)
  String status="placed";

  @HiveField(6)
  DateTime? predictedDeliveryTime;

  @HiveField(7)
  DateTime? actualDeliveryTime;

  @HiveField(8)
  String pinHash;

  @HiveField(9)
  DateTime createdAt;

  Delivery(this.id,this.clientDetails,this.pickupAddress,this.deliveryAddress,this.pinHash,this.createdAt);

  Delivery.fromJson(Map<String,dynamic> json):
    id=json["id"] as int,
    clientDetails=ClientDetails.fromJson(json["clientDetails"]),
    pickupAddress=Address.fromJson(json["clientDetails"]),
    deliveryAddress=Address.fromJson(json["clientDetails"]),
    predictedDeliveryTime=json["predictedDeliveryTime"]==null?null:json["predictedDeliveryTime"] as DateTime,
    pinHash=json["pinHash"] as String,
    createdAt=DateTime.parse(json["createdAt"]);
}