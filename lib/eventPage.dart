import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import './eventItem.dart';
import 'package:random_string/random_string.dart' as random;

class EventPage extends StatefulWidget {
  final String eventID;
  final EventData eventData;

  EventPage({Key key, this.eventID, this.eventData}) : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  double _userRating;
  @override
  Widget build(BuildContext context) {
    _userRating = 4.5;
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
              )
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
                        widget.eventData.title,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Padding(
                      child: Column(children: <Widget>[
                        Text("Hosted By",
                            style: Theme.of(context).textTheme.body1),
                        Container(
                            width: MediaQuery.of(context).size.width * .2,
                            height: MediaQuery.of(context).size.width * .2,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage: AssetImage('./assets/user.png'),
                              radius: MediaQuery.of(context).size.width * .1,
                            )),
                        Text("Host Name",
                            style: Theme.of(context).textTheme.body1),
                        Text("Host Location",
                            style: Theme.of(context).textTheme.body1),
                        SmoothStarRating(
                          allowHalfRating: false,
                          // onRatingChanged: (v) {
                          //   _userRating = v;
                          //   setState(() {});
                          // },
                          starCount: 5,
                          rating: _userRating,
                          size: 20.0,
                          color: Colors.yellow,
                          borderColor: Colors.green,
                        )
                      ]),
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Time: 10:00 PM - 12:00 PM"),
                    SizedBox(
                      height: 24,
                    ),
                    Text("Location: McDonalds Coral Gables"),
                    SizedBox(
                      height: 24,
                    ),
                    Text(widget.eventData.description),
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
              onPressed: () {},
            ),
          ],
        ));
  }
}
