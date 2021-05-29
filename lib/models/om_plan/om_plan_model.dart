import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class OMPlan {
  final String planID;
  final String uid;
  final Timestamp startDate;
  final Timestamp endDate;
  final Timestamp postedDate;
  final String title;
  final String content;
  final bool isReadByFM; // farm manager
  final bool isReadByOffice;
  final bool isReadBySFM; // sub field manager or field manager
  final int from; // 1 : office , 2 : FM
  final String farmID;
  final int officeNum;
  final bool isUpdated;

  OMPlan({
    @required this.planID,
    @required this.uid,
    @required this.startDate,
    @required this.endDate,
    @required this.postedDate,
    @required this.title,
    @required this.content,
    @required this.isReadByFM,
    @required this.isReadByOffice,
    @required this.isReadBySFM,
    @required this.from,
    @required this.farmID,
    @required this.officeNum,
    @required this.isUpdated,
  });

  factory OMPlan.fromSnapshot(DocumentSnapshot ds) {
    return OMPlan(
      planID: ds['planID'].toString(),
      uid: ds['uid'].toString(),
      startDate: ds['startDate'],
      endDate: ds['endDate'],
      postedDate: ds['postedDate'],
      title: ds['title'].toString(),
      content: ds['content'].toString(),
      isReadByFM: ds['isReadByFM'],
      isReadByOffice: ds['isReadByOffice'],
      isReadBySFM: ds['isReadBySFM'],
      from: ds['from'],
      farmID: ds['farmID'].toString(),
      officeNum: ds['officeNum'],
      isUpdated: ds['isUpdated'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'planID': planID,
      'uid': uid,
      'startDate': startDate,
      'endDate': endDate,
      'postedDate': postedDate,
      'title': title,
      'content': content,
      'isReadByFM': isReadByFM,
      'isReadByOffice': isReadByOffice,
      'isReadBySFM': isReadBySFM,
      'from': from,
      'farmID': farmID,
      'officeNum': officeNum,
      'isUpdated': isUpdated,
    };
  }
}

class OMWaitingConfirmation {
  DateTime startDate;
  DateTime endDate;
  String title;
  String content;
  int selectedFarmIndex;
  bool isUpdated;

  OMWaitingConfirmation({
    @required this.startDate,
    @required this.endDate,
    @required this.title,
    @required this.content,
    @required this.selectedFarmIndex,
    @required this.isUpdated,
  });
}

class OMCalendarPlan {
  DateTime date;
  String title;
  String content;
  String farmID;
  String planID;
  bool isUpdated;

  OMCalendarPlan({
    this.date,
    this.title,
    this.content,
    this.farmID,
    this.planID,
    this.isUpdated,
  });
}
