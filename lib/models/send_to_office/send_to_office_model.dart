import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendToOffice {
  final String docID;
  final String uid;
  final String name;
  final String officeID;
  final String title;
  final String content;
  final Timestamp postedDate;
  final String fcmToken;

  SendToOffice({
    @required this.docID,
    @required this.uid,
    @required this.name,
    @required this.officeID,
    @required this.title,
    @required this.content,
    @required this.postedDate,
    @required this.fcmToken,
  });

  factory SendToOffice.fromSnapshot(DocumentSnapshot ds) {
    return SendToOffice(
      docID: ds['docID'].toString(),
      uid: ds['uid'].toString(),
      name: ds['name'].toString(),
      officeID: ds['officeID'].toString(),
      title: ds['title'].toString(),
      content: ds['content'].toString(),
      postedDate: ds['postedDate'],
      fcmToken: ds['fcmToken'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'docID': docID,
      'uid': uid,
      'name': name,
      'officeID': officeID,
      'title': title,
      'content': content,
      'postedDate': postedDate,
      'fcmToken': fcmToken,
    };
  }
}
