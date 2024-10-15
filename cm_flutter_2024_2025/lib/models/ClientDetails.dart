import 'package:hive/hive.dart';

part 'ClientDetails.g.dart';

@HiveType(typeId: 3)
class ClientDetails {
  @HiveField(0)
  int id;

  @HiveField(1)
  String clientName; 

  @HiveField(2)
  int phoneNumber;

  ClientDetails(this.id,this.clientName,this.phoneNumber);
}