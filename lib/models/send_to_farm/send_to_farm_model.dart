
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendToFarm {
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

  SendToFarm({
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
  });

  factory SendToFarm.fromSnapshot(DocumentSnapshot ds) {
    return SendToFarm(
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
    };
  }
}