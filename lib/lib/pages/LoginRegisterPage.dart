import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_shop/assets/custom_icons.dart';
import 'package:flutter_shop/widget/DialogBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/Authentication.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterPage();
  }
}

enum Gender { MALE, FEMALE }

class _LoginRegisterPage extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();
  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  Gender _gender;
  String gender = "";
  bool _login = true;
  File sampleImage;
  String url;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  void validateAndSubmit() async {
    try {
      if (_login == true) {
        String userId = await widget.auth.SignIn(_email, _password);
        print("login userId = " + userId);
      } else {
        String userId = await widget.auth.SignUp(_email, _password);
        print("login userId = " + userId);
        print("register userId = " + userId);
        final StorageReference profileImageRef =
            FirebaseStorage.instance.ref().child("User Images");

        var timeKey = new DateTime.now();

        final StorageUploadTask uploadTask = profileImageRef
            .child(timeKey.toString() + ".jpg")
            .putFile(sampleImage);

        var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

        url = imageUrl.toString();

        print("Image url = $url");

        saveToDatabase(url, userId);
      }
      widget.onSignedIn();
    } catch (e) {
      dialogBox.information(context, 'ERROR', e.toString());
      print("Error = " + e.toString());
    }
  }

  void saveToDatabase(url, userId) {
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    if (_gender == Gender.MALE) {
      gender = "male";
    } else {
      gender = "female";
    }
    var data = {
      "image": url,
      "firstName": _firstName,
      "lastName": _lastName,
      "gender": gender,
      "uId": userId,
      "bio": " ",
      "address": " ",
      "phone": " ",
    };

    ref.child("Users").child(userId).push().set(data);
  }

  void moveToRegister() {
    setState(() {
      _login = false;
    });
  }

  void moveToLogin() {
    setState(() {
      _login = true;
    });
  }

//Design
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        defaultTextColor: Color(0xFF3E3E3E),
        accentColor: Colors.cyan,
        variantColor: Colors.black38,
        depth: 8,
        intensity: 0.65,
      ),
      themeMode: ThemeMode.light,
      child: Material(
        child: NeumorphicBackground(
          child: authPage(),
        ),
      ),
    );
  }

  Widget authPage() {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                              ),
                              Neumorphic(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(12)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Visibility(
                                      visible: _login,
                                      child: Neumorphic(
                                        padding: EdgeInsets.all(10),
                                        style: NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          depth: NeumorphicTheme.embossDepth(
                                              context),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 80,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_login,
                                      child: InkWell(
                                        onTap: getImage,
                                        child: Neumorphic(
                                          padding: EdgeInsets.all(10),
                                          style: NeumorphicStyle(
                                            boxShape:
                                                NeumorphicBoxShape.circle(),
                                            depth: NeumorphicTheme.embossDepth(
                                                context),
                                          ),
                                          child: sampleImage != null
                                              ? new Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: new FileImage(
                                                              sampleImage))))
                                              : Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Icon(
                                                    Icons.add_a_photo_outlined,
                                                    size: 80,
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_login,
                                      child: Stack(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Center(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: _TextField(
                                                      label: "First name",
                                                      hint: "",
                                                      onChanged: (value) {
                                                        setState(() {
                                                          this._firstName =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: _TextField(
                                                      label: "Last name",
                                                      hint: "",
                                                      onChanged: (value) {
                                                        setState(() {
                                                          this._lastName =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    _TextField(
                                      label: "Email",
                                      hint: "",
                                      onChanged: (value) {
                                        setState(() {
                                          this._email = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    _TextField(
                                      label: "Password",
                                      hint: "",
                                      onChanged: (value) {
                                        setState(() {
                                          this._password = value;
                                        });
                                      },
                                    ),
                                    Visibility(
                                      visible: !_login,
                                      child: Stack(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 8,
                                                      ),
                                                      child: Text(
                                                        "Gender",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        _GenderField(
                                                          gender: _gender,
                                                          onChanged: (gender) {
                                                            setState(() {
                                                              this._gender =
                                                                  gender;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: createButtons(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> createButtons() {
    if (_login == true) {
      return [
        new Column(
          children: <Widget>[
            new NeumorphicButton(
              onPressed: validateAndSubmit,
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.stadium(),
                depth: 12,
              ),
              child: new Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,color: Colors.black54,
                ),
              ),
            ),
            new Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: InkWell(
                  child: Text(
                    "Not have an Account? Create Account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: moveToRegister,
                ),
              ),
            ),
          ],
        ),
      ];
    } else {
      return [
        new Column(
          children: <Widget>[
            new NeumorphicButton(
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.stadium(),
                depth: 12,
              ),
              onPressed: validateAndSubmit,
              child: new Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            new Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: InkWell(
                  child: Text(
                    "Already have an Account? Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: moveToLogin,
                ),
              ),
            ),
          ],
        ),
      ];
    }
  }
}

// ignore: must_be_immutable
class _GenderField extends StatelessWidget {
  Gender gender;
  ValueChanged<Gender> onChanged;

  _GenderField({
    @required this.gender,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.MALE,
              child: Icon(CustomIcons.male, color: Colors.black54),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style:
                  NeumorphicRadioStyle(boxShape: NeumorphicBoxShape.circle()),
              value: Gender.FEMALE,
              child: Icon(CustomIcons.female, color: Colors.black54),
              onChanged: (value) => this.onChanged(value),
            ),
          ],
        ),
      ],
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
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: -10,
            intensity: 1,
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            onChanged: this.widget.onChanged,
            controller: _controller,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration.collapsed(hintText: this.widget.hint),
          ),
        )
      ],
    );
  }
}
