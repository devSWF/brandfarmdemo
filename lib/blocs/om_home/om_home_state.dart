import 'package:BrandFarm/models/om_home/om_home_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:flutter/material.dart';

class OMHomeState {
  bool isLoading;
  int pageIndex;
  int subPageIndex;

  List<OMHomeRecentUpdates> recentUpdateList;

  List<OMNotificationNotice> notice;
  List<OMPlan> plan;
  List<Purchase> purchase;

  OMHomeState({
    @required this.isLoading,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.notice,
    @required this.plan,
    @required this.purchase,
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
    );
  }

  OMHomeState copyWith({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    List<OMNotificationNotice> notice,
    List<OMPlan> plan,
    List<Purchase> purchase,
  }) {
    return OMHomeState(
      isLoading: isLoading ?? this.isLoading,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      notice: notice ?? this.notice,
      plan: plan ?? this.plan,
      purchase: purchase ?? this.purchase,
    );
  }

  OMHomeState update({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    List<OMNotificationNotice> notice,
    List<OMPlan> plan,
    List<Purchase> purchase,
  }) {
    return copyWith(
      isLoading: isLoading,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      notice: notice,
      plan: plan,
      purchase: purchase,
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
    }''';
  }
}
