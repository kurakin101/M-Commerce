import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Auntification.dart';


void main ()
{
  runApp(new App());
}


class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp
      (
      title: "App",

      theme: new ThemeData
        (
        primarySwatch: Colors.green,
      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}