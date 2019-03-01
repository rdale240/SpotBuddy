import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController bday = TextEditingController();
  TextEditingController dln = TextEditingController();

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

  void _submitInfo() {
    var url = "http://18.223.190.192/createProfile";
    //var url = "http://18.222.104.22/createProfile";
    setState(() {
      if (fname.text == "") {
        _showDialog("First Name is not valid");
        return;
      } else if (email.text == "") {
        _showDialog("Email is not valid");
        return;
      } else if (pass.text == "") {
        _showDialog("Password is not valid");
        return;
      } else if (bday.text == "") {
        _showDialog("Birthday is not valid");
        return;
      } else if (dln.text == "") {
        _showDialog("Drivers License Number is not valid");
        return;
      }

      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      print("first_name: " + fname.text);
      String nameParam = fname.text;
      print("email: " + email.text);
      String emailParam = email.text;
      print("pass: " + pass.text);
      String passParam = pass.text;
      print("bday: " + bday.text);
      String bdayParam = bday.text;
      print("dln: " + dln.text);
      String dlnParam = dln.text;

      String messangerID = random.randomAlphaNumeric(16);
      String broadLocationID = random.randomAlphaNumeric(16);
      String focusedLocationID = random.randomAlphaNumeric(16);
      String biography = random.randomAlphaNumeric(100);
      String isABuddy = "0";
      String publicRating = "5.0";

      http.post(url, body: {
        "first_name": nameParam,
        "email": emailParam,
        "pass": passParam,
        "birthday": bdayParam,
        "messangerID": messangerID,
        "broadLocationID": broadLocationID,
        "focusedLocationID": focusedLocationID,
        "biography": biography,
        "isABuddy": isABuddy,
        "publicRating": publicRating,
        "govtID": dlnParam
      }).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        String getURL = "http://18.223.190.192/signin/";
        if (response.statusCode == 200) {
          http
              .get(getURL + '?email=' + email.text + '&pass=' + pass.text)
              .then((getResponse) {
            print("Response status: ${getResponse.statusCode}");
            print("Response body: ${getResponse.body}");
            var jsonString = '''
          [ ${getResponse.body} ]''';
            var scores = jsonDecode(jsonString);
            if (getResponse.statusCode == 200) {
              print(scores[0]);
              if (scores[0]["accessToken"] != null) {
                print("Signing in");
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.pushReplacementNamed(context, '/home');
              }
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Center(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          //  RichText(
          //   text: TextSpan(text: 'First Name',
          //   style:TextStyle(color: Colors.black),
          //   children: [
          //     TextSpan(
          //         text: ' *',
          //         style: TextStyle(
          //           color: Colors.red,
          //         ))
          //   ]),
          // ),
          SizedBox(height: 50.0),
          TextField(
            controller: fname,
            decoration: InputDecoration(
              labelText: "First Name",
              hasFloatingPlaceholder: true,
              filled: true,
            ),
          ),
          SizedBox(height: 50.0),
          TextField(
            controller: email,
            decoration: InputDecoration(
              hasFloatingPlaceholder: true,
              labelText: "Email",
              filled: true,
            ),
          ),
          SizedBox(height: 50.0),
          TextField(
            controller: pass,
            decoration: InputDecoration(
              labelText: "Password",
              filled: true,
            ),
            obscureText: true,
          ),
          SizedBox(height: 50.0),
          TextField(
            controller: bday,
            decoration: InputDecoration(
              labelText: "Birthday",
              filled: true,
            ),
          ),
          SizedBox(height: 50.0),
          TextField(
            controller: dln,
            decoration: InputDecoration(
              labelText: "Drivers License Number",
              filled: true,
            ),
            obscureText: true,
          ),
          SizedBox(height: 50.0),
          MaterialButton(
            child: Text("Create Account"),
            color: Colors.lightGreen,
            minWidth: 200,
            height: 80,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(100.0)),
            onPressed: () {
              _submitInfo();
            },
          ),
        ],
      )),
    );
  }
}
