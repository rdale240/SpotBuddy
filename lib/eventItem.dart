import 'package:flutter/material.dart';

class EventData {
  final double lat;
  final double long;
  final String title;
  final String uid;
  final String description;

  EventData({Key key, this.title, this.uid, this.description,this.lat,this.long});}