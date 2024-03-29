import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geocoder/geocoder.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import './homepage.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geo_location_finder/geo_location_finder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class User {
  const User(
      {this.uid,
      this.name,
      this.age,
      this.gender,
      this.interest1,
      this.interest2,
      this.interest3,
      this.lat,
      this.lon});

  final String uid;
  final String name;
  final int age;
  final String gender;
  final String interest1;
  final String interest2;
  final String interest3;
  final double lat;
  final double lon;
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List users;
  double _CUlat = 25.719168;
  double _CUlon = -80.277122;
  double _lat;
  double _lon;
  List interestList = [];

  @override
  void initState() {
    //_getLocation();
    print(users);
    super.initState();
  }
_getInterests(String uid) async {


    http.get("http://3.18.95.167/getProfileInterests?uid="+uid).then((response) {
      var jsonString = response.body.toString();
        var interests = jsonDecode(jsonString);
        print(interests);
        interests.forEach( (f) {
          interestList.add(f['interest']);
          print(interestList);
        });
        
    });
  }

  Future<List> getUsers() async {
    if (users == null) {
      List userList = [];
      var locationResults;
      double lat;
      double long;
      var profiles;
      //
           interestList.clear(); 
      var url = DotEnv().env['ALLUSERSURL'].toString();
      await http.get(url).then((response) {
        var jsonString = response.body.toString();
        profiles = jsonDecode(jsonString);
        print(profiles);
        profiles.forEach((user) {
          _getInterests(user['uid'].toString());
          print(user);
          var loc = user['focusedLocationID'].split(',');
          print(loc);
          
          
          userList.add(User(
              uid: user['uid'].toString(),
              age: 21,
              name: user['first_name'],
              gender: "M/F",
              lat: double.parse(loc[0]),
              lon: double.parse(loc[1]),
              interest1: "Interest 1",
              interest2: "Interest 2",
              interest3: "Interest 3"));
        });
        print(userList);
      });

      print(userList);
      setState(() {
        users = userList;
      });
    } else {}
  }

  Future<LatLng> queryParams(String query) async {
    //query = "1600 Amphiteatre Parkway, Mountain View";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;

    print("${first.featureName} : ${first.coordinates}");
    setState(() {
      _lat = first.coordinates.latitude;
      _lon = first.coordinates.longitude;
    });
    return LatLng(_lat, _lon);
  }

  double distCalc(double OUlat, double OUlon) {
//Set User's location as UMiami
    print("Latitude calc: " + _CUlat.toString());
    print("Longitude calc: " + _CUlon.toString());
    const Rkm = 6373;
    const Rmi = 3961;
    double dlat = OUlat - _CUlat;
    double rdlat = radians(dlat);
    double dlon = OUlon - _CUlon;
    double rdlon = radians(dlon);
    //double a = (pow((sin(dlat/2)),2) + cos(CUlat) * cos(OUlat) * (pow((sin(dlon/2)),2)));
    double a = (sin(rdlat / 2) * sin(rdlat / 2)) +
        cos(radians(_CUlat)) *
            cos(radians(OUlat)) *
            (sin(rdlon / 2) * sin(rdlon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = Rkm * c;
    return d * 1.609;
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Message"),
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

  // Future<void> _getLocation() async {
  //   Map<dynamic, dynamic> locationMap;

  //   String result;

  //   var _lat;
  //   var _lng;

  //   try {
  //     locationMap = await GeoLocation.getLocation;
  //     var status = locationMap["status"];
  //     if ((status is String && status == "true") ||
  //         (status is bool) && status) {
  //       _lat = locationMap["latitude"];
  //       _lng = locationMap["longitude"];

  //       if (_lat is String) {
  //         result = "Location: ($_lat, $_lng)";
  //         _CUlat = double.parse(_lat);
  //         _CUlon = double.parse(_lng);
  //         print(result);
  //       } else {
  //         // lat and lng are not string, you need to check the data type and use accordingly.
  //         // it might possible that else will be called in Android as we are getting double from it.
  //         result = "Location: ($_lat, $_lng)";
  //         print(result);
  //       }
  //     } else {
  //       result = locationMap["message"];
  //       print(result);
  //     }
  //   } on PlatformException {
  //     result = 'Failed to get location';
  //     print(result);
  //   }
  // }

  Widget build(BuildContext context) {
    var SBGreen = DotEnv().env['SBGREEN'].toString();
    var friendshipURL = DotEnv().env['CREATEFRIENDURL'].toString();
    getUsers();

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color(0xFF306856),
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
        )
      ],
    );

    makeListTile(User user) {
      print(user.name);
      return ListTile(
        isThreeLine: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Color(0xFF306856)))),
          child: Icon(Icons.verified_user, color: Colors.black),
        ),
        title: Text(
          user.name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: <Widget>[
            Text(
                user.age.toString() +
                    ", " +
                    user.gender +
                    " | " +
                    distCalc(user.lat, user.lon).toStringAsFixed(1) +
                    " mi away.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)),
            Text(
                user.interest1 +
                    " | " +
                    user.interest2 +
                    " | " +
                    user.interest3,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.only(left: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  left: new BorderSide(width: 1.0, color: Color(0xFF306856)))),
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              http.post(friendshipURL, body: {
                "sender": widget.uid,
                "receiver": user.uid
              }).then((result) {
                print(result);
                _showDialog("Added Friend");
              });
            },
          ),
        ),
      );
    }

    makeCard(User user) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
            child: makeListTile(user),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          print(users);
          if (!users.isEmpty) {
            getUsers();
            return makeCard(users[index]);
          } else {
            return Text("Loading");
          }
        },
      ),
    );

    if (users == null || users.isEmpty) {
      return Scaffold(
        appBar: topAppBar,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Center(
          child: Text("Loading"),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body: makeBody,
      );
    }
  }
}

//List regularData = [
//   User(
//     name: "Alpha",
//     age: 18,
//     gender: 'M',
//     interest1: "Sports",
//     interest2: "Music",
//     interest3: "Partying",
//     //Coral Gables
//     lat: 25.710290,
//     lon: -80.268650,
//   ),
//   User(
//     name: "Beta",
//     age: 19,
//     gender: 'M',
//     interest1: "Sports",
//     interest2: "Reading",
//     interest3: "Poetry",
//     //University of Miami
//     lat: 25.719168,
//     lon: -80.277122,
//   ),
//   User(
//     name: "Gamma",
//     age: 18,
//     gender: 'M',
//     interest1: "Sports",
//     interest2: "Gaming",
//     interest3: "E-Sports",
//     //Sunset
//     lat: 25.705206,
//     lon: -80.286871,
//   ),
//   User(
//     name: "Delta",
//     age: 19,
//     gender: 'M',
//     interest1: "Gaming",
//     interest2: "Music",
//     interest3: "Partying",
//     //Rivera Country Club
//     lat: 25.728961,
//     lon: -80.275665,
//   ),
//   User(
//     name: "Epsilon",
//     age: 20,
//     gender: 'M',
//     interest1: "Food",
//     interest2: "Music",
//     interest3: "Reading",
//     //Coral Gables
//     lat: 25.710290,
//     lon: -80.268650,
//   ),
// ];
