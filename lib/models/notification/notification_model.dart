import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class NotificationNotice {
  final String no;
  final String uid;
  final String name;
  final String imgUrl;
  final String fid;
  final String farmid;
  final String title;
  final String content;
  final Timestamp postedDate;
  final Timestamp scheduledDate;
  final bool isReadByFM; // farm manager
  final bool isReadByOffice;
  final bool isReadBySFM; // sub field manager or field manager
  final String notid;
  final String type;
  final String department;

  NotificationNotice({
    @required this.no,
    @required this.uid,
    @required this.name,
    @required this.imgUrl,
    @required this.fid,
    @required this.farmid,
    @required this.title,
    @required this.content,
    @required this.postedDate,
    @required this.scheduledDate,
    @required this.isReadByFM,
    @required this.isReadByOffice,
    @required this.isReadBySFM,
    @required this.notid,
    @required this.type,
    @required this.department,
  });

  factory NotificationNotice.fromSnapshot(DocumentSnapshot ds) {
    return NotificationNotice(
      no: ds['no'].toString(),
      uid: ds['uid'].toString(),
      name: ds['name'].toString(),
      imgUrl: ds['imgUrl'].toString(),
      fid: ds['fid'].toString(),
      farmid: ds['farmid'].toString(),
      title: ds['title'].toString(),
      content: ds['content'].toString(),
      postedDate: ds['postedDate'],
      scheduledDate: ds['scheduledDate'],
      isReadByFM: ds['isReadByFM'],
      isReadByOffice: ds['isReadByOffice'],
      isReadBySFM: ds['isReadBySFM'],
      notid: ds['notid'],
      type: ds['type'],
      department: ds['department'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'no': no,
      'uid': uid,
      'name': name,
      'imgUrl': imgUrl,
      'fid': fid,
      'farmid': farmid,
      'title': title,
      'content': content,
      'postedDate': postedDate,
      'scheduledDate': scheduledDate,
      'isReadByFM': isReadByFM,
      'isReadByOffice': isReadByOffice,
      'isReadBySFM': isReadBySFM,
      'notid': notid,
      'type': type,
      'department': department,
    };
  }
}

class NotificationTrigger {
  final String docID;
  final String state;

  NotificationTrigger({
    @required this.docID,
    @required this.state,
  });

  factory NotificationTrigger.fromSnapshot(DocumentSnapshot ds) {
    return NotificationTrigger(
      docID: ds['docID'].toString(),
      state: ds['state'].toString(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'docID': docID,
      'state': state,
    };
  }
}
