import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:flutter/material.dart';

class OMPlanState {
  bool isLoading;
  Farm farm;
  List<Farm> farmList;

  List<OMPlan> planList;
  DateTime selectedDate;
  List<OMPlan> detailList;
  List<OMPlan> todoPlanListShort;
  List<OMCalendarPlan> detailListShort;
  List<List<List<OMCalendarPlan>>> sortedList;
  List<DateTime> omHomeCalendarDateList;
  int selectedIndex;

  int selectedFarm;
  DateTime startDate;
  DateTime endDate;
  OMWaitingConfirmation wPlan;
  bool isConfirmed;
  OMPlan newPlan;

  OMPlanState({
    @required this.isLoading,
    @required this.farm,
    @required this.farmList,
    @required this.planList,
    @required this.detailList,
    @required this.todoPlanListShort,
    @required this.detailListShort,
    @required this.sortedList,
    @required this.omHomeCalendarDateList,
    @required this.selectedIndex,
    @required this.selectedDate,
    @required this.selectedFarm,
    @required this.startDate,
    @required this.endDate,
    @required this.wPlan,
    @required this.isConfirmed,
    @required this.newPlan,
  });

  factory OMPlanState.empty() {
    return OMPlanState(
      isLoading: false,
      farm: Farm(
          farmID: '', fieldCategory: '', managerID: '', officeNum: 1, name: ''),
      farmList: [],
      planList: [],
      detailList: [],
      todoPlanListShort: [],
      detailListShort: [],
      sortedList: [],
      omHomeCalendarDateList: [],
      selectedIndex: 2,
      selectedDate: DateTime.now(),
      selectedFarm: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      wPlan: OMWaitingConfirmation(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        title: '',
        content: '',
        selectedFarmIndex: 0,
        isUpdated: false,
      ),
      isConfirmed: false,
      newPlan: null,
    );
  }

  OMPlanState copyWith(
      {bool isLoading,
      Farm farm,
      List<Farm> farmList,
      List<OMPlan> planList,
      List<OMPlan> detailList,
      List<OMPlan> todoPlanListShort,
      List<OMCalendarPlan> detailListShort,
      List<List<List<OMCalendarPlan>>> sortedList,
      List<DateTime> omHomeCalendarDateList,
      int selectedIndex,
      DateTime selectedDate,
      int selectedFarm,
      DateTime startDate,
      DateTime endDate,
      OMWaitingConfirmation wPlan,
      bool isConfirmed,
      OMPlan newPlan}) {
    return OMPlanState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      farmList: farmList ?? this.farmList,
      planList: planList ?? this.planList,
      detailList: detailList ?? this.detailList,
      todoPlanListShort: todoPlanListShort ?? this.todoPlanListShort,
      detailListShort: detailListShort ?? this.detailListShort,
      sortedList: sortedList ?? this.sortedList,
      omHomeCalendarDateList:
          omHomeCalendarDateList ?? this.omHomeCalendarDateList,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedFarm: selectedFarm ?? this.selectedFarm,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      wPlan: wPlan ?? this.wPlan,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      newPlan: newPlan ?? this.newPlan,
    );
  }

  OMPlanState update(
      {bool isLoading,
      Farm farm,
      List<Farm> farmList,
      List<OMPlan> planList,
      List<OMPlan> detailList,
      List<OMPlan> todoPlanListShort,
      List<OMCalendarPlan> detailListShort,
      List<List<List<OMCalendarPlan>>> sortedList,
      List<DateTime> omHomeCalendarDateList,
      int selectedIndex,
      DateTime selectedDate,
      int selectedFarm,
      DateTime startDate,
      DateTime endDate,
      OMWaitingConfirmation wPlan,
      bool isConfirmed,
      OMPlan newPlan}) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      farmList: farmList,
      planList: planList,
      detailList: detailList,
      todoPlanListShort: todoPlanListShort,
      detailListShort: detailListShort,
      sortedList: sortedList,
      omHomeCalendarDateList: omHomeCalendarDateList,
      selectedIndex: selectedIndex,
      selectedDate: selectedDate,
      selectedFarm: selectedFarm,
      startDate: startDate,
      endDate: endDate,
      wPlan: wPlan,
      isConfirmed: isConfirmed,
      newPlan: newPlan,
    );
  }

  @override
  String toString() {
    return '''OMPlanState{
    isLoading: $isLoading,
    farm: ${farm},
    farmList: ${farmList.length},
    planList: ${planList.length},
    detailList: ${detailList.length},
    todoPlanListShort: ${todoPlanListShort.length},
    detailListShort: ${detailListShort.length},
    sortedList: ${sortedList.length},
    omHomeCalendarDateList: ${omHomeCalendarDateList.length},
    selectedIndex: ${selectedIndex},
    selectedDate: ${selectedDate},
    selectedFarm: ${selectedFarm},
    startDate: ${startDate},
    endDate: ${endDate},
    wPlan: ${wPlan},
    isConfirmed: ${isConfirmed},
    newPlan: ${newPlan},
    }
    ''';
  }
}
