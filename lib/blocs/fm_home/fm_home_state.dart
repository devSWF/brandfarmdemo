
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:flutter/material.dart';

class FMHomeState {
  bool isLoading;
  int selectedIndex;
  int pageIndex;
  int subPageIndex;
  List<FMHomeRecentUpdates> recentUpdateList;
  Farm farm;
  List<Field> fieldList;

  FMHomeState({
    @required this.isLoading,
    @required this.selectedIndex,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.farm,
    @required this.fieldList,
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
  }) {
    return FMHomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
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
  }) {
    return copyWith(
      isLoading: isLoading,
      selectedIndex: selectedIndex,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      farm: farm,
      fieldList: fieldList,
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
    }
    ''';
  }
}
