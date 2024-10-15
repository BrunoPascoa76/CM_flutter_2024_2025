import 'package:cm_flutter_2024_2025/models/Address.dart';
import 'package:cm_flutter_2024_2025/models/ClientDetails.dart';
import 'package:cm_flutter_2024_2025/models/DeliveryRoute.dart';
import 'package:hive/hive.dart';

part 'Delivery.g.dart';

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

  @HiveField(4)
  DeliveryRoute route;

  @HiveField(5)
  String status="placed";

  @HiveField(6)
  DateTime? predictedDeliveryTime;

  @HiveField(7)
  DateTime? actualDeliveryTime;

  @HiveField(8)
  String? pinHash;


  @HiveField(9)
  DateTime createdAt;

  Delivery(this.id,this.clientDetails,this.pickupAddress,this.deliveryAddress,this.route,this.createdAt);
}