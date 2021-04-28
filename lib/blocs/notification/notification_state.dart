
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationState {
  bool isLoading;
  Farm farm;
  List<NotificationNotice> allList;
  List<NotificationNotice> importantList;
  List<NotificationNotice> generalList;
  int unRead;

  NotificationState({
    @required this.isLoading,
    @required this.farm,
    @required this.allList,
    @required this.importantList,
    @required this.generalList,
    @required this.unRead,
  });

  factory NotificationState.empty() {
    return NotificationState(
      isLoading: false,
      farm: Farm(
          farmID: '',
          fieldCategory: '',
          managerID: ''
      ),
      allList: [],
      importantList: [],
      generalList: [],
      unRead: 0,
    );
  }

  NotificationState copyWith({
    bool isLoading,
    Farm farm,
    List<NotificationNotice> allList,
    List<NotificationNotice> importantList,
    List<NotificationNotice> generalList,
    int unRead,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      allList: allList ?? this.allList,
      importantList: importantList ?? this.importantList,
      generalList: generalList ?? this.generalList,
      unRead: unRead ?? this.unRead,
    );
  }

  NotificationState update({
    bool isLoading,
    Farm farm,
    List<NotificationNotice> allList,
    List<NotificationNotice> importantList,
    List<NotificationNotice> generalList,
    int unRead,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      allList: allList,
      importantList: importantList,
      generalList: generalList,
      unRead: unRead,
    );
  }

  @override
  String toString() {
    return '''NotificationState{
      isLoading: $isLoading,
      farm: $farm,
      allList: ${allList.length},
      importantList: ${importantList.length},
      generalList: ${generalList.length},
      unRead: ${unRead},
    }
    ''';
  }
}
