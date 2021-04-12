import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class Contact {
  final Timestamp date;

  Contact({
    @required this.date,
  });

  factory Contact.fromSnapshot(DocumentSnapshot ds) {
    return Contact(
      date: ds['date'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'date': date,
    };
  }
}

class FMContact {
  String uid;
  String name;
  String position;
  String phoneNum;
  String imgUrl;

  FMContact({
    @required this.uid,
    @required this.name,
    @required this.position,
    @required this.phoneNum,
    @required this.imgUrl,
  });
}