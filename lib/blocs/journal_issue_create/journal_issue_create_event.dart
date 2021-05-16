
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class JournalIssueCreateEvent extends Equatable{
  const JournalIssueCreateEvent();

  @override
  List<Object> get props => [];
}

class TitleChanged extends JournalIssueCreateEvent{
  final String title;

  const TitleChanged({@required this.title});

  @override
  String toString() => 'TitleChanged{title: $title}';
}

class SelectImage extends JournalIssueCreateEvent{
  final List<Asset> assetList;

  const SelectImage({@required this.assetList});

  @override
  String toString() => 'SelectImage {assetList: $assetList}';
}

class AddImageFile extends JournalIssueCreateEvent{
  final File imageFile;
  final int index;
  final int from; // gallery 0 / camera 1

  const AddImageFile({@required this.imageFile, int index, int from})
      : this.index = index ?? 0,
        this.from = from ?? 0;

  @override
  String toString() => 'AddImageFile {imageFile: ${imageFile.path}}';
}

class DeleteImageFile extends JournalIssueCreateEvent{
  final File removedFile;

  const DeleteImageFile({@required this.removedFile});

  @override
  String toString() => 'DeleteImageFile {removedFile: ${removedFile}}';
}

class PressComplete extends JournalIssueCreateEvent{}

class UploadJournal extends JournalIssueCreateEvent {
  final String fid;
  final String sfmid;
  final String uid;
  final String title;
  final int category; // 작물 1 / 시설 2 / 기타 3
  final int issueState; // 예상 1 / 진행 2 / 완료 3
  final String contents;
  final bool isReadByFM;
  final bool isReadByOffice;

  const UploadJournal({
    @required this.fid,
    @required this.sfmid,
    @required this.uid,
    @required this.title,
    @required this.category,
    @required this.issueState,
    @required this.contents,
    @required this.isReadByFM,
    @required this.isReadByOffice,
  });

  @override
  String toString() {
    return '''UploadJournal {
      fid: $fid, 
      sfmid: $sfmid,
      uid: $uid,
      title: $title,
      category: $category,
      issueState: $issueState,
      contents: $contents,
      isReadByFM: $isReadByFM,
      isReadByOffice: $isReadByOffice,
    }''';
  }
}

class DateSelected extends JournalIssueCreateEvent {
  final Timestamp selectedDate;

  const DateSelected({@required this.selectedDate});

  @override
  String toString() => 'DateSelected{ SelectedDate: $selectedDate}';
}

