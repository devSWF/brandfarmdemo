

import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:flutter/material.dart';

class FMPlanState {
  bool isLoading;
  Farm farm;
  List<Field> fieldList;
  Field field;

  List<FMPlan> planList;
  DateTime selectedDate;
  List<FMPlan> detailList;
  List<FMPlan> todoPlanListShort;
  List<CalendarPlan> detailListShort;
  List<List<List<CalendarPlan>>> sortedList;
  List<DateTime> fmHomeCalendarDateList;
  int selectedIndex;

  int selectedField;
  DateTime startDate;
  DateTime endDate;
  WaitingConfirmation wPlan;
  bool isConfirmed;

  FMPlan newPlan;

  FMPlanState({
    @required this.isLoading,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.planList,
    @required this.detailList,
    @required this.todoPlanListShort,
    @required this.detailListShort,
    @required this.sortedList,
    @required this.fmHomeCalendarDateList,
    @required this.selectedIndex,
    @required this.selectedDate,
    @required this.selectedField,
    @required this.startDate,
    @required this.endDate,
    @required this.wPlan,
    @required this.isConfirmed,
    @required this.newPlan,
  });

  factory FMPlanState.empty() {
    return FMPlanState(
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
      planList: [],
      detailList: [],
      todoPlanListShort: [],
      detailListShort: [],
      sortedList: [],
      fmHomeCalendarDateList: [],
      selectedIndex: 2,
      selectedDate: DateTime.now(),
      selectedField: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      wPlan: WaitingConfirmation(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        title: '',
        content: '',
        selectedFieldIndex: 0,
        isUpdated: false,
      ),
      isConfirmed: false,
      newPlan: null,
    );
  }

  FMPlanState copyWith({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    List<FMPlan> todoPlanListShort,
    List<CalendarPlan> detailListShort,
    List<List<List<CalendarPlan>>> sortedList,
    List<DateTime> fmHomeCalendarDateList,
    int selectedIndex,
    DateTime selectedDate,
    int selectedField,
    DateTime startDate,
    DateTime endDate,
    WaitingConfirmation wPlan,
    bool isConfirmed,
    FMPlan newPlan
  }) {
    return FMPlanState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      planList: planList ?? this.planList,
      detailList: detailList ?? this.detailList,
      todoPlanListShort: todoPlanListShort ?? this.todoPlanListShort,
      detailListShort: detailListShort ?? this.detailListShort,
      sortedList: sortedList ?? this.sortedList,
      fmHomeCalendarDateList: fmHomeCalendarDateList ?? this.fmHomeCalendarDateList,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedField: selectedField ?? this.selectedField,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      wPlan: wPlan ?? this.wPlan,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      newPlan: newPlan ?? this.newPlan,
    );
  }

  FMPlanState update({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    List<FMPlan> todoPlanListShort,
    List<CalendarPlan> detailListShort,
    List<List<List<CalendarPlan>>> sortedList,
    List<DateTime> fmHomeCalendarDateList,
    int selectedIndex,
    DateTime selectedDate,
    int selectedField,
    DateTime startDate,
    DateTime endDate,
    WaitingConfirmation wPlan,
    bool isConfirmed,
    FMPlan newPlan
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      fieldList: fieldList,
      field: field,
      planList: planList,
      detailList: detailList,
      todoPlanListShort: todoPlanListShort,
      detailListShort: detailListShort,
      sortedList: sortedList,
      fmHomeCalendarDateList: fmHomeCalendarDateList,
      selectedIndex: selectedIndex,
      selectedDate: selectedDate,
      selectedField: selectedField,
      startDate: startDate,
      endDate: endDate,
      wPlan: wPlan,
      isConfirmed: isConfirmed,
      newPlan: newPlan,
    );
  }

  @override
  String toString() {
    return '''FMPlanState{
    isLoading: $isLoading,
    farm: ${farm},
    fieldList: ${fieldList.length},
    field: ${field},
    planList: ${planList.length},
    detailList: ${detailList.length},
    todoPlanListShort: ${todoPlanListShort.length},
    detailListShort: ${detailListShort.length},
    sortedList: ${sortedList.length},
    fmHomeCalendarDateList: ${fmHomeCalendarDateList.length},
    selectedIndex: ${selectedIndex},
    selectedDate: ${selectedDate},
    selectedField: ${selectedField},
    startDate: ${startDate},
    endDate: ${endDate},
    wPlan: ${wPlan},
    isConfirmed: ${isConfirmed},
    newPlan: ${newPlan},
    }
    ''';
  }
}
