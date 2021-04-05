
import 'package:flutter/material.dart';

class FMHomeState {
  bool isLoading;
  int selectedIndex;
  int pageIndex;
  int subPageIndex;

  FMHomeState({
    @required this.isLoading,
    @required this.selectedIndex,
    @required this.pageIndex,
    @required this.subPageIndex,
  });

  factory FMHomeState.empty() {
    return FMHomeState(
      isLoading: false,
      selectedIndex: 0,
      pageIndex: 0,
      subPageIndex: 0,
    );
  }

  FMHomeState copyWith({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
  }) {
    return FMHomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
    );
  }

  FMHomeState update({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
  }) {
    return copyWith(
      isLoading: isLoading,
      selectedIndex: selectedIndex,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
    );
  }

  @override
  String toString() {
    return '''FMHomeState{
    isLoading: $isLoading,
    selectedIndex: $selectedIndex,
    pageIndex: $pageIndex,
    subPageIndex: $subPageIndex,
    }
    ''';
  }
}
