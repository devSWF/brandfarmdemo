

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
  List<FMPlan> detailListShort;

  int selectedField;
  DateTime startDate;
  DateTime endDate;
  WaitingConfirmation wPlan;
  bool isConfirmed;

  FMPlanState({
    @required this.isLoading,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.planList,
    @required this.detailList,
    @required this.detailListShort,
    @required this.selectedDate,
    @required this.selectedField,
    @required this.startDate,
    @required this.endDate,
    @required this.wPlan,
    @required this.isConfirmed,
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
      detailListShort: [],
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
      ),
      isConfirmed: false,
    );
  }

  FMPlanState copyWith({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    List<FMPlan> detailListShort,
    DateTime selectedDate,
    int selectedField,
    DateTime startDate,
    DateTime endDate,
    WaitingConfirmation wPlan,
    bool isConfirmed,
  }) {
    return FMPlanState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      planList: planList ?? this.planList,
      detailList: detailList ?? this.detailList,
      detailListShort: detailListShort ?? this.detailListShort,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedField: selectedField ?? this.selectedField,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      wPlan: wPlan ?? this.wPlan,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  FMPlanState update({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    List<FMPlan> detailListShort,
    DateTime selectedDate,
    int selectedField,
    DateTime startDate,
    DateTime endDate,
    WaitingConfirmation wPlan,
    bool isConfirmed,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      fieldList: fieldList,
      field: field,
      planList: planList,
      detailList: detailList,
      detailListShort: detailListShort,
      selectedDate: selectedDate,
      selectedField: selectedField,
      startDate: startDate,
      endDate: endDate,
      wPlan: wPlan,
      isConfirmed: isConfirmed,
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
    detailListShort: ${detailListShort.length},
    selectedDate: ${selectedDate},
    selectedField: ${selectedField},
    startDate: ${startDate},
    endDate: ${endDate},
    wPlan: ${wPlan},
    isConfirmed: ${isConfirmed},
    }
    ''';
  }
}
