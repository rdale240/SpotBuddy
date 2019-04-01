import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geocoder/geocoder.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import './homepage.dart';





class User{
  const User({this.name, this.age, this. gender, this.interest1, this.interest2, this.interest3, this.lat, this.lon});

  final String name;
  final int age;
  final String gender;
  final String interest1;
  final String interest2;
  final String interest3;
  final double lat;
  final double lon;
}

double distCalc(double OUlat, double OUlon){
//Set User's location as UMiami
      double CUlat = 25.719168;
      double CUlon =  -80.277122;
      const Rkm = 6373;
      const Rmi = 3961;
      double dlat = OUlat - CUlat;
      double rdlat = radians(dlat);
      double dlon = OUlon - CUlon;
      double rdlon = radians(dlon);
      //double a = (pow((sin(dlat/2)),2) + cos(CUlat) * cos(OUlat) * (pow((sin(dlon/2)),2)));
      double a = (sin(rdlat/2) * sin(rdlat/2)) + cos(radians(CUlat)) * cos(radians(OUlat)) * (sin(rdlon/2) * sin(rdlon/2));
      double c = 2 * atan2(sqrt(a), sqrt(1-a));
      double d = Rkm * c;
      return d;
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
  
}

class _ListPageState extends State<ListPage> {
  List users;
  @override
  void initState(){
    users = getUsers();
    super.initState();
  }

  Widget build(BuildContext context){
 final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: Color(0xFF306856),
        title: Text(widget.title, style: TextStyle(color:Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
            )
        ],
      );
    
    makeListTile(User user) => ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right:12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))), 
        child: Icon(Icons.verified_user, color: Colors.white),
      ),
      title: Text(
        user.name, textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold),
      ),

      subtitle: Column(
                children: <Widget>[
          Text(user.age.toString() + ", " + user.gender + " | " + distCalc(user.lat, user.lon).toStringAsFixed(1) + " km away.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white)),
          Text(user.interest1 + " | " + user.interest2 + " | " + user.interest3,         
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
                ],
        ),

      trailing: 
      Container(
        padding: EdgeInsets.only(left:12.0),
        decoration: new BoxDecoration(
          border: new Border(
            left: new BorderSide(width: 1.0, color: Colors.white24))),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
        onPressed: () {
        },),
      ),
      );

       makeCard(User user) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration:BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(user),
      ),
    );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(users[index]);
        },
      ),
    );

    

    return Scaffold( 
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      );



  }

}


List getUsers(){
  return [
    User(
      name: "Alpha",
      age: 18,
      gender: 'M',
      interest1: "Sports",
      interest2: "Music",
      interest3: "Partying",
      //Coral Gables
      lat:  25.710290,
      lon: -80.268650,
    ),
    User(
      name: "Beta",
      age: 19,
      gender: 'M',
      interest1: "Sports",
      interest2: "Reading",
      interest3: "Poetry",
      //University of Miami
      lat:  25.719168,
      lon: -80.277122,
    ),
    User(
      name: "Gamma",
      age: 18,
      gender: 'M',
      interest1: "Sports",
      interest2: "Gaming",
      interest3: "E-Sports",
      //Sunset
      lat:  25.705206,
      lon: -80.286871,
    ),
    User(
      name: "Delta",
      age: 19,
      gender: 'M',
      interest1: "Gaming",
      interest2: "Music",
      interest3: "Partying",
      //Rivera Country Club
      lat:  25.728961,
      lon: -80.275665,
    ),
    User(
      name: "Epsilon",
      age: 20,
      gender: 'M',
      interest1: "Food",
      interest2: "Music",
      interest3: "Reading",
      //Coral Gables
      lat:  25.710290,
      lon: -80.268650,
    ),
  ];
}