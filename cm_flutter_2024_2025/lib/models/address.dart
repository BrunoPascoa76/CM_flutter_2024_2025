import 'package:hive/hive.dart';

part 'address.g.dart';

@HiveType(typeId: 2)
class Address {
  @HiveField(0)
  int id;

  @HiveField(1)
  String street;

  @HiveField(2)
  String city;

  @HiveField(3)
  String state;

  @HiveField(4)
  int zipCode;
   
  @HiveField(5)
  String country;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  Address(this.id,this.street,this.city,this.state,this.zipCode,this.country,this.latitude,this.longitude);

  Address.fromJson(Map<String,dynamic> json):
    id=json["id"] as int,
    street=json["street"] as String,
    city=json["city"] as String,
    state=json["state"] as String,
    zipCode=json["zipCode"] as int,
    country=json["country"] as String,
    latitude=json["latitude"] as double,
    longitude=json["longitude"] as double;
}