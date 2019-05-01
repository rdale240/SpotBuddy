import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:permission/permission.dart';
import 'package:flutter/services.dart';
// import 'package:location/location.dart';

class PermissionPage extends StatefulWidget {
  PermissionPage({Key key}) : super(key: key);
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  //Future<PermissionStatus> locStatus;
  bool locStatus;

  Future<void> getLocationPermission() async {
     //locStatus = await Location().hasPermission(); 
  }
  void initState(){
    super.initState();
  //   setState(() {
  //    locStatus= checkLocationPermision();
  //   });
  // print(locStatus.toString());
  }
  // Future<PermissionStatus> checkLocationPermision() {
  //   return PermissionHandler().checkPermissionStatus(PermissionGroup. location);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(child: Text("Welcome")),
    );
  }
}
