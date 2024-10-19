import 'package:hive/hive.dart';

part 'client_details.g.dart';

@HiveType(typeId: 3)
class ClientDetails {
  @HiveField(0)
  int id;

  @HiveField(1)
  String clientName; 

  @HiveField(2)
  String phoneNumber;

  ClientDetails(this.id,this.clientName,this.phoneNumber);

  ClientDetails.fromJson(Map<String,dynamic> json):
    id=json["id"] as int,
    clientName=json["clientName"] as String,
    phoneNumber=json["phoneNumer"] as String;
}