
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:flutter/material.dart';

class FMHomeState {
  bool isLoading;
  int selectedIndex;
  int pageIndex;
  int subPageIndex;
  List<FMHomeRecentUpdates> recentUpdateList;
  Farm farm;
  List<Field> fieldList;

  List<NotificationNotice> notice;
  List<Plan> plan;
  List<Purchase> purchase;
  List<Journal> journal;
  List<SubJournalIssue> issue;

  FMHomeState({
    @required this.isLoading,
    @required this.selectedIndex,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.farm,
    @required this.fieldList,
    @required this.notice,
    @required this.plan,
    @required this.purchase,
    @required this.journal,
    @required this.issue,
  });

  factory FMHomeState.empty() {
    return FMHomeState(
      isLoading: false,
      selectedIndex: 0,
      pageIndex: 0,
      subPageIndex: 0,
      recentUpdateList: [],
      farm: null,
      fieldList: [],
      notice: [],
      plan: [],
      purchase: [],
      journal: [],
      issue: [],
    );
  }

  FMHomeState copyWith({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<FMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Field> fieldList,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
  }) {
    return FMHomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      notice: notice ?? this.notice,
      plan: plan ?? this.plan,
      purchase: purchase ?? this.purchase,
      journal: journal ?? this.journal,
      issue: issue ?? this.issue,
    );
  }

  FMHomeState update({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<FMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Field> fieldList,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
  }) {
    return copyWith(
      isLoading: isLoading,
      selectedIndex: selectedIndex,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      farm: farm,
      fieldList: fieldList,
      notice: notice,
      plan: plan,
      purchase: purchase,
      journal: journal,
      issue: issue,
    );
  }

  @override
  String toString() {
    return '''FMHomeState{
    isLoading: $isLoading,
    selectedIndex: $selectedIndex,
    pageIndex: $pageIndex,
    subPageIndex: $subPageIndex,
    recentUpdateList: ${recentUpdateList.length},
    farm: ${farm},
    fieldList: ${fieldList.length},
    notice: ${notice.length},
    plan: ${plan.length},
    purchase: ${purchase.length},
    journal: ${journal.length},
    issue: ${issue.length},
    }
    ''';
  }
}
