import 'package:cm_flutter_2024_2025/models/Driver.dart';
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

  DeliveryRoute(this.id);
}