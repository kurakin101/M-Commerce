import 'package:firebase_database/firebase_database.dart';

class Products {
  String _id;
  String _ownerId;
  String _image;
  String _description;
  String _date;
  String _price;
  String _name;
  String _category;

  Products(this._id, this._ownerId, this._image, this._description, this._date, this._price, this._name, this._category);

  String get id => _id;

  String get ownerId => _ownerId;

  String get image => _image;

  String get description => _description;

  String get date => _date;

  String get price => _price;

  String get name => _name;

  String get category => _category;

  Products.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _ownerId = snapshot.value['ownerId'];
    _image = snapshot.value['image'];
    _description = snapshot.value['description'];
    _date = snapshot.value['date'];
    _price = snapshot.value['price'];
    _name = snapshot.value['name'];
    _category = snapshot.value['category'];
  }
}
