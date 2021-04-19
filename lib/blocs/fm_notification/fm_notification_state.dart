

import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:flutter/material.dart';

class FMNotificationState {
  bool isLoading;
  Farm farm;
  List<Field> fieldList;
  Field field;

  int currentSortColumn;
  bool isAscending;

  List<NotificationNotice> notificationList;
  List<NotificationNotice> notificationListFromDB;

  List<String> menu;
  int menuIndex;
  bool showDropdownMenu;
  NotificationNotice notice;

  FMNotificationState({
    @required this.isLoading,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.currentSortColumn,
    @required this.isAscending,
    @required this.notificationList,
    @required this.notificationListFromDB,
    @required this.menu,
    @required this.menuIndex,
    @required this.showDropdownMenu,
    @required this.notice,
  });

  factory FMNotificationState.empty() {
    return FMNotificationState(
      isLoading: false,
      farm: Farm(farmID: '', fieldCategory: '', managerID: ''),
      fieldList: [],
      field: Field(
          fieldCategory: '',
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: ''),
      currentSortColumn: 0,
      isAscending: false,
      notificationList: [],
      notificationListFromDB: [],
      menu: ['No.', '제목', '게시자',],
      menuIndex: 0,
      showDropdownMenu: false,
      notice: null,
    );
  }

  FMNotificationState copyWith({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    int currentSortColumn,
    bool isAscending,
    List<NotificationNotice> notificationList,
    List<NotificationNotice> notificationListFromDB,
    List<String> menu,
    int menuIndex,
    bool showDropdownMenu,
    NotificationNotice notice,
  }) {
    return FMNotificationState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      currentSortColumn: currentSortColumn ?? this.currentSortColumn,
      isAscending: isAscending ?? this.isAscending,
      notificationList: notificationList ?? this.notificationList,
      notificationListFromDB: notificationListFromDB ?? this.notificationListFromDB,
      menu: menu ?? this.menu,
      menuIndex: menuIndex ?? this.menuIndex,
      showDropdownMenu: showDropdownMenu ?? this.showDropdownMenu,
      notice: notice ?? this.notice,
    );
  }

  FMNotificationState update({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
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
      fieldList: fieldList,
      field: field,
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
    return '''FMNotificationState{
    isLoading: $isLoading,
    farm: ${farm},
    fieldList: ${fieldList.length},
    field: ${field},
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
