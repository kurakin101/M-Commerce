import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:like_button/like_button.dart';

import '../auth/Authentication.dart';
import '../model/Products.dart';
import 'DetailsPage.dart';

const double buttonSize = 30.0;

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentIndex;

  List<Products> productsList = [];

  bool isLiked = false;

  final int likeCount = 999;
  final GlobalKey<LikeButtonState> _globalKey = GlobalKey<LikeButtonState>();

  @override
  void initState() {
    super.initState();
    currentIndex = 0;

    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child("Products");

    productRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      productsList.clear();

      for (var key in KEYS) {
        print("Key of KEYS: " + key);
        print("Key of snapshot: " + snap.key);

        Products products = new Products(
            key,
            DATA[key]['ownerId'],
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
    return NeumorphicTheme(
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
            // padding: EdgeInsets.symmetric(horizontal: 8),
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
    );
  }

  Widget cardUi(String id, String ownerId, String image, String description, String date,
      String price, String name, String category) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        height: 250,
                        width: double.infinity,
                        child: Image.network(image, fit: BoxFit.cover),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                            ),
                            color: Colors.white54,
                          ),
                          child: InkWell(
                            onTap: () => getBuyerId(isLiked, image, description, date,
                                name, price, category, ownerId),
                            child: Icon(
                              isLiked ? Icons.star : Icons.star_border_outlined,
                                color: isLiked
                                        ? Colors.amber
                                        : Colors.amber[200],
                                    size: buttonSize,
                            ),
                            // LikeButton(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   size: buttonSize,
                            //   // circleColor:
                            //   // CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                            //   // bubblesColor: BubblesColor(
                            //   //   dotPrimaryColor: Color(0xff33b5e5),
                            //   //   dotSecondaryColor: Color(0xff0099cc),
                            //   // ),
                            //   likeBuilder: (isLiked) {
                            //     return Icon(
                            //       isLiked
                            //           ? Icons.star
                            //           : Icons.star_border_outlined,
                            //       color: isLiked
                            //           ? Colors.amber
                            //           : Colors.amber[200],
                            //       size: buttonSize,
                            //     );
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2,
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
                            fontSize: 24,
                            color: Colors.black54,
                          ),
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
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future getBuyerId(bool isLiked, String image, String description, String date,
    String name, String price, String category, String ownerId) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseUser user = await auth.currentUser();
  final buyerId = user.uid;
  if(isLiked == false) {
    saveToFavoriteDatabase( image, buyerId, description, date, name,
        price, category, ownerId);
  }

}

saveToFavoriteDatabase(
    String image,
    String buyerId,
    String description,
    String date,
    String name,
    String price,
    String category,
    String ownerId) {
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
  ref.child("Favorite").child(buyerId).push().set(data);
}
