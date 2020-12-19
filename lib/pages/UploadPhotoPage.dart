import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/Manager.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _description;
  String _name;
  String url;
  String _category;
  double _price = 1;
  bool category = true;
  final formKey = new GlobalKey<FormState>();

  setCategory(String string) {
    setState(() {
      _category = string;
    });
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  void initState() {
    super.initState();
    getImage();
  }

  void uploadImage() async {
    final StorageReference productImageRef =
        FirebaseStorage.instance.ref().child("Product Images");

    var timeKey = new DateTime.now();

    final StorageUploadTask uploadTask =
        productImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    url = imageUrl.toString();

    print("Image url = $url");

    saveToDatabase(url);
    goToHomePage();
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');

    String date = formatDate.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _description,
      "date": date,
      "price": _price.toInt().toString(),
      "name": _name,
      "category": _category
    };

    ref.child("Products").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new Manager();
    }));
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
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: NeumorphicBackground(
            child: sampleImage == null ? Container() : formWidget()),
      ),
    );
  }

  Widget formWidget() {
    return Container(
        child: _category == null ? categoryWidget() : uploadWidget());
  }

  Widget uploadWidget() {
    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              padding: EdgeInsets.all(20),
              child: Neumorphic(
                style: NeumorphicStyle(
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                child: Image.file(sampleImage, fit: BoxFit.fill),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextFormField(
                  decoration: new InputDecoration(
                    labelText: 'Product name:',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this._name = value;
                    });
                  }),
            ),
            SizedBox(height: 8.0),
            _TextField(
                label: "Write about your product:",
                hint: "",
                onChanged: (value) {
                  setState(() {
                    this._description = value;
                  });
                }),

            SizedBox(height: 8.0),
            _PriceField(
              price: this._price,
              onChanged: (price) {
                setState(() {
                  this._price = price;
                });
              },
            ),
            SizedBox(height: 16.0),
            NeumorphicButton(
              onPressed: uploadImage,
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.stadium(),
                depth: 12,
              ),
              child: new Text(
                "Add a new product",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 16.0),

          ],
        ),
      ),
    );

  }

  Widget categoryWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Choose your category",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 400,
            width: 400,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                InkWell(
                    onTap: () => setCategory("books"),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: 16,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: -16,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12)),
                            ),
                            child: Icon(Icons.book_outlined, size: 90),
                          ),
                        ),
                      ),
                    )),
                InkWell(
                  onTap: () => setCategory("clothes"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.wallet_travel, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("bike"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.bike_scooter_outlined, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("furniture"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(
                              Icons.airline_seat_individual_suite_outlined,
                              size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("apartment"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.apartment_outlined, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("car"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.airport_shuttle_outlined, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("gadget"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.computer_outlined, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("photography"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.photo_camera_outlined, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setCategory("transport"),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 16,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -16,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                          ),
                          child: Icon(Icons.train_rounded, size: 90),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
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
            height: 80,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
            ),
            child: TextField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
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

class _PriceField extends StatelessWidget {
  final double price;
  final ValueChanged<double> onChanged;

  _PriceField({@required this.price, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            "Price",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NeumorphicSlider(
                  min: 1,
                  max: 100,
                  value: this.price,
                  onChanged: (value) {
                    this.onChanged(value);
                  },
                ),
              ),
            ),
            Text(
              r"$" "${this.price.floor()}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ],
    );
  }
}
