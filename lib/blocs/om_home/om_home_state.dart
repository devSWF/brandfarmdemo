import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/om_home/om_home_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:flutter/material.dart';

class OMHomeState {
  bool isLoading;
  int pageIndex;
  int subPageIndex;

  List<OMHomeRecentUpdates> recentUpdateList;

  List<NotificationNotice> notice;
  List<Plan> plan;
  List<Purchase> purchase;
  List<Journal> journal;
  List<SubJournalIssue> issue;

  OMHomeState({
    @required this.isLoading,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.notice,
    @required this.plan,
    @required this.purchase,
    @required this.journal,
    @required this.issue,
  });

  factory OMHomeState.empty() {
    return OMHomeState(
      isLoading: false,
      pageIndex: 0,
      subPageIndex: 0,
      recentUpdateList: [],
      notice: [],
      plan: [],
      purchase: [],
      journal: [],
      issue: [],
    );
  }

  OMHomeState copyWith({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
  }) {
    return OMHomeState(
      isLoading: isLoading ?? this.isLoading,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      notice: notice ?? this.notice,
      plan: plan ?? this.plan,
      purchase: purchase ?? this.purchase,
      journal: journal ?? this.journal,
      issue: issue ?? this.issue,
    );
  }

  OMHomeState update({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
  }) {
    return copyWith(
      isLoading: isLoading,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      notice: notice,
      plan: plan,
      purchase: purchase,
      journal: journal,
      issue: issue,
    );
  }

  @override
  String toString() {
    return '''OMHomeState{
    isLoading : $isLoading,
    pageIndex : $pageIndex,
    subPageIndex : $subPageIndex,
    recentUpdateList: ${recentUpdateList.length},
    notice : $notice,
    plan: ${plan.length},
    purchase: ${purchase.length},
    journal: ${journal.length},
    issue: ${issue.length},
    }''';
  }
}
