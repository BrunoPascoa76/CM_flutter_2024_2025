import 'package:hive/hive.dart';

part 'driver.g.dart';

@HiveType(typeId: 1) //typeId should be unique for each model
class Driver {
  @HiveField(0)
  int id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String passwordHash;

  @HiveField(3)
  String email;

  @HiveField(4)
  int phoneNumber;

  @HiveField(5)
  String licenseNumber;

  @HiveField(6)
  String vehicleType;

  Driver(this.id,this.username,this.passwordHash,this.email,this.phoneNumber,this.licenseNumber,this.vehicleType);  
}