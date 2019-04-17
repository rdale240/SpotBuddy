import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './eventPage.dart';
import './eventItem.dart';
import 'dart:convert';

class InterestView extends StatefulWidget {
 InterestView(this.uid, this.allowedInterests,this.edit);

  final String uid;
  final int allowedInterests;
  final bool edit;

  @override
  _InterestViewState createState() => _InterestViewState();
}

class _InterestViewState extends State<InterestView> {
  int _maxInterests = 0;
  List interests = [];
  TextEditingController interestOption = new TextEditingController();
  String url=DotEnv().env['GETUSERINTERESTURL'].toString();

  void initState() {
    super.initState();
    _getUserInterests();
    _maxInterests = widget.allowedInterests;
  }

  void _getUserInterests() {

    print(url);
    interests.clear();
    http.get("http://3.18.95.167/userInterest/" + "?uid="+widget.uid).then((response){
      print(response.body.toString());
      var jsonString = response.body.toString();
      var userInterests = jsonDecode(jsonString);
      print(userInterests.toString());
      userInterests.forEach((value){
        setState(() {
         interests.add(value); 
        });
      });
    });
  }

  void _alertDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Interests"),
          content: new TextField(
                controller: interestOption,
                decoration: InputDecoration(
                      labelText: "Interest",
                      hasFloatingPlaceholder: true,
                      filled: true,
                    ),               
              ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Add Interest"),
              onPressed: () {
                print(interests.toString());
                addInterest(interestOption.text);
                setState((){
                  interestOption.text="";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void addInterest(String interest) {
    if(interests.length < _maxInterests && interest != null){
      interests.add(interest);
    }
    else {
      _alertDialog("Interests are full or your interest is empty.");
      print("No More Interests");
    }
  }

  @override
  Widget build(BuildContext context) {

    makeCard(String interest) => Padding(child:Text(interest), padding:EdgeInsets.fromLTRB(0, 8, 0, 8), );

    return Container(
      height: 150,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Interests",
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
          Column(
            children: <Widget>[
              ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: interests.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (interests.isNotEmpty) {
            return makeCard(interests[index]);
          } else {
            return Text("Loading");
          }
        },
      ),

            ],
          )
        ],
      ),
    );
  }
}
