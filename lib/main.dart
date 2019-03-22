import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './login.dart';
import './signup.dart';
import './homepage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './profile.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  
  runApp(MyApp());
  await DotEnv().load('.env');
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.lightGreen,
          textTheme: TextTheme(
            body1: new TextStyle(color: Colors.black),
            display1: new TextStyle(color: Colors.white),
            display2: new TextStyle(color: Colors.white),
            display3: new TextStyle(color: Colors.white),
            display4: new TextStyle(color: Colors.white),
            body2: new TextStyle(color: Colors.white),
            headline: new TextStyle(color: Colors.white),
            title: new TextStyle(color: Colors.black, fontSize: 48),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Landing(title: "Spotbuddy"),
          '/login': (context) => LoginPage(title: "Spotbuddy Login"),
          '/signin': (context) => SignUpPage(title: "Spotbuddy Sign Up"),
          '/home': (context) => HomePage(title: "Spotbuddy"),
          '/profile': (context) => ProfilePage(title: "Profile"),
        });
  }
}

class Landing extends StatefulWidget {
  Landing({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LandingState createState() => _LandingState();
  final String title;
  final String logoAsset = 'assets/SpotBuddy_Logo_T.png';
  final Color logoColor = Color(0xFF306856);
}

class _LandingState extends State<Landing> {
  void _Log() {
    print("Landing - " +'Login Press');
  }

  void _Create() {
    print("Landing - " + 'Create Press');
  }

  Future pageLog() async {
    var file = new File('Logs/Log.txt');
    var contents = file.openWrite();
    contents.write("SpotBuddy App Launched");
    contents.flush();
    contents.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageLog();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
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
            SizedBox(height: 120.0),
            Container(
                child: new Text('SpotBuddy',
                    style: Theme.of(context).textTheme.title),
                alignment: Alignment(0.0, 0.0)),
            Image.asset(
              widget.logoAsset,
              height: 360.0,
            ), // Space for Logo
            SizedBox(height: 0),
            MaterialButton(
              child: Text(
                "Login",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              color: widget.logoColor,
              minWidth: 200,
              height: 80,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0)),
              onPressed: () {
                _Log();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(title: "SpotBuddy Login")));
              },
            ),
            SizedBox(height: 40.0),
            MaterialButton(
              child: Text(
                "Sign Up",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              color: widget.logoColor,
              minWidth: 200,
              height: 80,
              clipBehavior: Clip.antiAlias,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0)),
              onPressed: () {
                _Create();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignUpPage(title: "SpotBuddy Sign Up")));
              },
            ),
          ],
        ),
      ),
    );
  }
}
