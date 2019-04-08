import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  var p;
  String _centerText="Select Location";
  String _latlonText="";
  Future<void> queryParams(String query) async {
    //query = "1600 Amphiteatre Parkway, Mountain View";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    
    print("${first.featureName} : ${first.coordinates}");
    setState(() {
     _centerText=first.addressLine; 
     _latlonText=first.coordinates.toString();
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
    print("initializing");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF306856),
      ),
      body: Container(
          child: GestureDetector(
        child: Center(
          child: Column(
          children: <Widget>[
            Text(_centerText),
            Text(_latlonText),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        ),
        onTap: () {
          prediction();
        },
      )),
    );
  }
}
