import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OMHomeRecentUpdates {
  final User user;
  final Timestamp date;
  final OMPlan plan;
  final OMNotificationNotice notice;
  final Purchase purchase;

  OMHomeRecentUpdates({
    @required this.date,
    @required this.user,
    @required this.plan,
    @required this.notice,
    @required this.purchase,
  });

  factory OMHomeRecentUpdates.fromSnapshot(DocumentSnapshot ds) {
    return OMHomeRecentUpdates(
      user: ds['user'],
      date: ds['date'],
      plan: ds['plan'],
      notice: ds['notice'],
      purchase: ds['purchase'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user': user,
      'plan': plan,
      'date': date,
      'notice': notice,
      'purchase': purchase,
    };
  }
}

class OMHomeUpdateState {
  bool state;
  int num;

  OMHomeUpdateState({this.state, this.num});
}
