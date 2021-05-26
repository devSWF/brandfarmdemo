
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:flutter/material.dart';

class FMHomeState {
  bool isLoading;
  int selectedIndex;
  int pageIndex;
  int subPageIndex;
  List<FMHomeRecentUpdates> recentUpdateList;
  Farm farm;
  List<Field> fieldList;
  Field field;

  List<NotificationNotice> notice;
  List<Plan> plan;
  List<Purchase> purchase;
  List<Journal> journal;
  List<SubJournalIssue> issue;
  List<Comment> comment; // for recent comment update
  List<SubComment> scomment; // for recent scomment update

  List<Comment> clist; // get comment list for issue/journal
  List<SubComment> sclist; // get scomment list for issue/journal
  List<ImagePicture> picture;

  Comment cmt; // write comment
  SubComment scmt; // write subcomment
  User user;

  FMHomeState({
    @required this.isLoading,
    @required this.selectedIndex,
    @required this.pageIndex,
    @required this.subPageIndex,
    @required this.recentUpdateList,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.notice,
    @required this.plan,
    @required this.purchase,
    @required this.journal,
    @required this.issue,
    @required this.comment,
    @required this.scomment,
    @required this.picture,
    @required this.clist,
    @required this.sclist,
    @required this.cmt,
    @required this.scmt,
    @required this.user,
  });

  factory FMHomeState.empty() {
    return FMHomeState(
      isLoading: false,
      selectedIndex: 0,
      pageIndex: 0,
      subPageIndex: 0,
      recentUpdateList: [],
      farm: null,
      fieldList: [],
      field: null,
      notice: [],
      plan: [],
      purchase: [],
      journal: [],
      issue: [],
      comment: [],
      scomment: [],
      picture: [],
      clist: [],
      sclist: [],
      cmt: null,
      scmt: null,
      user: null,
    );
  }

  FMHomeState copyWith({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<FMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
    List<Comment> comment,
    List<SubComment> scomment,
    List<ImagePicture> picture,
    List<Comment> clist,
    List<SubComment> sclist,
    Comment cmt,
    SubComment scmt,
    User user,
  }) {
    return FMHomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      recentUpdateList: recentUpdateList ?? this.recentUpdateList,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      notice: notice ?? this.notice,
      plan: plan ?? this.plan,
      purchase: purchase ?? this.purchase,
      journal: journal ?? this.journal,
      issue: issue ?? this.issue,
      comment: comment ?? this.comment,
      scomment: scomment ?? this.scomment,
      picture: picture ?? this.picture,
      clist: clist ?? this.clist,
      sclist: sclist ?? this.sclist,
      cmt: cmt ?? cmt,
      scmt: scmt ?? scmt,
      user: user ?? user,
    );
  }

  FMHomeState update({
    bool isLoading,
    int selectedIndex,
    int pageIndex,
    int subPageIndex,
    List<FMHomeRecentUpdates> recentUpdateList,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<NotificationNotice> notice,
    List<Plan> plan,
    List<Purchase> purchase,
    List<Journal> journal,
    List<SubJournalIssue> issue,
    List<Comment> comment,
    List<SubComment> scomment,
    List<ImagePicture> picture,
    List<Comment> clist,
    List<SubComment> sclist,
    Comment cmt,
    SubComment scmt,
    User user,
  }) {
    return copyWith(
      isLoading: isLoading,
      selectedIndex: selectedIndex,
      pageIndex: pageIndex,
      subPageIndex: subPageIndex,
      recentUpdateList: recentUpdateList,
      farm: farm,
      fieldList: fieldList,
      field: field,
      notice: notice,
      plan: plan,
      purchase: purchase,
      journal: journal,
      issue: issue,
      comment: comment,
      scomment: scomment,
      picture: picture,
      clist: clist,
      sclist: sclist,
      cmt: cmt,
      scmt: scmt,
      user: user,
    );
  }

  @override
  String toString() {
    return '''FMHomeState{
    isLoading: $isLoading,
    selectedIndex: $selectedIndex,
    pageIndex: $pageIndex,
    subPageIndex: $subPageIndex,
    recentUpdateList: ${recentUpdateList.length},
    farm: ${farm},
    fieldList: ${fieldList.length},
    field: ${field},
    notice: ${notice.length},
    plan: ${plan.length},
    purchase: ${purchase.length},
    journal: ${journal.length},
    issue: ${issue.length},
    comment: ${comment.length},
    scomment: ${scomment.length},
    picture: ${picture.length},
    clist: ${clist.length},
    sclist: ${sclist.length},
    cmt: ${cmt},
    scmt: ${scmt},
    user: ${user},
    }
    ''';
  }
}
