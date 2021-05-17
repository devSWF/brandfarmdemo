import 'package:flutter/material.dart';

class OMHomeState {
  bool isLoading;
  int pageIndex;
  int subPageIndex;

  OMHomeState({
    @required this.isLoading,
    @required this.pageIndex,
    @required this.subPageIndex,
  });

  factory OMHomeState.empty() {
    return OMHomeState(
      isLoading: false,
      pageIndex: 0,
      subPageIndex: 0,
    );
  }

  OMHomeState copyWith({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
  }) {
    return OMHomeState(
      isLoading: isLoading ?? this.isLoading,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
    );
  }

  OMHomeState update({
    bool isLoading,
    int pageIndex,
    int subPageIndex,
  }) {
    return copyWith(
      isLoading: isLoading,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
    );
  }

  @override
  String toString() {
    return '''OMHomeState{
    isLoading : $isLoading,
    pageIndex : $pageIndex,
    subPageIndex : $subPageIndex,
    }''';
  }
}
