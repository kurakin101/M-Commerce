import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/pages/HomePage.dart';
import 'package:flutter_shop/pages/UploadPhotoPage.dart';

import '../pages/ProfilePage.dart';

class Manager extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;


  final _pageOptions = [
    HomePage(),
    UploadPhotoPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_page],
      bottomNavigationBar: NeumorphicTheme(
        theme: NeumorphicThemeData(
          defaultTextColor: Color(0xFF3E3E3E),
          accentColor: Colors.grey,
          variantColor: Colors.black38,
        ),
        themeMode: ThemeMode.light,
        child: Container(
          width: double.infinity,
          height: 90,
          child: NeumorphicBackground(
            child: NeumorphicBackground(
              child: Container(
                child: Container(
                  child: Container(
                    child: Neumorphic(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: NeumorphicButton(
                                padding: EdgeInsets.all(16),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 12),
                                child: Icon (Icons.home_outlined),
                                onPressed: () {setState(() {
                                  _page = 0;
                                });}
                            ),
                          ),
                          Expanded(
                            child: NeumorphicButton(
                                padding: EdgeInsets.all(16),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 12),
                                child: Icon (Icons.add_circle_outline),
                                onPressed: () {setState(() {
                                  _page = 1;
                                });}
                            ),
                          ),
                          Expanded(
                            child: NeumorphicButton(
                                padding: EdgeInsets.all(16),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 12),
                                child: Icon (Icons.person_outline_rounded),
                                onPressed: () {setState(() {
                                  _page = 2;
                                });}
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}






