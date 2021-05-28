import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendToOffice {
  final String docID;
  final String uid;
  final String name;
  final String farmid;
  final String title;
  final String content;
  final Timestamp postedDate;
  final String jid;
  final String issid;
  final String cmtid;
  final String scmtid;
  final String fcmToken;

  SendToOffice({
    @required this.docID,
    @required this.uid,
    @required this.name,
    @required this.farmid,
    @required this.title,
    @required this.content,
    @required this.postedDate,
    @required this.jid,
    @required this.issid,
    @required this.cmtid,
    @required this.scmtid,
    @required this.fcmToken,
  });

  factory SendToOffice.fromSnapshot(DocumentSnapshot ds) {
    return SendToOffice(
      docID: ds['docID'].toString(),
      uid: ds['uid'].toString(),
      name: ds['name'].toString(),
      farmid: ds['farmid'].toString(),
      title: ds['title'].toString(),
      content: ds['content'].toString(),
      postedDate: ds['postedDate'],
      jid: ds['jid'],
      issid: ds['issid'],
      cmtid: ds['cmtid'],
      scmtid: ds['scmtid'],
      fcmToken: ds['fcmToken'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'docID': docID,
      'uid': uid,
      'name': name,
      'farmid': farmid,
      'title': title,
      'content': content,
      'postedDate': postedDate,
      'jid': jid,
      'issid': issid,
      'cmtid': cmtid,
      'scmtid': scmtid,
      'fcmToken': fcmToken,
    };
  }
}
