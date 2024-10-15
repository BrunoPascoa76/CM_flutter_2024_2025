import 'package:hive/hive.dart';

part 'Address.g.dart';

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
  int zip_code;
   
  @HiveField(5)
  String country;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  Address(this.id,this.street,this.city,this.state,this.zip_code,this.country,this.latitude,this.longitude);
}