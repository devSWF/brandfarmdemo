import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class JournalIssueCreateState {
  final String title;
  final List<File> imageList;
  final List<Asset> assetList;
  final bool isComplete;
  final bool isUploaded;
  final Timestamp selectedDate;

  JournalIssueCreateState({
    @required this.title,
    @required this.imageList,
    @required this.assetList,
    @required this.isComplete,
    @required this.isUploaded,
    @required this.selectedDate,
  });

  factory JournalIssueCreateState.empty() {
    return JournalIssueCreateState(
      title: '',
      imageList: [],
      assetList: [],
      isComplete: false,
      isUploaded: false,
      selectedDate: Timestamp.now(),
    );
  }

  JournalIssueCreateState copyWith({
    String title,
    List<File> imageList,
    List<Asset> assetList,
    bool isComplete,
    bool isUploaded,
    Timestamp selectedDate,
  }) {
    return JournalIssueCreateState(
        title: title ?? this.title,
      imageList: imageList ?? this.imageList,
      assetList: assetList ?? this.assetList,
      isComplete: isComplete ?? this.isComplete,
      isUploaded: isUploaded ?? this.isUploaded,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  JournalIssueCreateState update({
    String title,
    List<File> imageList,
    List<Asset> assetList,
    bool isComplete,
    bool isUploaded,
    Timestamp selectedDate,
  }) {
    return copyWith(
        title: title,
      imageList: imageList,
      assetList: assetList,
      isComplete: isComplete,
      isUploaded: isUploaded,
      selectedDate: selectedDate,
    );
  }

  @override
  String toString() {
    return '''JournalIssueCreateState{
    title: $title,
    imageList: ${imageList?.length ?? 0},
    assetList: ${assetList?.length ?? 0},
    isComplete: ${isComplete},
    isUploaded: ${isUploaded},
    selectedDate: ${selectedDate},
   }''';
  }
}
