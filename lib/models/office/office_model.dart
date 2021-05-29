import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Office {
  final String docID;
  final String managerID;
  final int officeNum;
  final String name;

  Office({
    @required this.docID,
    @required this.managerID,
    @required this.officeNum,
    @required this.name,
  });

  factory Office.fromSnapshot(DocumentSnapshot ds) {
    return Office(
      docID: ds['docID'].toString(),
      managerID: ds['managerID'].toString(),
      officeNum: ds['officeNum'],
      name: ds['name'].toString(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'docID': docID,
      'managerID': managerID,
      'officeNum': officeNum,
      'name': name,
    };
  }
}
