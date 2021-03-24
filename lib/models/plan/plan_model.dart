import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FMPlan {
  final String planID;
  final String uid;
  final String name;
  final String imgUrl;
  final Timestamp startDate;
  final Timestamp endDate;
  final String title;
  final String content;
  final bool isReadByFM; // farm manager
  final bool isReadByOffice;
  final bool isReadBySFM; // sub field manager or field manager
  final int from; // 1 : office , 2 : FM
  final String fid;
  final String farmID;

  FMPlan({
    @required this.planID,
    @required this.uid,
    @required this.name,
    @required this.imgUrl,
    @required this.startDate,
    @required this.endDate,
    @required this.title,
    @required this.content,
    @required this.isReadByFM,
    @required this.isReadByOffice,
    @required this.isReadBySFM,
    @required this.from,
    @required this.fid,
    @required this.farmID,
  });

  factory FMPlan.fromSnapshot(DocumentSnapshot ds) {
    return FMPlan(
      planID: ds['planID'].toString(),
      uid: ds['uid'].toString(),
      name: ds['name'].toString(),
      imgUrl: ds['imgUrl'].toString(),
      startDate: ds['startDate'],
      endDate: ds['endDate'],
      title: ds['title'].toString(),
      content: ds['content'].toString(),
      isReadByFM: ds['isReadByFM'],
      isReadByOffice: ds['isReadByOffice'],
      isReadBySFM: ds['isReadBySFM'],
      from: ds['from'],
      fid: ds['fid'].toString(),
      farmID: ds['farmID'].toString(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'planID': planID,
      'uid': uid,
      'name': name,
      'imgUrl': imgUrl,
      'startDate': startDate,
      'endDate': endDate,
      'title': title,
      'content': content,
      'isReadByFM': isReadByFM,
      'isReadByOffice': isReadByOffice,
      'isReadBySFM': isReadBySFM,
      'from': from,
      'fid': fid,
      'farmID': farmID,
    };
  }
}
