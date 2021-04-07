
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class JournalState {
  bool isLoading;
  bool isLoadingToGetMore;

  List<Journal> orderByOldest;
  List<Journal> orderByRecent;
  List<Journal> listBySelection;

  List<SubJournalIssue> issueList;
  List<SubJournalIssue> issueListByCategorySelection;
  List<SubJournalIssue> reverseIssueList;
  List<ImagePicture> imageList;

  Journal selectedJournal;
  SubJournalIssue selectedIssue;

  JournalState({
    @required this.isLoading,
    @required this.isLoadingToGetMore,
    @required this.orderByOldest,
    @required this.orderByRecent,
    @required this.listBySelection,
    @required this.issueList,
    @required this.issueListByCategorySelection,
    @required this.reverseIssueList,
    @required this.imageList,
    @required this.selectedJournal,
    @required this.selectedIssue,
  });

  factory JournalState.empty() {
    return JournalState(
      isLoading: false,
      isLoadingToGetMore: false,
      orderByOldest: [],
      orderByRecent: [],
      listBySelection: [],
      issueList: [],
      issueListByCategorySelection: [],
      reverseIssueList: [],
      imageList: [],
      selectedJournal: Journal.empty(),
      selectedIssue: SubJournalIssue.empty(),
    );
  }

  JournalState copyWith({
    bool isLoading,
    bool isLoadingToGetMore,
    List<Journal> orderByOldest,
    List<Journal> orderByRecent,
    List<Journal> listBySelection,
    List<SubJournalIssue> issueList,
    List<SubJournalIssue> issueListByCategorySelection,
    List<SubJournalIssue> reverseIssueList,
    List<ImagePicture> imageList,
    Journal selectedJournal,
    SubJournalIssue selectedIssue,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingToGetMore: isLoadingToGetMore ?? this.isLoadingToGetMore,
      orderByOldest: orderByOldest ?? this.orderByOldest,
      orderByRecent: orderByRecent ?? this.orderByRecent,
      listBySelection: listBySelection ?? this.listBySelection,
      issueList: issueList ?? this.issueList,
      issueListByCategorySelection: issueListByCategorySelection ?? this.issueListByCategorySelection,
      reverseIssueList: reverseIssueList ?? this.reverseIssueList,
      imageList: imageList ?? this.imageList,
      selectedJournal: selectedJournal ?? this.selectedJournal,
      selectedIssue: selectedIssue ?? this.selectedIssue,
    );
  }

  JournalState update({
    bool isLoading,
    bool isLoadingToGetMore,
    List<Journal> orderByOldest,
    List<Journal> orderByRecent,
    List<Journal> listBySelection,
    List<SubJournalIssue> issueList,
    List<SubJournalIssue> issueListByCategorySelection,
    List<SubJournalIssue> reverseIssueList,
    List<ImagePicture> imageList,
    Journal selectedJournal,
    SubJournalIssue selectedIssue,
  }) {
    return copyWith(
      isLoading: isLoading,
      isLoadingToGetMore: isLoadingToGetMore,
      orderByOldest: orderByOldest,
      orderByRecent: orderByRecent,
      listBySelection: listBySelection,
      issueList: issueList,
      issueListByCategorySelection: issueListByCategorySelection,
      reverseIssueList: reverseIssueList,
      imageList: imageList,
      selectedIssue: selectedIssue,
      selectedJournal: selectedJournal,
    );
  }

  @override
  String toString() {
    return '''JournalState{
    isLoading: $isLoading,
    isLoadingToGetMore: $isLoadingToGetMore,
    orderByOldest: ${orderByOldest.length},
    orderByRecent: ${orderByRecent.length},
    listBySelection: ${listBySelection.length},
    issueList: ${issueList.length},
    issueListByCategorySelection: ${issueListByCategorySelection.length},
    reverseIssueList: ${reverseIssueList.length},
    imageList: ${imageList.length},
    selectedIssue: ${selectedIssue},
    selectedJournal: ${selectedJournal},
    }
    ''';
  }
}
