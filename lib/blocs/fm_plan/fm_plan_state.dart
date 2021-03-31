

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

  int selectedField;

  FMPlanState({
    @required this.isLoading,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.planList,
    @required this.detailList,
    @required this.selectedDate,
    @required this.selectedField,
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
      selectedDate: DateTime.now(),
      selectedField: 0,
    );
  }

  FMPlanState copyWith({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    DateTime selectedDate,
    int selectedField,
  }) {
    return FMPlanState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      planList: planList ?? this.planList,
      detailList: detailList ?? this.detailList,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedField: selectedField ?? this.selectedField,
    );
  }

  FMPlanState update({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
    List<FMPlan> detailList,
    DateTime selectedDate,
    int selectedField,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      fieldList: fieldList,
      field: field,
      planList: planList,
      detailList: detailList,
      selectedDate: selectedDate,
      selectedField: selectedField,
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
    selectedDate: ${selectedDate},
    selectedField: ${selectedField},
    }
    ''';
  }
}
