import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/model/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/Authentication.dart';
import '../model/Products.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DetailsPage.dart';

class CartPage extends StatefulWidget {
  CartPage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  int currentIndex;

  List<Cart> productsList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  String buyerId = " ";

  void getCartData(buyerId) async {
    FirebaseUser user = await auth.currentUser();
    buyerId = user.uid;
    DatabaseReference productRef =
    FirebaseDatabase.instance.reference().child("Cart").child(buyerId);

    productRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      print("! $KEYS");
      print("!! $DATA");
      productsList.clear();

      for (var key in KEYS) {
        print("Key of KEYS!: " + key);
        print("Key of snapshot!: " + snap.key);

        Cart products = new Cart(
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
            padding: EdgeInsets.symmetric(horizontal: 8),
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
    );
  }

  Widget cardUi(String id, String ownerId, String image, String description, String date,
      String price, String name, String category) {
    return Neumorphic(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 10,
      ),

      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => detailsPage(
                  id, image, description, date, name, price, category, ownerId, context)),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 32,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      intensity: 0,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                    ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.network(image, fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
              Container(
                // padding: EdgeInsets.symmetric(
                //   horizontal: 16,
                // ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          r"$" '$price',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
