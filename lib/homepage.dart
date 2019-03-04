import 'package:flutter/material.dart';
import './profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "http://18.222.171.109/getProfile/";
  String fname = "";
  String bio = "";
  List list;

  void _initializePage() {
    http.get(url + '?uid=' + '14').then((response) {
      list = json.decode(response.body);
      print(list[0]["first_name"]);
      fname = list[0]["first_name"];
      bio = list[0]["biography"];
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }

  void _updatePage() {
    _initializePage();
    setState(() {});
  }

  void _goToProfile() {
    print("Hello World");
    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    _updatePage();
    return Scaffold(
        appBar: AppBar(
            title: Text("Welcome " + fname),
            backgroundColor: Color(0xFF306856),
            actions: <Widget>[
              IconButton(
                icon: Icon(IconData(58714, fontFamily: 'MaterialIcons')),
                tooltip: 'Profile',
                color: Colors.white,
                onPressed: () {
                  _goToProfile();
                },
              ),
            ]),
        drawer: Drawer(), //this will just add the Navigation Drawer Icon
        body: Center(
          child: Text("Home Page"),
        ));
  }
}
