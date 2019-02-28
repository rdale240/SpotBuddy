import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 0;

  void _incrementCounter() {
    var url = "http://18.191.28.138/createProfile";
    //var url = "http://18.222.104.22/createProfile";
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      http.post(url, body: {
        "first_name": "App Post",
        "email": "app@app.com",
        "pass": "******",
        "birthday": "2-5-1978",
        "messangerID": "SomeID",
        "broadLocationID": "SomeID",
        "focusedLocationID": "Some ID",
        "biography": "Posting From App",
        "isABuddy": "1",
        "publicRating": "4.6",
        "govtID": "Good Question"
      }).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            SizedBox(height: 80.0), // Space for Logo
            TextField(
              decoration: InputDecoration(
                labelText: "Username",
                filled: true,
              ),
            ),
            SizedBox(height: 80.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: null,
                  // onPressed: () {
                  //   // Navigator.push(context,
                  //   // MaterialPageRoute(builder:
                  //   // (context) => Landing(title:"SpotBuddy Landing")));
                    
                  // },
                ),
                RaisedButton(
                  child: Text("Next"),
                  onPressed: () {
                    _incrementCounter();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}