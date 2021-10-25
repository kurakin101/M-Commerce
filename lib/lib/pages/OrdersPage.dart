import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/model/Orders.dart';

import '../auth/Authentication.dart';
import 'DetailsPage.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState extends State<OrdersPage> {
  int currentIndex;

  List<Orders> productsList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  String ownerId = " ";

  void getOrdersData(ownerId) async {
    FirebaseUser user = await auth.currentUser();
    ownerId = user.uid;
    DatabaseReference productRef =
    FirebaseDatabase.instance.reference().child("Orders").child(ownerId);

    productRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      print("! $KEYS");
      print("!! $DATA");
      productsList.clear();

      for (var key in KEYS) {
        print("Key of KEYS!: " + key);
        print("Key of snapshot!: " + snap.key);

        Orders products = new Orders(
            key,
            DATA[key]['ownerId'],
            DATA[key]['buyerId'],
            DATA[key]['firstName'],
            DATA[key]['lastName'],
            DATA[key]['bImage'],
            DATA[key]['image'],
            DATA[key]['description'],
            DATA[key]['date'],
            DATA[key]['price'],
            DATA[key]['name'],
            DATA[key]['category']);

        productsList.add(products);
      }

      setState(() {
        print('Length: $productsList.length');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    getOrdersData(ownerId);
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeumorphicTheme(
        theme: NeumorphicThemeData(
          defaultTextColor: Color(0xFF3E3E3E),
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65,
        ),
        themeMode: ThemeMode.light,
        child: Material(
          child: NeumorphicBackground(
            child: Container(
              child: SafeArea(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        key: Key(productsList[index].image),
                        child: cardUi(
                            productsList[index].id,
                            productsList[index].ownerId,
                            productsList[index].firstName,
                            productsList[index].lastName,
                            productsList[index].bImage,
                            productsList[index].image,
                            productsList[index].description,
                            productsList[index].date,
                            productsList[index].price,
                            productsList[index].name,
                            productsList[index].category));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NeumorphicTheme(
        theme: NeumorphicThemeData(
          defaultTextColor: Color(0xFF3E3E3E),
          accentColor: Colors.grey,
          variantColor: Colors.black38,
        ),
        themeMode: ThemeMode.light,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              topLeft: Radius.circular(100),
            ),
          ),
          width: double.infinity,
          height: 90,
          child: NeumorphicBackground(
            child: NeumorphicBackground(
              child: Container(
                child: Container(
                  child: Container(
                    child: Neumorphic(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            topLeft: Radius.circular(100),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NeumorphicButton(
                                padding: EdgeInsets.all(16),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 12),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            Text(
                              "My Orders 👤️",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                color: Colors.black54,
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
      ),
    );
  }

  Widget cardUi(
      String id,
      String ownerId,
      String firstName,
      String lastName,
      String bImage,
      String image,
      String description,
      String date,
      String price,
      String name,
      String category) {
    return Neumorphic(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 10,
      ),

      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => detailsPage(id, image, description, date,
                  name, price, category, ownerId, context)),
        ),
        child: Container(
          // padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 8,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),

                              // Row(
                              //   children: [
                              //     Text(
                              //       r"$",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.w800,
                              //         fontSize: 24,
                              //         color: Colors.teal,
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 2,
                              //     ),
                              //     Text(
                              //       price,
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.w800,
                              //         fontSize: 24,
                              //         color: Colors.black54,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text("category: $category",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          Text("date: $date",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          Row(
                            children: [
                              Text("Saint-Petersburg, Russia",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Neumorphic(
                        style: NeumorphicStyle(
                          intensity: 0,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(14)),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(image, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.black54,
                    width: 80,
                    height: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        r"$",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
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
                          fontSize: 24,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.black54,
                    width: 80,
                    height: 1,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     // Text(
                    //     //   "Buyer:",
                    //     //   style: TextStyle(
                    //     //     fontWeight: FontWeight.w800,
                    //     //     fontSize: 24,
                    //     //     color: Colors.black54,
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    Row(
                      children: [
                        Neumorphic(
                            padding: EdgeInsets.all(8),
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: NeumorphicTheme.embossDepth(context),
// border: NeumorphicBorder(
//   color: Colors.cyan,
//   width: 2,
// ),
                            ),
                            child: Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(bImage),
                                    )))),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstName,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              lastName,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
