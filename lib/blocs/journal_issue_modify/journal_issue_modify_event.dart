
import 'dart:io';

import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class JournalIssueModifyEvent extends Equatable{
  const JournalIssueModifyEvent();

  @override
  List<Object> get props => [];
}

class ModifyLoading extends JournalIssueModifyEvent{
  @override
  String toString() {
    return 'abcabc';
  }
}

class ModifyLoaded extends JournalIssueModifyEvent{}

class SelectImageM extends JournalIssueModifyEvent{
  final List<Asset> assetList;

  const SelectImageM({@required this.assetList});

  @override
  String toString() => 'SelectImageM {assetList: $assetList}';
}

class AddImageFileM extends JournalIssueModifyEvent{
  final File imageFile;
  final int index;
  final int from; // gallery 0 / camera 1

  const AddImageFileM({@required this.imageFile, int index, int from})
      : this.index = index ?? 0,
        this.from = from ?? 0;

  @override
  String toString() => 'AddImageFileM {imageFile: ${imageFile.path}}';
}

class DeleteImageFile extends JournalIssueModifyEvent{
  final File removedFile;

  const DeleteImageFile({@required this.removedFile});

  @override
  String toString() => 'DeleteImageFile {removedFile: ${removedFile}}';
}

class PressComplete extends JournalIssueModifyEvent{}

class UpdateJournal extends JournalIssueModifyEvent {
  final String fid;
  final String sfmid;
  final String uid;
  final String issid;
  final String title;
  final int category; // 작물 1 / 시설 2 / 기타 3
  final int issueState; // 예상 1 / 진행 2 / 완료 3
  final String contents;
  final int comments;
  final bool isReadByFM;
  final bool isReadByOffice;

  const UpdateJournal({
    @required this.fid,
    @required this.sfmid,
    @required this.uid,
    @required this.issid,
    @required this.title,
    @required this.category,
    @required this.issueState,
    @required this.contents,
    @required this.comments,
    @required this.isReadByFM,
    @required this.isReadByOffice,
  });

  @override
  String toString() {
    return '''UpdateJournal {
      fid: $fid, 
      sfmid: $sfmid,
      uid: $uid,
      issid: $issid,
      title: $title,
      category: $category,
      issueState: $issueState,
      contents: $contents,
      comments: $comments,
      isReadByFM: $isReadByFM,
      isReadByOffice: $isReadByOffice,
    }''';
  }
}

class GetImageList extends JournalIssueModifyEvent {
  final String issid;

  const GetImageList({
    @required this.issid,
  });

  @override
  String toString() {
    return '''GetImageList {
      issid, ${issid},
    }''';
  }
}

class DeleteExistingImage extends JournalIssueModifyEvent {
  final ImagePicture obj;

  const DeleteExistingImage({
    @required this.obj,
  });

  @override
  String toString() {
    return '''DeleteExistingImage {
      obj, ${obj},
    }''';
  }
}