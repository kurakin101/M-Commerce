import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/pages/ProfilePage.dart';
import 'package:like_button/like_button.dart';

import '../auth/Authentication.dart';
import '../model/Products.dart';
import 'DetailsPage.dart';

const double buttonSize = 30.0;

class MyProductsPage extends StatefulWidget {
  MyProductsPage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _MyProductsPageState();
  }
}

class _MyProductsPageState extends State<MyProductsPage> {
  int currentIndex;

  List<Products> productsList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  String buyerId = " ";

  bool isLiked = false;

  final int likeCount = 999;
  final GlobalKey<LikeButtonState> _globalKey = GlobalKey<LikeButtonState>();

  @override
  void initState() {
    super.initState();
    getId(buyerId);

    currentIndex = 0;

  }


  void getId(buyerId) async {
    FirebaseUser user = await auth.currentUser();
    buyerId = user.uid;




    DatabaseReference productRef =
    FirebaseDatabase.instance.reference();
    var query = productRef
        .child('Products')
        .orderByChild('ownerId').equalTo(buyerId);
    query.onChildAdded
        .forEach((event) => {
      print(event.snapshot.value)
    });
    query.once().then((DataSnapshot snap) {

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
    }
    );
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
                              "My Products 📦️",
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
