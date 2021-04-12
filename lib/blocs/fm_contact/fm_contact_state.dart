
import 'package:BrandFarm/models/contact/contact_model.dart';
import 'package:flutter/material.dart';

class FMContactState {
  bool isLoading;
  List<FMContact> contactList;

  FMContactState({
    @required this.isLoading,
    @required this.contactList,
  });

  factory FMContactState.empty() {
    return FMContactState(
      isLoading: false,
      contactList: [],
    );
  }

  FMContactState copyWith({
    bool isLoading,
    List<FMContact> contactList,
  }) {
    return FMContactState(
      isLoading: isLoading ?? this.isLoading,
      contactList: contactList ?? this.contactList,
    );
  }

  FMContactState update({
    bool isLoading,
    List<FMContact> contactList,
  }) {
    return copyWith(
      isLoading: isLoading,
      contactList: contactList,
    );
  }

  @override
  String toString() {
    return '''FMContactState{
    isLoading: $isLoading,
    contactList: ${contactList.length},
    }
    ''';
  }
}
