
import 'package:BrandFarm/models/field_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FMPlanEvent extends Equatable{
  const FMPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPlan extends FMPlanEvent{}

class GetFieldListForFMPlan extends FMPlanEvent {}

class GetPlanList extends FMPlanEvent {}

class PostNewPlan extends FMPlanEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final String content;
  final int selectedField;

  const PostNewPlan({
    @required this.startDate,
    @required this.endDate,
    @required this.title,
    @required this.content,
    @required this.selectedField,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PostNewPlan { 
    startDate : $startDate,
    endDate : $endDate,
    title : $title,
    content : $content,
    selectedField : $selectedField,
  }''';
}

class SetDate extends FMPlanEvent{
  final DateTime date;

  const SetDate({
    @required this.date,
  });

  @override
  String toString() => '''SetDate {
    date: $date,
  }''';
}

class SetSelectedField extends FMPlanEvent{
  final int selectedField;

  const SetSelectedField({
    @required this.selectedField,
  });

  @override
  String toString() => '''SetSelectedField {
    selectedField: $selectedField,
  }''';
}

class SetStartDate extends FMPlanEvent{
  final DateTime startDate;

  const SetStartDate({
    @required this.startDate,
  });

  @override
  String toString() => '''SetStartDate {
    startDate: $startDate,
  }''';
}

class SetEndDate extends FMPlanEvent{
  final DateTime endDate;

  const SetEndDate({
    @required this.endDate,
  });

  @override
  String toString() => '''SetEndDate {
    endDate: $endDate,
  }''';
}