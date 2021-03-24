

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

  FMPlanState({
    @required this.isLoading,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.planList,
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
    );
  }

  FMPlanState copyWith({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
  }) {
    return FMPlanState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      planList: planList ?? this.planList,
    );
  }

  FMPlanState update({
    bool isLoading,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPlan> planList,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      fieldList: fieldList,
      field: field,
      planList: planList,
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
    }
    ''';
  }
}
