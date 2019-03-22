import 'package:flutter/material.dart';
import './profile.dart';
import './maps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  final String title;
  final String uid;
  HomePage({Key key, this.title, this.uid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "http://3.18.95.167/getProfile/";
  String fname = "";
  String bio = "";
  List list;


  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializePage();
  }

  

  void _initializePage() {
    print("HomePage  - " + widget.uid);
    http.get(url + '?uid=' + widget.uid).then((response) {
      list = json.decode(response.body) as List;
      print(list[0]["first_name"]);
      print("HomePage  - " + "Response status: ${response.statusCode}");
      print("HomePage  - " + "Response body: ${response.body}");
      setState(() {
        fname = list[0]["first_name"];
        bio = list[0]["biography"];
      });
    });
  }

  void _updatePage() {
    _initializePage();
    print("List: ${this.list}");
  }

  void _goToProfile() {
    print("Hello World");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProfilePage(title: fname + "'s Profile", uid: widget.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF306856),
            iconTheme: new IconThemeData(color: Colors.white),
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
          child: MapSample(),
        ));
  }
}
