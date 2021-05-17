import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OMHomeRecentUpdates {
  final User user;
  final Timestamp date;
  final Plan plan;
  final NotificationNotice notice;
  final Purchase purchase;
  final Journal journal;
  final SubJournalIssue issue;
  final Comment comment;
  final SubComment subComment;

  OMHomeRecentUpdates({
    @required this.date,
    @required this.user,
    @required this.plan,
    @required this.notice,
    @required this.purchase,
    @required this.journal,
    @required this.issue,
    @required this.comment,
    @required this.subComment,
  });

  factory OMHomeRecentUpdates.fromSnapshot(DocumentSnapshot ds) {
    return OMHomeRecentUpdates(
      user: ds['user'],
      date: ds['date'],
      plan: ds['plan'],
      notice: ds['notice'],
      purchase: ds['purchase'],
      journal: ds['journal'],
      issue: ds['issue'],
      comment: ds['comment'],
      subComment: ds['subComment'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user': user,
      'plan': plan,
      'date': date,
      'notice': notice,
      'purchase': purchase,
      'journal': journal,
      'issue': issue,
      'comment': comment,
      'subComment': subComment,
    };
  }
}

class OMHomeUpdateState {
  bool state;
  int num;

  OMHomeUpdateState({this.state, this.num});
}