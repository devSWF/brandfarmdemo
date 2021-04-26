import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:flutter/foundation.dart';
import 'package:BrandFarm/utils/todays_date.dart';

class HomeState {
  bool isLoading;
  int selectedMonth;
  int selectedYear;
  int selectedDate;
  int currentDate;

  List<FMPlan> planListFromDB;
  List<CalendarPlan> planList;

  HomeState({
    @required this.isLoading,
    @required this.selectedYear,
    @required this.selectedMonth,
    @required this.selectedDate,
    @required this.currentDate,
    @required this.planListFromDB,
    @required this.planList,
  });

  factory HomeState.empty() {
    return HomeState(
      isLoading: false,
      selectedMonth: int.parse('$month'),
      selectedYear: int.parse('$year'),
      selectedDate: int.parse('$day'),
      currentDate: int.parse('$day'),
      planListFromDB: [],
      planList: [],
    );
  }

  HomeState copyWith({
    bool isLoading,
    int monthState,
    int yearState,
    int dayState,
    int currentIndex,
    List<FMPlan> planListFromDB,
    List<CalendarPlan> planList,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedMonth: monthState ?? this.selectedMonth,
      selectedYear: yearState ?? this.selectedYear,
      selectedDate: dayState ?? this.selectedDate,
      currentDate: currentIndex ?? this.currentDate,
      planListFromDB: planListFromDB ?? this.planListFromDB,
      planList: planList ?? this.planList,
    );
  }

  HomeState update({
    bool isLoading,
    int monthState,
    int yearState,
    int dayState,
    int currentIndex,
    List<FMPlan> planListFromDB,
    List<CalendarPlan> planList,
  }) {
    return copyWith(
      isLoading: isLoading,
      monthState: monthState,
      yearState: yearState,
      dayState: dayState,
      currentIndex: currentIndex,
      planListFromDB: planListFromDB,
      planList: planList,
    );
  }

  @override
  String toString() {
    return '''HomeState{
    isLoading: $isLoading,
    monthState: $selectedMonth,
    yearState: $selectedYear,
    dayState: $selectedDate,
    currentIndex: $currentDate,
    planListFromDB: ${planListFromDB.length},
    planList: ${planList.length},
    }
    ''';
  }
}
