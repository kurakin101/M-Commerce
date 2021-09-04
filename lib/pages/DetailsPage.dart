import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String get date => null;

  String get image => null;

  String get description => null;

  String get id => null;

  String get ownerId => null;

  String get price => null;

  String get name => null;

  String get category => null;

  BuildContext context;

// MapboxMapController controller;

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
// return controller.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(),
      home: detailsPage(
          id, image, description, date, name, price, category, ownerId, context),
    );
  }
}

Widget detailsPage(String id, String image, String description, String date,
    String name, String price, String category, String ownerId, BuildContext context) {
  return NeumorphicTheme(
    theme: NeumorphicThemeData(
      defaultTextColor: Color(0xFF3E3E3E),
      accentColor: Colors.grey,
      variantColor: Colors.black38,
      depth: 8,
      intensity: 0.65,
    ),
    themeMode: ThemeMode.light,
    child: Container(
      width: double.infinity,
      height: double.infinity,
      child: Material(
        child: NeumorphicBackground(
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 350,
                    padding: EdgeInsets.all(20),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Image.network(image, fit: BoxFit.fill),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Rating(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              child: Text(
                                r'$' '$price',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.0),
                        Text("Saint-Petersburg, Russia",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16)),
                        SizedBox(height: 4.0),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 22.0),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        Container(
                          width: double.infinity,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: -15,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12)),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 64),
                              child: Text(
                                description,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
// SizedBox(height: 8.0),

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: <Widget>[
//       Neumorphic(
//           padding: EdgeInsets.all(8),
//           style: NeumorphicStyle(
//             boxShape: NeumorphicBoxShape.circle(),
//             // border: NeumorphicBorder(
//             //   color: Colors.cyan,
//             //   width: 2,
//             // ),
//           ),
//           child: Container(
//             child: Icon(
//               Icons.account_circle_outlined,
//               size: 60,
//               color:
//               Colors.black.withOpacity(0.2),
//             ),
//           ),),
//
//
//     Container(
//       padding: EdgeInsets.only(left: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Vasiliy",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text("Coder"),
//         ],
//       ),
//     ),
//   ],
// ),
                        SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NeumorphicButton(
                                onPressed: () => {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Message",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              NeumorphicButton(
                                onPressed: () => getUiD(id, ownerId, image, description,
                                    date, name, price, category),
                                // Fluttertoast.showToast(
                                // msg: "Product has been added to cart",
                                // toastLength: Toast.LENGTH_SHORT,
                                // gravity: ToastGravity.BOTTOM,
                                // timeInSecForIosWeb: 1,
                                // backgroundColor: Colors.tealAccent,
                                // textColor: Colors.blueGrey,
                                // fontSize: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 180,
// padding: EdgeInsets.all(16),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                              ),
// child: MapboxMap(
//   accessToken: "pk.eyJ1IjoidmFzaWxpeTA4MDgiLCJhIjoiY2tzdXJ1aHZvMDU0ZzMxcHR6NmRjeWJzYiJ9.SHil6Fzm8zi_jHw_-C5Vsg",
//   // onStyleLoadedCallback: _onStyleLoaded,
//   initialCameraPosition: const CameraPosition(
//     target: LatLng(59.941504097511555,30.313607980859363),
//     zoom: 11.0,
//   ),
// ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    ),
  );

// return Scaffold(
//   body: SingleChildScrollView(
//     child: Container(
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: double.infinity,
//             height: 350,
//             padding: EdgeInsets.all(20),
//             child: Neumorphic(
//               style: NeumorphicStyle(
//                 boxShape:
//                 NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//               ),
//               child: Image.network(image, fit: BoxFit.fill),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             child: Text(
//                 name
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//               description
//           ),
//
//           SizedBox(height: 8.0),
//           Text(
//               price
//           ),
//           Rating(),
//           SizedBox(height: 16.0),
//         ],
//       ),
//     ),
//   ),
// );
}

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  var _rating = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStars(),
// _buildLabel(),
      ],
    );
  }

  Row _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) => _buildStar(rating: index + 1)),
    );
  }

  IconButton _buildStar({int rating}) {
    var _isEnable = _rating >= rating;
    return IconButton(
      icon: _isEnable ? Icon(Icons.star) : Icon(Icons.star_border),
      color: _isEnable ? Colors.yellow : Colors.grey,
      iconSize: 22,
      onPressed: () {
        _changeRating(rating);
      },
    );
  }

// Container _buildLabel() {
//   return Container(
//     padding: const EdgeInsets.only(top: 16),
//     child: Text(
//       '$_rating',
//       style: TextStyle(
//         fontSize: 128,
//       ),
//     ),
//   );
// }

  void _changeRating(int newRating) {
    setState(() {
      _rating = newRating;
    });
  }
}

void getUiD(String id, String ownerId, String image, String description, String date,
    String name, String price, String category) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  String buyerId = user.uid;

  saveToDatabase(id, ownerId, image, description, date, name, price, category, buyerId);
}

void saveToDatabase(String id, String ownerId, String image, String description, String date,
    String name, String price, String category, String buyerId) {
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data = {
    "ownerId": ownerId,
    "image": image,
    "description": description,
    "date": date,
    "price": price,
    "name": name,
    "category": category
  };

  ref.child("Cart").child(buyerId).push().set(data);
  ref.child("Orders").child(ownerId).push().set(data);
}
