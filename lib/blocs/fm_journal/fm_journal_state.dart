import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:flutter/foundation.dart';

class FMJournalState {
  bool isLoading;
  int navTo;
  int index;
  bool isIssue;
  bool shouldReload;
  String order;

  Farm farm;
  List<Field> fieldList;
  Field field;

  String year;
  String month;

  double fieldMenuButtonHeight;
  double fieldMenuButtonWidth;
  double fieldMenuButtonX;
  double fieldMenuButtonY;
  bool isFieldMenuButtonVisible;

  List<Journal> journalList;
  List<Journal> reverseList;
  List<ImagePicture> imageList;
  List<Comment> commentList;
  List<SubComment> subCommentList;
  User detailUser;

  Journal journal;

  FMJournalState({
    @required this.isLoading,
    @required this.navTo,
    @required this.index,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.year,
    @required this.month,
    @required this.isIssue,
    @required this.shouldReload,
    @required this.order,
    @required this.fieldMenuButtonHeight,
    @required this.fieldMenuButtonWidth,
    @required this.fieldMenuButtonX,
    @required this.fieldMenuButtonY,
    @required this.isFieldMenuButtonVisible,
    @required this.journalList,
    @required this.reverseList,
    @required this.imageList,
    @required this.commentList,
    @required this.subCommentList,
    @required this.detailUser,
    @required this.journal,
  });

  factory FMJournalState.empty() {
    return FMJournalState(
      isLoading: false,
      navTo: 1,
      index: 0,
      isIssue: false,
      farm: Farm(farmID: '', fieldCategory: '', managerID: ''),
      fieldList: [],
      field: Field(
          fieldCategory: '',
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: ''),
      year: DateTime.now().year.toString(),
      month: DateTime.now().month.toString(),
      shouldReload: true,
      order: '최신 순',
      fieldMenuButtonHeight: 0.0,
      fieldMenuButtonWidth: 0.0,
      fieldMenuButtonX: 0.0,
      fieldMenuButtonY: 0.0,
      isFieldMenuButtonVisible: false,
      journalList: [],
      reverseList: [],
      imageList: [],
      commentList: [],
      subCommentList: [],
      detailUser: User(
        email: '',
        fcmToken: '',
        imgUrl: '',
        id: '',
        name: '',
        psw: '',
        phone: '',
        position: 0,
        uid: '',
      ),
      journal: null,
    );
  }

  FMJournalState copyWith({
    bool isLoading,
    int navTo,
    int index,
    bool isIssue,
    Farm farm,
    List<Field> fieldList,
    Field field,
    String year,
    String month,
    bool shouldReload,
    String order,
    double fieldMenuButtonHeight,
    double fieldMenuButtonWidth,
    double fieldMenuButtonX,
    double fieldMenuButtonY,
    bool isFieldMenuButtonVisible,
    List<Journal> journalList,
    List<Journal> reverseList,
    List<ImagePicture> imageList,
    List<Comment> commentList,
    List<SubComment> subCommentList,
    User detailUser,
    Journal journal,
  }) {
    return FMJournalState(
      isLoading: isLoading ?? this.isLoading,
      navTo: navTo ?? this.navTo,
      index: index ?? this.index,
      isIssue: isIssue ?? this.isIssue,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      year: year ?? this.year,
      month: month ?? this.month,
      shouldReload: shouldReload ?? this.shouldReload,
      order: order ?? this.order,
      fieldMenuButtonHeight: fieldMenuButtonHeight ?? this.fieldMenuButtonHeight,
      fieldMenuButtonWidth: fieldMenuButtonWidth ?? this.fieldMenuButtonWidth,
      fieldMenuButtonX: fieldMenuButtonX ?? this.fieldMenuButtonX,
      fieldMenuButtonY: fieldMenuButtonY ?? this.fieldMenuButtonY,
      isFieldMenuButtonVisible: isFieldMenuButtonVisible ?? this.isFieldMenuButtonVisible,
      journalList: journalList ?? this.journalList,
      reverseList: reverseList ?? this.reverseList,
      imageList: imageList ?? this.imageList,
      commentList: commentList ?? this.commentList,
      subCommentList: subCommentList ?? this.subCommentList,
      detailUser: detailUser ?? this.detailUser,
      journal: journal ?? this.journal,
    );
  }

  FMJournalState update({
    bool isLoading,
    int navTo,
    int index,
    bool isIssue,
    Farm farm,
    List<Field> fieldList,
    Field field,
    String year,
    String month,
    bool shouldReload,
    String order,
    double fieldMenuButtonHeight,
    double fieldMenuButtonWidth,
    double fieldMenuButtonX,
    double fieldMenuButtonY,
    bool isFieldMenuButtonVisible,
    List<Journal> journalList,
    List<Journal> reverseList,
    List<ImagePicture> imageList,
    List<Comment> commentList,
    List<SubComment> subCommentList,
    User detailUser,
    Journal journal,
  }) {
    return copyWith(
      isLoading: isLoading,
      navTo: navTo,
      index: index,
      isIssue: isIssue,
      farm: farm,
      fieldList: fieldList,
      field: field,
      year: year,
      month: month,
      shouldReload: shouldReload,
      order: order,
      fieldMenuButtonHeight: fieldMenuButtonHeight,
      fieldMenuButtonWidth: fieldMenuButtonWidth,
      fieldMenuButtonX: fieldMenuButtonX,
      fieldMenuButtonY: fieldMenuButtonY,
      isFieldMenuButtonVisible: isFieldMenuButtonVisible,
      journalList: journalList,
      reverseList: reverseList,
      imageList: imageList,
      commentList: commentList,
      subCommentList: subCommentList,
      detailUser: detailUser,
      journal: journal,
    );
  }

  @override
  String toString() {
    return '''FMJournalState{
    isLoading: $isLoading,
    navTo: $navTo,
    index: $index,
    isIssue: $isIssue,
    farm: $farm,
    fieldList: ${fieldList.length},
    field: $field,
    year: $year,
    month: $month,
    shouldReload: $shouldReload,
    order: $order,
    fieldMenuButtonHeight: $fieldMenuButtonHeight,
    fieldMenuButtonWidth: $fieldMenuButtonWidth,
    fieldMenuButtonX: $fieldMenuButtonX,
    fieldMenuButtonY: $fieldMenuButtonY,
    isFieldMenuButtonVisible: $isFieldMenuButtonVisible,
    journalList: ${journalList.length},
    reverseList: ${reverseList.length},
    imageList: ${imageList.length},
    commentList: ${commentList.length},
    subCommentList: ${subCommentList.length},
    detailUser: ${detailUser},
    journal: ${journal},
    }
    ''';
  }
}
