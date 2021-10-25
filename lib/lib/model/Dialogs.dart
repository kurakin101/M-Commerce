// import 'package:firebase_database/firebase_database.dart';
//
// class Dialogs {
//   String _id;
//   String _firstName;
//   String _gender;
//   String _image;
//   String _lastName;
//   String _ownerId;
//
//   Dialogs(this._id, this._firstName, this._gender, this._image, this._lastName,
//       this._ownerId);
//
//   String get id => _id;
//
//   String get firstName => _firstName;
//
//   String get gender => _gender;
//
//   String get image => _image;
//
//   String get lastName => _lastName;
//
//   String get ownerId => _ownerId;
//
//   Dialogs.fromSnapshot(DataSnapshot snapshot) {
//     _id = snapshot.key;
//     _firstName = snapshot.value['firstName'];
//     _gender = snapshot.value['gender'];
//     _image = snapshot.value['image'];
//     _lastName = snapshot.value['lastName'];
//     _ownerId = snapshot.value['ownerId'];
//   }
// }
