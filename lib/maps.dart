import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geo_location_finder/geo_location_finder.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import './eventItem.dart';
import 'package:random_string/random_string.dart' as random;
import './eventPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:permission/permission.dart';

class MapSample extends StatefulWidget {
  final String uid;

  MapSample({Key key, this.uid}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  bool permission = true;
  double _userLat;
  double _userLong;
  Set<Marker> _markers = new Set();
  Set<EventData> events = new Set();
  var eventURL = DotEnv().env['ALLEVENTSURL'].toString();

  static final EventData event1 = EventData(
      title: "Jazz Club",
      description: "Jazz in the Club",
      uid: "1",
      lat: 25.713890,
      long: -80.285570);

  static final EventData event2 = EventData(
      title: "Swensons",
      description: "Ice Cream at 7:00 PM",
      uid: "2",
      lat: 25.707640,
      long: -80.284750);
  static final EventData event3 = EventData(
      title: "All You Can Eat Nuggets",
      description: "Nuggets at 5:00 PM",
      uid: "3",
      lat: 25.715920,
      long: -80.274620);
  static final EventData event4 = EventData(
      title: "Clubbing ay LIV",
      description: "Get smashed at LIV at 10:00 PM",
      uid: "4",
      lat: 25.817043,
      long: -80.122208); // EventData
  static final EventData event5 = EventData(
      title: "Wynwood Walls",
      description: "See Cool art at 11:00 AM",
      uid: "5",
      lat: 25.801138,
      long: -80.199326);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissionStatus().then((results) {
      results.forEach((result) {
        print(result.permissionName);
        print(result.permissionStatus);
        if (result.permissionStatus == PermissionStatus.deny) {
          print("Permission Denied");
          Permission.requestPermissions([PermissionName.Location]).then( (p) {
            print(p.toString());
          });
        }
        else {
          setState(() {
           permission = false; 
          });
        }
      });
    });
    _getLocation();
  }

  Future<List<Permissions>> getPermissionStatus() async {
    List<Permissions> permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    return permissions;
  }

  Future<void> _onAddMarkerButtonPressed() async {
    http.get(eventURL).then((response) {
      print(response);
      var jsonString = '''
          [ ${response.body} ]''';
      var jsonevents = jsonDecode(jsonString);
      var listings = jsonevents[0];
      print(events);
      setState(() {
        _markers.clear();
      });
      listings.forEach((event) {
        print(event);
        var locationInfo =
            Geocoder.local.findAddressesFromQuery(event['address']);
        locationInfo.then((value) {
          var location = value.first;
          print(location.coordinates.latitude);
          print(location.coordinates.longitude);
          var position = LatLng(
              location.coordinates.latitude, location.coordinates.longitude);
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(random.randomAlpha(8)),
            position: position,
            infoWindow: InfoWindow(
                title: event['title'],
                snippet: event['description'].toString(),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EventPage(
                              eventID: event['eventID'].toString(),
                              uid: widget.uid)));
                }),
            icon: BitmapDescriptor.defaultMarker,
          ));
          setState(() {});
        });
      });
    });
  }

  Future<void> _getLocation() async {
    Map<dynamic, dynamic> locationMap;

    String result;

    var _lat;
    var _lng;

    try {
      locationMap = await GeoLocation.getLocation;
      var status = locationMap["status"];
      if ((status is String && status == "true") ||
          (status is bool) && status) {
        _lat = locationMap["latitude"];
        _lng = locationMap["longitude"];

        if (_lat is String) {
          result = "Location: ($_lat, $_lng)";
          print(result);
        } else {
          // lat and lng are not string, you need to check the data type and use accordingly.
          // it might possible that else will be called in Android as we are getting double from it.
          result = "Location: ($_lat, $_lng)";
          print(result);
        }
      } else {
        result = locationMap["message"];
        print(result);
      }
    } on PlatformException {
      result = 'Failed to get location';
      print(result);
    }

    if (!mounted) return;
    _onAddMarkerButtonPressed();
    setState(() {
      _userLat = double.parse(_lat.toString());
      _userLong = double.parse(_lng.toString());
      print(_userLat);
      print(_userLong);
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition userPos = CameraPosition(
        bearing: 0, target: LatLng(_userLat, _userLong), tilt: 0, zoom: 17.5);
    if (permission) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(child: Text("Welcome")),
      );
    } else {
      return new Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          markers: _markers,
          initialCameraPosition: userPos,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('Refresh'),
          icon: Icon(Icons.refresh),
        ),
      );
    }
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    //controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _onAddMarkerButtonPressed();
  }
}
