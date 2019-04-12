import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import './eventItem.dart';
import 'dart:convert';
import './otherProfile.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;

class EventPage extends StatefulWidget {
  final String eventID;
  //final EventData eventData;
  final String uid;



  EventPage({Key key, this.eventID
  , this.uid})
      : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  double _hostRating;
  var event;
  var user;
  String _hostName = "";
  String _hostLocation = "";
  String _title = "";
  String _timeString = "";
  String _description = "";
  String _address = "";

  void initState() {
    super.initState();
    _getEvent();
    setState(() {});
  }

  _getEvent() {
    http
        .get('http://3.18.95.167/getEvent' + '?eventID=' + widget.eventID)
        .then((getResponse) {
      print("Get Event - " + "Response status: ${getResponse.statusCode}");
      print("Get Event - " + "Response body: ${getResponse.body}");
      var jsonString = '''
          ${getResponse.body}''';
      event = jsonDecode(jsonString);
      print(event[0]);
      //print(event[0]['eventID']);
      if (getResponse.statusCode == 200) {
        setState(() {
          _title = event[0]['title'];
          _timeString = event[0]['timeStart'].toString() +
              ' -  ' +
              event[0]['timeEnd'].toString();
          _description = event[0]['description'];
          _address = event[0]['address'];
        });
        _getProfile(event);
        print("Log In - " + event[0].toString());
      } else {
        Navigator.pop(context);
      }
    });
  }

  _getProfile(event) {
    http
        .get('http://3.18.95.167/getProfile' + '?uid=' + event[0]['hostUID'])
        .then((getResponse) {
      print("Get Event - " + "Response status: ${getResponse.statusCode}");
      print("Get Event - " + "Response body: ${getResponse.body}");
      var jsonString = '''
          ${getResponse.body}''';
      user = jsonDecode(jsonString);
      print(user[0]['first_name']);
      if (getResponse.statusCode == 200) {
        setState(() {
          _hostName = user[0]['first_name'];
          _hostLocation = user[0]['broadLocationID'];
          _hostRating = user[0]['publicRating'];
        });
        print(_hostRating);
        print("Log In - " + user[0].toString());
      } else {}
    });
  }

  void _goToHome() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Added"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                _goToHome();
              },
            ),
          ],
        );
      },
    );
  }

  _joinEvent() {
    print(widget.uid);
    print("Join event press");
    http.post('http://3.18.95.167/attendEvent', body: {
      "eventID": event[0]["eventID"].toString(),
      "hostUID": event[0]["hostUID"].toString(),
      "requesterID": widget.uid.toString(),
      "status": 2.toString()
    }).then((response) {
      setState(() {
        _showDialog("Attending Event");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _tempRating = 4.8;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Hangout", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
        ),
        body: ListView(
          children: <Widget>[
            //Image.network('http://www.xanjero.com/wp-content/uploads/2018/07/Google-Image-Search.png',
            Row(children: <Widget>[
              Container(
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/restaurant.jpg'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
            ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * .65,
                      height: MediaQuery.of(context).size.width * .35,
                      child: Padding(
                        child: Text(
                          _title,
                          style: Theme.of(context).textTheme.display1,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Padding(
                      child: GestureDetector(
                        child: Column(children: <Widget>[
                          Text("Hosted By",
                              style: Theme.of(context).textTheme.body1),
                          Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: MediaQuery.of(context).size.width * .2,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                backgroundImage:
                                    AssetImage('./assets/user.png'),
                                radius: MediaQuery.of(context).size.width * .1,
                              )),
                          Text(_hostName,
                              style: Theme.of(context).textTheme.body1),
                          Text(_hostLocation,
                              style: Theme.of(context).textTheme.body1),
                          SmoothStarRating(
                            allowHalfRating: true,
                            // onRatingChanged: (v) {
                            //   _userRating = v;
                            //   setState(() {});
                            // },
                            starCount: 5,
                            rating: _hostRating ?? _tempRating,
                            size: 20.0,
                            color: Colors.yellow,
                            borderColor: Colors.green,
                          )
                        ]),
                        onTap: () {
                          print("Profile Tapped");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OtherProfilePage(
                                          title: "Host Profile",
                                          uid: user[0]["uid"].toString(),
                                          userUID: widget.uid,)));
                        },
                      ),
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    ),
                  )
                ]),

            Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Time: " + _timeString.toString()),
                    SizedBox(
                      height: 24,
                    ),
                    Text("Location: " + _address),
                    SizedBox(
                      height: 24,
                    ),
                    Text(_description),
                    SizedBox(
                      height: 24,
                    ),
                    Text("Interest Tags"),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(random.randomAlpha(8) + "     ",
                            style: Theme.of(context).textTheme.body1),
                        Text(random.randomAlpha(8) + "      ",
                            style: Theme.of(context).textTheme.body1),
                        Text(random.randomAlpha(8) + "     ",
                            style: Theme.of(context).textTheme.body1),
                      ],
                    )
                  ],
                )),
            SizedBox(height: 10),
            MaterialButton(
              child: Text(
                "Request to Join",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              color: Color(0xFF306856),
              minWidth: 200,
              height: 60,
              clipBehavior: Clip.antiAlias,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0)),
              onPressed: () {
                _joinEvent();
              },
            ),
          ],
        ));
  }
}
