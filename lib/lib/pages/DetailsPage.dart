import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/model/Users.dart';
import 'package:latlong/latlong.dart';
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

  List<Users> usersList = [];

  // MapboxMapController controller;

//   /// Adds a network image to the currently displayed style
//   Future<void> addImageFromUrl(String name, String url) async {
//     var response = await get(url);
// // return controller.addImage(name, response.bodyBytes);
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(),
      home: detailsPage(id, image, description, date, name, price, category,
          ownerId, context),
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
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape:
                            NeumorphicBoxShape.roundRect(BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                      ),
                      child: Image.network(image, fit: BoxFit.cover),
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
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    r"$",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    price,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.0),
                        Text("Saint-Petersburg, Russia",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: Colors.black45)),
                        SizedBox(height: 4.0),
                        Text(
                          "Category: $category",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 22.0),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45,
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // NeumorphicButton(
                              //   onPressed: () => {},
                              //   // getUiDd(ownerId),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceAround,
                              //     children: [
                              //       // Text("Message",
                              //       //     style: TextStyle(
                              //       //       fontWeight: FontWeight.w500,
                              //       //       color: Colors.black54,
                              //       //     )),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              NeumorphicButton(
                                onPressed: () => getUiDc(id, ownerId, image,
                                    description, date, name, price, category),
                                // Fluttertoast.showToast(
                                // msg: "Product has been added to cart",
                                // toastLength: Toast.LENGTH_SHORT,
                                // gravity: ToastGravity.BOTTOM,
                                // timeInSecForIosWeb: 1,
                                // backgroundColor: Colors.tealAccent,
                                // textColor: Colors.blueGrey,
                                // fontSize: 16.0),
                                child:
                                    Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
//                         SizedBox(height: 16.0),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             width: double.infinity,
//                             height: 180,
// // padding: EdgeInsets.all(16),
//                             child: Neumorphic(
//                               style: NeumorphicStyle(
//                                 boxShape: NeumorphicBoxShape.roundRect(
//                                     BorderRadius.circular(12)),
//                               ),
//                               child: FlutterMap(
//                                 options: MapOptions(
//                                   center: LatLng(51.5074, 0.1278), // London
//                                   zoom: 16.0,
//                                   minZoom: 10,
//                                 ),
//                                 layers: [
//                                   new TileLayerOptions(
//                                     urlTemplate:
//                                         'https://api.mapbox.com/styles/v1/vasiliy0808/cktanwj9z138z18p42rkiud55/wmts?access_token=pk.eyJ1IjoidmFzaWxpeTA4MDgiLCJhIjoiY2t0YW43a2NvMGRnczJwazR1OTZiYjFwYSJ9.-mNXOMtnz6Q98EpxU_zekg',
//                                     additionalOptions: {
//                                       'accessToken':
//                                           'pk.eyJ1IjoidmFzaWxpeTA4MDgiLCJhIjoiY2t0YW43a2NvMGRnczJwazR1OTZiYjFwYSJ9.-mNXOMtnz6Q98EpxU_zekg',
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               // MapboxMap(
//                               //   accessToken: "pk.eyJ1IjoidmFzaWxpeTA4MDgiLCJhIjoiY2tpdXJnNmNjMGQ4MTJ4bXd6b25ycWpjZSJ9.XlXd7GMklxGHE_XZLSv-8Q",
//                               //   styleString: "url-to-style",
//                               //   initialCameraPosition: CameraPosition(
//                               //     zoom: 15.0,
//                               //     target: LatLng(14.508, 46.048),
//                               //   ),
//                               // ),
// // child: MapboxMap(
// //   accessToken: "pk.eyJ1IjoidmFzaWxpeTA4MDgiLCJhIjoiY2t0YW43a2NvMGRnczJwazR1OTZiYjFwYSJ9.-mNXOMtnz6Q98EpxU_zekg",
// //   // onStyleLoadedCallback: _onStyleLoaded,
// //   initialCameraPosition: const CameraPosition(
// //     target: LatLng(59.941504097511555,30.313607980859363),
// //     zoom: 11.0,
// //   ),
// // ),
//                             ),
//                           ),
//                         ),
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

void getUiDd(String ownerId) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  String buyerId = user.uid;

  saveToDialogDatabase(ownerId, buyerId);
}

void saveToDialogDatabase(String ownerId, String buyerId) {
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data = {
    "ownerId": ownerId,
  };

  ref.child("Dialogs").child(buyerId).push().set(data);
}

void getUiDc(String id, String ownerId, String image, String description,
    String date, String name, String price, String category) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  String buyerId = user.uid;

  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child("Users").child(buyerId);

  userRef.once().then((DataSnapshot snap) {
    var KEYS = snap.value.keys;
    var DATA = snap.value;

    for (var key in KEYS) {
      print("Key of KEYS: " + key);
      print("Key of snapshot: " + snap.key);

      Users users = new Users(key, DATA[key]['firstName'], DATA[key]['gender'],
          DATA[key]['image'], DATA[key]['lastName'], DATA[key]['uId'], DATA[key]['bio'], DATA[key]['address'], DATA[key]['phone']);

      String firstName = users.firstName;
      String lastName = users.lastName;
      String bImage = users.image;

      saveToCartDatabase(id, ownerId, image, description, date, name, price,
          category, buyerId, firstName, lastName, bImage);
    }
  });


}

// void getBuyerData() async {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final FirebaseUser user = await auth.currentUser();
//   final userId = user.uid;
//
// // here you write the codes to input the data into firebase real-time database
//   DatabaseReference userRef =
//       FirebaseDatabase.instance.reference().child("Users").child(userId);
//
//   userRef.once().then((DataSnapshot snap) {
//     var KEYS = snap.value.keys;
//     var DATA = snap.value;
//
//     for (var key in KEYS) {
//       print("Key of KEYS: " + key);
//       print("Key of snapshot: " + snap.key);
//
//       Users users = new Users(key, DATA[key]['firstName'], DATA[key]['gender'],
//           DATA[key]['image'], DATA[key]['lastName'], DATA[key]['uId']);
//
//       String firstName = users.firstName;
//       String lastName = users.lastName;
//       String image = users.image;
//     }
//   });
// }

void saveToCartDatabase(
  String id,
  String ownerId,
  String image,
  String description,
  String date,
  String name,
  String price,
  String category,
  String buyerId,
  String firstName,
  String lastName,
  String bImage,
) {
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var ordersData = {
    "ownerId": ownerId,
    "buyerId": buyerId,
    "firstName": firstName,
    "lastName": lastName,
    "bImage": bImage,
    "image": image,
    "description": description,
    "date": date,
    "price": price,
    "name": name,
    "category": category
  };

  var cartData = {
    "ownerId": ownerId,
    "image": image,
    "description": description,
    "date": date,
    "price": price,
    "name": name,
    "category": category
  };
  ref.child("Orders").child(ownerId).push().set(ordersData);
  ref.child("Cart").child(buyerId).push().set(cartData);
}
