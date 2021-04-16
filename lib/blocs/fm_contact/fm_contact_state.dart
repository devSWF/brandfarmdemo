
import 'package:BrandFarm/models/contact/contact_model.dart';
import 'package:flutter/material.dart';

class FMContactState {
  bool isLoading;
  List<FMContact> contactList;
  int row;
  int col;
  List<List<FMContact>> cList;

  FMContactState({
    @required this.isLoading,
    @required this.contactList,
    @required this.row,
    @required this.col,
    @required this.cList,
  });

  factory FMContactState.empty() {
    return FMContactState(
      isLoading: false,
      contactList: [],
      row: 0,
      col: 0,
      cList: [],
    );
  }

  FMContactState copyWith({
    bool isLoading,
    List<FMContact> contactList,
    int row,
    int col,
    List<List<FMContact>> cList,
  }) {
    return FMContactState(
      isLoading: isLoading ?? this.isLoading,
      contactList: contactList ?? this.contactList,
      row: row ?? this.row,
      col: col ?? this.col,
      cList: cList ?? this.cList,
    );
  }

  FMContactState update({
    bool isLoading,
    List<FMContact> contactList,
    int row,
    int col,
    List<List<FMContact>> cList,
  }) {
    return copyWith(
      isLoading: isLoading,
      contactList: contactList,
      row: row,
      col: col,
      cList: cList,
    );
  }

  @override
  String toString() {
    return '''FMContactState{
    isLoading: $isLoading,
    contactList: ${contactList.length},
    row: ${row},
    col: ${col},
    cList: ${cList.length},
    }
    ''';
  }
}
