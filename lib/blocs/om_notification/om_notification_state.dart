import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:flutter/material.dart';

class OMNotificationState {
  bool isLoading;
  Farm farm;
  List<Farm> farmList;

  int currentSortColumn;
  bool isAscending;

  List<NotificationNotice> notificationList;
  List<NotificationNotice> notificationListFromDB;

  List<String> menu;
  int menuIndex;
  bool showDropdownMenu;
  NotificationNotice notice;

  OMNotificationState({
    @required this.isLoading,
    @required this.farm,
    @required this.farmList,
    @required this.currentSortColumn,
    @required this.isAscending,
    @required this.notificationList,
    @required this.notificationListFromDB,
    @required this.menu,
    @required this.menuIndex,
    @required this.showDropdownMenu,
    @required this.notice,
  });

  factory OMNotificationState.empty() {
    return OMNotificationState(
      isLoading: false,
      farm: Farm(farmID: '', fieldCategory: '', managerID: ''),
      farmList: [],
      currentSortColumn: 0,
      isAscending: false,
      notificationList: [],
      notificationListFromDB: [],
      menu: [
        'No.',
        '제목',
        '게시자',
      ],
      menuIndex: 0,
      showDropdownMenu: false,
      notice: null,
    );
  }

  OMNotificationState copyWith({
    bool isLoading,
    Farm farm,
    List<Farm> farmList,
    int currentSortColumn,
    bool isAscending,
    List<NotificationNotice> notificationList,
    List<NotificationNotice> notificationListFromDB,
    List<String> menu,
    int menuIndex,
    bool showDropdownMenu,
    NotificationNotice notice,
  }) {
    return OMNotificationState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      farmList: farmList ?? this.farmList,
      currentSortColumn: currentSortColumn ?? this.currentSortColumn,
      isAscending: isAscending ?? this.isAscending,
      notificationList: notificationList ?? this.notificationList,
      notificationListFromDB:
          notificationListFromDB ?? this.notificationListFromDB,
      menu: menu ?? this.menu,
      menuIndex: menuIndex ?? this.menuIndex,
      showDropdownMenu: showDropdownMenu ?? this.showDropdownMenu,
      notice: notice ?? this.notice,
    );
  }

  OMNotificationState update({
    bool isLoading,
    Farm farm,
    List<Farm> farmList,
    int currentSortColumn,
    bool isAscending,
    List<NotificationNotice> notificationList,
    List<NotificationNotice> notificationListFromDB,
    List<String> menu,
    int menuIndex,
    bool showDropdownMenu,
    NotificationNotice notice,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      farmList: farmList,
      currentSortColumn: currentSortColumn,
      isAscending: isAscending,
      notificationList: notificationList,
      notificationListFromDB: notificationListFromDB,
      menu: menu,
      menuIndex: menuIndex,
      showDropdownMenu: showDropdownMenu,
      notice: notice,
    );
  }

  @override
  String toString() {
    return '''OMNotificationState{
    isLoading: $isLoading,
    farm: ${farm},
    farmList: ${farmList.length},
    currentSortColumn: ${currentSortColumn},
    isAscending: ${isAscending},
    notificationList: ${notificationList.length},
    notificationListFromDB: ${notificationListFromDB.length},
    menu: ${menu.length},
    menuIndex: ${menuIndex},
    showDropdownMenu: ${showDropdownMenu},
    notice: ${notice},
    }
    ''';
  }
}
