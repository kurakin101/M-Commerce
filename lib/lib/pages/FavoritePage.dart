import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/model/Favorite.dart';
import 'package:flutter_shop/pages/ProfilePage.dart';
import 'package:flutter_shop/utils/Manager.dart';

import '../auth/Authentication.dart';
import 'DetailsPage.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {
  int currentIndex;

  List<Favorite> productsList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  String buyerId = " ";

  void getCartData(buyerId) async {
    FirebaseUser user = await auth.currentUser();
    buyerId = user.uid;
    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child("Favorite").child(buyerId);

    productRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      print("! $KEYS");
      print("!! $DATA");
      productsList.clear();

      for (var key in KEYS) {
        print("Key of KEYS!: " + key);
        print("Key of snapshot!: " + snap.key);

        Favorite products = new Favorite(
            key,
            DATA[key]['uId'],
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
    getCartData(buyerId);
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
                    crossAxisCount: 2,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        key: Key(productsList[index].image),
                        child: cardUi(
                            productsList[index].id,
                            productsList[index].ownerId,
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
                        child:

                            Row(
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
                                  "Favorite ❤️",
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

  Widget cardUi(String id, String ownerId, String image, String description,
      String date, String price, String name, String category) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      // style: NeumorphicStyle(
      //   boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
      //   depth: 10,
      // ),

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
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 8,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    intensity: 0,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        child: Image.network(image, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              r"$",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
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
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text("Saint-Petersburg,",
                            maxLines: 2,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Russia",
                            maxLines: 2,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
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
