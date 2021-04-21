import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class User {
  final String uid;
  final String fcmToken;
  final String email;
  final String name;
  final int position;
  final String psw;
  final String id;
  final String imgUrl;
  final String phone;

  User({
    @required this.email,
    @required this.fcmToken,
    @required this.name,
    @required this.position,
    @required this.uid,
    @required this.psw,
    @required this.id,
    @required this.imgUrl,
    @required this.phone,
  });

  factory User.fromSnapshot(DocumentSnapshot ds) {
    return User(
      email: ds['email'].toString(),
      fcmToken: ds['fcmToken'].toString(),
      name: ds['name'].toString(),
      position: ds['position'],
      uid: ds['uid'].toString(),
      psw: ds['psw'].toString(),
      id: ds['id'].toString(),
      imgUrl: ds['imgUrl'].toString(),
      phone: ds['phone'].toString(),
    );
  }

  factory User.fromMap(Map<String, dynamic> user) {
    return User(
      email: user['email'].toString(),
      fcmToken: user['fcmToken'].toString(),
      name: user['name'].toString(),
      position: user['position'],
      uid: user['uid'].toString(),
      psw: user['psw'].toString(),
      id: user['id'].toString(),
      imgUrl: user['imgUrl'].toString(),
      phone: user['phone'].toString(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'email': email,
      'fcmToken': fcmToken,
      'name': name,
      'position': position,
      'uid': uid,
      'psw': psw,
      'id': id,
      'imgUrl': imgUrl,
      'phone': phone,
    };
  }
}
