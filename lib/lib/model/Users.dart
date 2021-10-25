import 'package:firebase_database/firebase_database.dart';

class Users {
  String _id;
  String _firstName;
  String _gender;
  String _image;
  String _lastName;
  String _uId;
  String _bio;
  String _address;
  String _phone;

  Users(this._id, this._firstName, this._gender, this._image, this._lastName,
      this._uId, this._bio, this._address, this._phone);

  String get id => _id;

  String get firstName => _firstName;

  String get gender => _gender;

  String get image => _image;

  String get lastName => _lastName;

  String get uId => _uId;

  String get bio => _bio;

  String get address => _address;

  String get phone => _phone;

  Users.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _firstName = snapshot.value['firstName'];
    _gender = snapshot.value['gender'];
    _image = snapshot.value['image'];
    _lastName = snapshot.value['lastName'];
    _uId = snapshot.value['uId'];
    _bio = snapshot.value['bio'];
    _address = snapshot.value['address'];
    _phone = snapshot.value['phone'];
  }
}
