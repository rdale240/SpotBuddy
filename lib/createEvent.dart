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
import './addInterest.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key: Key, this.uid});
  final String uid;
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition locPos = null;
  String _centerText = "Select Location";
  double _lat;
  double _long;
  String eventTitle = "";
  TextEditingController event = TextEditingController();
  String maxAttendees = "";
  String date = "";
  TextEditingController dat = TextEditingController();
  TextEditingController attendees = TextEditingController();
  String timeStart = "";
  TextEditingController tStart = TextEditingController();
  String timeEnd = "";
  TextEditingController tEnd = TextEditingController();
  String address = "";
  TextEditingController addr = TextEditingController();
  String description = "";
  TextEditingController desc = TextEditingController();
  Set<Marker> _markers = new Set();
  var url = DotEnv().env['CREATEEVENTURL'].toString();

  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  void _showDialog(String message) {
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

  _createEvent() {
    String location = address;
    print(location);
    String date = this.date;
    print(date);
    String timeStart = "1400"; //tStart.text;
    print(timeStart);
    String timeEnd = tEnd.text;
    print(timeEnd);
    String description = desc.text;
    print(description);
    String eventTitle = event.text;
    print(eventTitle);
    String maxAttendees = attendees.text;
    print(maxAttendees);

    http.post(url, body: {
      "address": location,
      "date": date,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "description": description,
      "hostUID": widget.uid,
      "maxAttendees": maxAttendees,
      "title": eventTitle,
    }).then((response) {
      print("Event - " + "Response status: ${response.statusCode}");
      print("Event - " + "Response body: ${response.body}");
      var jsonString = response.body;
      var eventIDHolder = jsonDecode(jsonString);
      print(eventIDHolder['result']['insertId']);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    EventPage(eventID: eventIDHolder['result']['insertId'].toString(), uid: widget.uid)));
      }
    });

  }
    Future<void> _animateMap() async {
      _markers.clear();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(locPos));
      _markers.add(Marker(
          position: LatLng(_lat, _long), markerId: MarkerId("Event Location")));
    }

    Future<void> queryParams(String query) async {
      //query = "1600 Amphiteatre Parkway, Mountain View";
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;

      print("${first.featureName} : ${first.coordinates}");
      setState(() {
        address = first.addressLine.toString();
        _lat = first.coordinates.latitude;
        _long = first.coordinates.longitude;
        locPos = CameraPosition(
            bearing: 0, target: LatLng(_lat, _long), tilt: 0, zoom: 17.5);
        _animateMap();
      });
    }

    Future<void> prediction() async {
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: 'AIzaSyCKF0IPwo5nC8VlNrnykvt4a0CTgkfOMs8',
          mode: Mode.overlay, // Mode.fullscreen
          language: "us",
          components: [new Component(Component.country, "us")]).then((onValue) {
        print("Friends list:" + onValue.reference);
        print("Friends list:" + onValue.description);
        print("Friends list:" + onValue.id);
        print("Friends list:" + onValue.structuredFormatting.toString());
        print("Friends list:" + onValue.matchedSubstrings.toString());
        print("Friends list:" + onValue.types.toString());
        queryParams(onValue.description);
      });
    }

    @override
    void initState() {
      super.initState();
      print("initializing");
    }

    @override
    Widget build(BuildContext context) {
      CameraPosition _userPos = CameraPosition(
          bearing: 0,
          target: LatLng(25.7192, -80.2771),
          tilt: 0,
          zoom: 19.151926040649414);
      return Scaffold(
        appBar: AppBar(
          title: Text("Create Event", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: event,
                    decoration: InputDecoration(
                      labelText: "Event Title",
                      hasFloatingPlaceholder: true,
                      filled: true,
                    ),
                    onChanged: (x) {
                      setState(() {
                        eventTitle = event.text;
                        print(eventTitle);
                      });
                    },
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: dat,
                    decoration: InputDecoration(
                      labelText: "Date MM/DD",
                      hasFloatingPlaceholder: true,
                      filled: true,
                    ),
                    onChanged: (x) {
                      setState(() {
                        date = dat.text;
                        print(date);
                      });
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "Select Date",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showDatePicker(context: context,firstDate: DateTime(2018), initialDate: DateTime.now(),lastDate: DateTime(2020)).then((onValue){
                        dat.text = onValue.toString().substring(5,10);
                        dat.text=dat.text.replaceAll("-", "/");
                      });
                    },
                    color: Color(0xFF306856),
                  ),
                  SizedBox(height: 50.0),
                  Text("Address: " + address.toString()),
                  MaterialButton(
                    child: Text(
                      "Select Location",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      prediction();
                    },
                    color: Color(0xFF306856),
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    child: GoogleMap(
                        mapType: MapType.normal,
                        markers: _markers,
                        initialCameraPosition: locPos ?? _userPos,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        }),
                    height: 300,
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: desc,
                    decoration: InputDecoration(
                      labelText: "Description",
                      filled: true,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    maxLengthEnforced: true,
                    maxLength: 500,
                    onChanged: (x) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: attendees,
                    decoration: InputDecoration(
                      labelText: "Maximum Attendees",
                      filled: true,
                    ),
                    obscureText: false,
                    onChanged: (v) {
                      maxAttendees = v;
                    },
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: tStart,
                    decoration: InputDecoration(
                      labelText: "Start Time (24hr time i.e. 12:30 PM is 1230)",
                      filled: true,
                    ),
                    obscureText: false,
                    onChanged: (x) {
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "Select Start Time",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showTimePicker(context: context,initialTime: TimeOfDay.now()).then((onValue){
                        tStart.text = onValue.toString().substring(10,15);
                        tStart.text =tStart.text.replaceAll(":", "");
                      });
                    },
                    color: Color(0xFF306856),
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: tEnd,
                    decoration: InputDecoration(
                      labelText: "End Time (24hr time i.e. 12:30 PM is 1230)",
                      filled: true,
                    ),
                    onChanged: (x) {
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "Select End Time",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showTimePicker(context: context,initialTime: TimeOfDay.now()).then((onValue){
                        tEnd.text = onValue.toString().substring(10,15);
                        tEnd.text =tEnd.text.replaceAll(":", "");
                      });
                    },
                    color: Color(0xFF306856),
                  ),
                   InterestList(widget.uid, 4,true),
                  SizedBox(height: 50),
                  MaterialButton(
                    color: Color(0xFF306856),
                    minWidth: 400,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0)),
                    child: Text(
                      "Create Event",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _createEvent();
                    },
                  ),
                 
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            )
          ],
        ),
      );
    }
  }
