import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
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

  void _login() {
    var url = DotEnv().env['SIGNINURL'].toString();
    print(url);
    //var url = "http://3.18.95.167/signin/";
    //var url = "http://18.222.104.22/createProfile";
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      http
          .get(url + '?email=' + email.text + '&pass=' + pass.text)
          .then((getResponse) {
        print("Log In - " + "Response status: ${getResponse.statusCode}");
        print("Log In - " + "Response body: ${getResponse.body}");
        var jsonString = '''
          [ ${getResponse.body} ]''';
        var acct = jsonDecode(jsonString);
        print(acct[0]['uid']);
        if (getResponse.statusCode == 200) {
          print("Log In - " + acct[0].toString());
          var acctUID = acct[0]["uid"];
          if (acct[0]["accessToken"] != null) {
            print("Log In - " + "Signing in with " + acctUID);
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomePage(title: "SpotBuddy", uid: acctUID)));
          }
        } else {
          _showDialog("Email or Password is Incorrect");
        }
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
      body: Container(
        //color: Color(0xBB2C5424),
        color: Color(0xFF306856),
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         stops: [
        //       0.1,
        //       0.3,
        //       0.7,
        //       0.9
        //     ],
        //         colors: [
        //       Colors.lightGreen[800],
        //       Colors.lightGreen[600],
        //       Colors.lightGreen[400],
        //       Colors.lightGreen[500],
        //     ])),
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
            Center(
                child: Text(
              "Login",
              style: Theme.of(context).textTheme.display2,
            )),
            SizedBox(height: 80.0), // Space for Logo
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email Address",
                filled: true,
                fillColor: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 80.0),
            TextField(
              controller: pass,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Color(0xFFFFFFFF),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 170,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: RaisedButton(
                  //color: Color(0xff2F8C3E),
                  color: Color(0xFF306856),
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.display3,
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFFFFFFF)),
                      borderRadius: new BorderRadius.circular(120.0)),
                  onPressed: () {
                    _login();
                  },
                )),
            SizedBox(
              height: 60,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: RaisedButton(
                  color: Color(0xFF306856),
                  //color: Colors.lightGreen,
                  child: Text(
                    "Back",
                    style: Theme.of(context).textTheme.display3,
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFFFFFFF)),
                      borderRadius: new BorderRadius.circular(120.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
