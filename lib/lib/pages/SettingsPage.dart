import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/assets/custom_icons.dart';
import 'package:flutter_shop/pages/LoginRegisterPage.dart';

import '../auth/Authentication.dart';
import '../model/Users.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  List<Users> usersList = [];

  String userId = " ";
  String _bio = " ";
  String _address = " ";
  String _phone = " ";

  @override
  void initState() {
    super.initState();

    inputData(userId);
  }

  void _logoutUser() async {
    await widget.auth.signOut();
    widget.onSignedOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginRegisterPage()));
    // try {
    //   await widget.auth.signOut();
    //   widget.onSignedOut();
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => LoginRegisterPage()));
    // } catch (e) {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => LoginRegisterPage()));
    //   print(e.toString());
    // }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

//Undescribed function of saving / updating profile. Perhaps in the future it will be added

//Недописаная функция сохранения/обновления профиля. Возможно в будущем будет дописана

// void saveToDatabase(_description) {
//
//   DatabaseReference ref = FirebaseDatabase.instance.reference();
//
//
//   var data = {
//     "description" : _description,
//
//   };
//
//   ref.child("Users").child(userId).push().set(data);
// }

  void inputData(userId) async {
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
// here you write the codes to input the data into firebase real-time database
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child("Users").child(userId);

    userRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      usersList.clear();

      for (var key in KEYS) {
        print("Key of KEYS: " + key);
        print("Key of snapshot: " + snap.key);

        Users users = new Users(
          key,
          DATA[key]['firstName'],
          DATA[key]['gender'],
          DATA[key]['image'],
          DATA[key]['lastName'],
          DATA[key]['uId'],
          DATA[key]['bio'],
          DATA[key]['address'],
          DATA[key]['phone'],

        );

        if(users.bio != " "){
          _bio = users.bio;
        }
        if(users.address != " "){
          _address = users.address;
        }
        if(users.phone != " "){
          _phone = users.phone;
        }

        usersList.add(users);
      }
      setState(() {
        print('Length: $usersList.length');
      });
    });
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
              child: ListView.builder(
// physics: NeverScrollableScrollPhysics(),
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  return Container(
                      key: Key(usersList[index].image),
                      child: cardUi(
                        usersList[index].id,
                        usersList[index].firstName,
                        usersList[index].gender,
                        usersList[index].image,
                        usersList[index].lastName,
                        usersList[index].uId,
                        usersList[index].bio,
                        usersList[index].address,
                        usersList[index].phone,
                      ));
                },
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
                              "Settings ⚙️",
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

  Widget cardUi(String id, String firstName, String gender, String image,
      String lastName, String uId, String bio, String address, String phone) {
    return SafeArea(
      child: Container(
// height: double.infinity,
// width:double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,

          children: <Widget>[
            Column(
              children: [
// Container(
//   margin: EdgeInsets.only(left: 12, right: 12, top: 10),
// ),
                Neumorphic(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Neumorphic(
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
                                width: 120.0,
                                height: 120.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(image),
                                    )))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Text(lastName,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),),
                            Row(
                              children: [
                                Text(
                                  "Gender - ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                  ),
                                ),
                                gender == ("male")
                                    ? Icon(
                                        CustomIcons.male,
                                        color: Colors.black54,
                                      )
                                    : Icon(
                                        CustomIcons.female,
                                        color: Colors.black54,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            _TextField(
                label: "Bio:",
                hint: bio,
                onChanged: (value) {
                  setState(() {
                    this._bio = value;
                  });
                }),
            _TextField(
                label: "Address:",
                hint: address,
                onChanged: (value) {
                  setState(() {
                    this._address = value;
                  });
                }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                  decoration: new InputDecoration(
                    labelText: 'Phone:',
                    hintText: phone,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this._phone = value;
                    });
                  }),
            ),
            // SizedBox(
            //   height: 32,
            // ),
            // NeumorphicButton(
            //   onPressed: () => {
            //     Navigator.pop(context),
            //   },
            //   child: Text(
            //     "Save",
            //     style: TextStyle(
            //       color: Colors.black45,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
            NeumorphicButton(
              onPressed: () => saveData(uId, _bio, _address, _phone, id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Save", textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.black54,fontWeight: FontWeight.w600, fontSize: 20,
                  ),),
                ],
              ),
            ),
            // NeumorphicButton(
            //   onPressed: saveData(uId, _bio, _address, _phone, id),
            //   style: NeumorphicStyle(
            //     shape: NeumorphicShape.convex,
            //     boxShape: NeumorphicBoxShape.stadium(),
            //     depth: 12,
            //   ),
            //   child: new Text(
            //     "Save",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontWeight: FontWeight.w800,
            //       fontSize: 20,
            //     ),
            //   ),
            // ),

//             _TextField(
//                 label: "Write about you:",
//                 hint: "",
//                 onChanged: (value) {
//                   setState(() {
//                     this._description = value;
//                   });
//                 }),
//             SizedBox(
//               height: 12,
//             ),
//             MaterialButton(
//               child: Text(
//                 "Save",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                 ),
//               ),
//               onPressed: () => {},
// // onPressed: () => saveToDatabase(_description),
//             ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  final String label;
  final String hint;

  final ValueChanged<String> onChanged;

  _TextField({@required this.label, @required this.hint, this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            this.widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 18, right: 18, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            intensity: 0.80,
          ),
// padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: Container(
            height: 70,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
            ),
            child: TextField(
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
              onChanged: this.widget.onChanged,
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: this.widget.hint),
            ),
          ),
        )
      ],
    );
  }
}

saveData(String uId, String _bio, String _address, String _phone, String id) {

  // final FirebaseUser user = await auth.currentUser();
  // final userId = user.uid;
// here you write the codes to input the data into firebase real-time database
  DatabaseReference userRef =
  FirebaseDatabase.instance.reference().child("Users").child(uId);

  userRef.once().then((DataSnapshot snap) {
    var KEYS = snap.value.keys;
    var DATA = snap.value;

    for (var key in KEYS) {
      print("Key of KEYS: " + key);
      print("Key of snapshot: " + snap.key);

      userRef.child(key).update({
        "bio": _bio,
        "address": _address,
        "phone": _phone,
      });

    }
  });

  // DatabaseReference ref = FirebaseDatabase.instance.reference();
  // var data = {
  //   "bio": _bio,
  //   "address": _address,
  //   "phone": _phone,
  // };
  //
  // ref.child("Users").child(uId).push().set(data);
}
