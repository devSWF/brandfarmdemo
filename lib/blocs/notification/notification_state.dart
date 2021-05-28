import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:flutter/material.dart';

class NotificationState {
  bool isLoading;
  Farm farm;
  List<NotificationNotice> allList;
  List<NotificationNotice> importantList;
  List<NotificationNotice> generalList;
  int unRead;

  Plan plan;
  Journal jObj;
  SubJournalIssue iObj;
  List<Comment> clist;
  List<SubComment> sclist;
  List<ImagePicture> piclist;
  List<User> commentUser;
  List<User> scommentUser;

  NotificationState({
    @required this.isLoading,
    @required this.farm,
    @required this.allList,
    @required this.importantList,
    @required this.generalList,
    @required this.unRead,
    @required this.plan,
    @required this.jObj,
    @required this.iObj,
    @required this.clist,
    @required this.sclist,
    @required this.piclist,
    @required this.commentUser,
    @required this.scommentUser,
  });

  factory NotificationState.empty() {
    return NotificationState(
      isLoading: false,
      farm: Farm(
        farmID: '',
        fieldCategory: '',
        managerID: '',
        officeNum: 1,
        name: '',
      ),
      allList: [],
      importantList: [],
      generalList: [],
      unRead: 0,
      plan: null,
      jObj: null,
      iObj: null,
      clist: [],
      sclist: [],
      piclist: [],
      commentUser: [],
      scommentUser: [],
    );
  }

  NotificationState copyWith({
    bool isLoading,
    Farm farm,
    List<NotificationNotice> allList,
    List<NotificationNotice> importantList,
    List<NotificationNotice> generalList,
    int unRead,
    Plan plan,
    Journal jObj,
    SubJournalIssue iObj,
    List<Comment> clist,
    List<SubComment> sclist,
    List<ImagePicture> piclist,
    List<User> commentUser,
    List<User> scommentUser,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      farm: farm ?? this.farm,
      allList: allList ?? this.allList,
      importantList: importantList ?? this.importantList,
      generalList: generalList ?? this.generalList,
      unRead: unRead ?? this.unRead,
      plan: plan ?? this.plan,
      jObj: jObj ?? this.jObj,
      iObj: iObj ?? this.iObj,
      clist: clist ?? this.clist,
      sclist: sclist ?? this.sclist,
      piclist: piclist ?? this.piclist,
      commentUser: commentUser ?? this.commentUser,
      scommentUser: scommentUser ?? this.scommentUser,
    );
  }

  NotificationState update({
    bool isLoading,
    Farm farm,
    List<NotificationNotice> allList,
    List<NotificationNotice> importantList,
    List<NotificationNotice> generalList,
    int unRead,
    Plan plan,
    Journal jObj,
    SubJournalIssue iObj,
    List<Comment> clist,
    List<SubComment> sclist,
    List<ImagePicture> piclist,
    List<User> commentUser,
    List<User> scommentUser,
  }) {
    return copyWith(
      isLoading: isLoading,
      farm: farm,
      allList: allList,
      importantList: importantList,
      generalList: generalList,
      unRead: unRead,
      plan: plan,
      jObj: jObj,
      iObj: iObj,
      clist: clist,
      sclist: sclist,
      piclist: piclist,
      commentUser: commentUser,
      scommentUser: scommentUser,
    );
  }

  @override
  String toString() {
    return '''NotificationState{
      isLoading: $isLoading,
      farm: $farm,
      allList: ${allList.length},
      importantList: ${importantList.length},
      generalList: ${generalList.length},
      unRead: ${unRead},
      plan: ${plan},
      jObj: ${jObj},
      iObj: ${iObj},
      clist: ${clist?.length},
      sclist: ${sclist?.length},
      piclist: ${piclist?.length},
      commentUser: ${commentUser?.length},
      scommentUser: ${scommentUser?.length},
    }
    ''';
  }
}
