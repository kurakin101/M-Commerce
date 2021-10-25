import 'package:firebase_database/firebase_database.dart';

class Orders {
  String _id;
  String _ownerId;
  String _buyerId;
  String _firstName;
  String _lastName;
  String _bImage;
  String _image;
  String _description;
  String _date;
  String _price;
  String _name;
  String _category;

  Orders(this._id, this._ownerId, this._buyerId, this._firstName, this._lastName, this._bImage, this._image, this._description, this._date, this._price, this._name, this._category);

  String get id => _id;

  String get ownerId => _ownerId;

  String get buyerId => _buyerId;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get bImage => _bImage;

  String get image => _image;

  String get description => _description;

  String get date => _date;

  String get price => _price;

  String get name => _name;

  String get category => _category;

  Orders.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _ownerId = snapshot.value['ownerId'];
    _buyerId = snapshot.value['buyerId'];
    _firstName = snapshot.value['firstName'];
    _lastName = snapshot.value['lastName'];
    _bImage = snapshot.value['bImage'];
    _image = snapshot.value['image'];
    _description = snapshot.value['description'];
    _date = snapshot.value['date'];
    _price = snapshot.value['price'];
    _name = snapshot.value['name'];
    _category = snapshot.value['category'];
  }
}
