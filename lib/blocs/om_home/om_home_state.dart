import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/om_home/om_home_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:flutter/material.dart';

class OMHomeState {
  bool isLoading;
  int selectedIndex;
  int pageIndex;
  int subPageIndex;
  List<OMHomeRecentUpdates> recentUpdateList;
  Farm farm;
  List<Farm> farmList;

  List<OMNotificationNotice> notice;
  List<OMPlan> plan;
  List<Purchase> purchase;
  List<ImagePicture> picture;
  User user;
  int currentFarmIndex;

  OMHomeState({
    @required this.isLoading,
    @required this.selectedIndex,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.farm,
    @required this.farmList,
    @required this.notice,
    @required this.plan,
    @required this.purchase,
    @required this.picture,
    @required this.user,
    @required this.currentFarmIndex,
  });

  factory OMHomeState.empty() {
    return OMHomeState(
      isLoading: false,
      selectedIndex: 0,
      pageIndex: 0,
      subPageIndex: 0,
      recentUpdateList: [],
      farm: null,
      farmList: [],
      notice: [],
      plan: [],
      purchase: [],
      picture: [],
      user: null,
      currentFarmIndex: 0,
    );
  }

  OMHomeState copyWith({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Farm> farmList,
    List<OMNotificationNotice> notice,
    List<OMPlan> plan,
    List<Purchase> purchase,
    List<ImagePicture> picture,
    User user,
    int currentFarmIndex,
  }) {
    return OMHomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      farm: farm ?? this.farm,
      farmList: farmList ?? this.farmList,
      notice: notice ?? this.notice,
      plan: plan ?? this.plan,
      purchase: purchase ?? this.purchase,
      picture: picture ?? this.picture,
      user: user ?? user,
      currentFarmIndex: currentFarmIndex ?? currentFarmIndex,
    );
  }

  OMHomeState update({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<OMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Farm> farmList,
    List<OMNotificationNotice> notice,
    List<OMPlan> plan,
    List<Purchase> purchase,
    List<ImagePicture> picture,
    User user,
    int currentFarmIndex,
  }) {
    return copyWith(
      isLoading: isLoading,
      selectedIndex: selectedIndex,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      farm: farm,
      farmList: farmList,
      notice: notice,
      plan: plan,
      purchase: purchase,
      picture: picture,
      user: user,
      currentFarmIndex: currentFarmIndex,
    );
  }

  @override
  String toString() {
    return '''OMHomeState{
    isLoading: $isLoading,
    selectedIndex: $selectedIndex,
    pageIndex: $pageIndex,
    subPageIndex: $subPageIndex,
    recentUpdateList: ${recentUpdateList.length},
    farm: ${farm},
    farmList: ${farmList.length},
    notice: ${notice.length},
    plan: ${plan.length},
    purchase: ${purchase.length},
    picture: ${picture.length},
    user: ${user},
    currentFarmIndex: ${currentFarmIndex},
    }
    ''';
  }
}
