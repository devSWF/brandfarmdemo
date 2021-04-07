import 'dart:io';

import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class JournalIssueModifyState {
  final String title;
  final List<File> imageList;
  final List<Asset> assetList;
  final List<ImagePicture> existingImageList;
  final List<ImagePicture> deletedFromExistingImageList;
  final bool isComplete;
  final bool isUploaded;

  final bool isModifyLoading;

  JournalIssueModifyState({
    @required this.title,
    @required this.imageList,
    @required this.assetList,
    @required this.existingImageList,
    @required this.deletedFromExistingImageList,
    @required this.isComplete,
    @required this.isUploaded,
    @required this.isModifyLoading,
  });

  factory JournalIssueModifyState.empty() {
    return JournalIssueModifyState(
      title: '',
      imageList: [],
      assetList: [],
      existingImageList: [],
      deletedFromExistingImageList: [],
      isComplete: false,
      isUploaded: false,
      isModifyLoading: false,
    );
  }

  JournalIssueModifyState copyWith({
    String title,
    List<File> imageList,
    List<Asset> assetList,
    List<ImagePicture> existingImageList,
    List<ImagePicture> deletedFromExistingImageList,
    bool isComplete,
    bool isUploaded,
    bool isModifyLoading,
  }) {
    return JournalIssueModifyState(
      title: title ?? this.title,
      imageList: imageList ?? this.imageList,
      assetList: assetList ?? this.assetList,
      existingImageList: existingImageList ?? this.existingImageList,
      deletedFromExistingImageList: deletedFromExistingImageList ?? this.deletedFromExistingImageList,
      isComplete: isComplete ?? this.isComplete,
      isUploaded: isUploaded ?? this.isUploaded,
      isModifyLoading: isModifyLoading ?? this.isModifyLoading,
    );
  }

  JournalIssueModifyState update({
    String title,
    List<File> imageList,
    List<Asset> assetList,
    List<ImagePicture> existingImageList,
    List<ImagePicture> deletedFromExistingImageList,
    bool isComplete,
    bool isUploaded,
    bool isModifyLoading,
  }) {
    return copyWith(
      title: title,
      imageList: imageList,
      assetList: assetList,
      existingImageList: existingImageList,
      deletedFromExistingImageList: deletedFromExistingImageList,
      isComplete: isComplete,
      isUploaded: isUploaded,
      isModifyLoading: isModifyLoading,
    );
  }

  @override
  String toString() {
    return '''JournalIssueModifyState{
    title: $title,
    imageList: ${imageList?.length ?? 0},
    assetList: ${assetList?.length ?? 0},
    existingImageList: ${existingImageList?.length ?? 0},
    deletedFromExistingImageList: ${deletedFromExistingImageList?.length ?? 0},
    isComplete: ${isComplete},
    isUploaded: ${isUploaded},
    isModifyLoading: $isModifyLoading,
   }''';
  }
}
