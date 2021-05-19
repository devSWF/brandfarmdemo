import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
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
import 'package:BrandFarm/repository/fm_home/fm_home_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class FMHomeBloc extends Bloc<FMHomeEvent, FMHomeState> {
  FMHomeBloc() : super(FMHomeState.empty());

  @override
  Stream<FMHomeState> mapEventToState(FMHomeEvent event) async* {
    if (event is LoadFMHome) {
      yield* _mapLoadFMHomeToState();
    } else if (event is SetPageIndex) {
      yield* _mapSetPageIndexToState(event.index);
    } else if (event is SetSubPageIndex) {
      yield* _mapSetSubPageIndexToState(event.index);
    } else if (event is SetSelectedIndex) {
      yield* _mapSetSelectedIndexToState(event.index);
    } else if (event is GetFieldListForFMHome) {
      yield* _mapGetFieldListForFMHomeToState();
    } else if (event is GetRecentUpdates) {
      yield* _mapGetRecentUpdatesToState();
    } else if (event is SetFcmToken) {
      yield* _mapSetFcmTokenToState();
    } else if (event is CheckAsRead) {
      yield* _mapCheckAsReadToState(event.index);
    } else if (event is SetField) {
      yield* _mapSetFieldToState(event.index);
    } else if (event is GetPicture) {
      yield* _mapGetPictureToState(event.index);
    } else if (event is GetComment) {
      yield* _mapGetCommentToState(event.index);
    } else if (event is GetSComment) {
      yield* _mapGetSCommentToState(event.index);
    } else if (event is GetUser) {
      yield* _mapGetUserToState(event.index);
    } else if (event is ChangeExpandState) {
      yield* _mapChangeExpandStateToState(event.index);
    } else if (event is WriteComment) {
      yield* _mapWriteCommentToState(event.cmt, event.rpIndex);
    } else if (event is ChangeWriteReplyState) {
      yield* _mapChangeWriteReplyStateToState(event.index);
    } else if (event is WriteReply) {
      yield* _mapWriteReplyToState(event.scmt, event.rpIndex, event.index);
    } else if (event is SendCommentNotice) {
      yield* _mapSendCommentNoticeToState(event.index);
    } else if (event is SendSCommentNotice) {
      yield* _mapSendSCommentNoticeToState(event.index);
    }
  }

  Stream<FMHomeState> _mapLoadFMHomeToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMHomeState> _mapSetPageIndexToState(int index) async* {
    yield state.update(pageIndex: index);
  }

  Stream<FMHomeState> _mapSetSubPageIndexToState(int index) async* {
    yield state.update(subPageIndex: index);
  }

  Stream<FMHomeState> _mapSetSelectedIndexToState(int index) async* {
    yield state.update(selectedIndex: index);
  }

  Stream<FMHomeState> _mapGetFieldListForFMHomeToState() async* {
    Farm farm = await FMHomeRepository().getFarmInfo();
    List<Field> fieldList =
        await FMHomeRepository().getFieldList(farm.fieldCategory);

    yield state.update(
      farm: farm,
      fieldList: fieldList,
    );
  }

  Stream<FMHomeState> _mapGetRecentUpdatesToState() async* {
    List<FMHomeRecentUpdates> updateList = [];
    List<FMHomeRecentUpdates> noticeList = [];
    List<FMHomeRecentUpdates> planList = [];
    List<FMHomeRecentUpdates> purchaseList = [];
    List<FMHomeRecentUpdates> journalList = [];
    List<FMHomeRecentUpdates> issueList = [];
    // List<FMHomeRecentUpdates> commentList = [];
    // List<FMHomeRecentUpdates> subCommentList = [];

    List<NotificationNotice> notice = [];
    List<Plan> plan = [];
    List<Purchase> purchase = [];
    List<Journal> journal = [];
    List<SubJournalIssue> issue = [];
    // List<Comment> comment = [];
    // List<SubComment> subComment = [];

    notice = await FMHomeRepository().getRecentNoticeList(state.farm.farmID);
    plan = await FMHomeRepository().getRecentPlanList(state.farm.farmID);
    purchase = await FMHomeRepository().getRecentPurchaseList(state.farm.farmID);
    journal = await FMHomeRepository().getRecentJournalList(state.farm.fieldCategory);
    issue = await FMHomeRepository().getRecentIssueList(state.farm.fieldCategory);
    // comment = await FMHomeRepository().getRecentCommentList(state.farm.fieldCategory);
    // subComment = await FMHomeRepository().getRecentSubCommentList(state.farm.fieldCategory);

    // print('notice ${notice.length}');
    // print('plan ${plan.length}');
    // print('purchase ${purchase.length}');
    // print('journal ${journal.length}');
    // print('issue ${issue.length}');

    for(int i=0; i< notice.length; i++) {
      User user = await FMHomeRepository().getDetailUserInfo(notice[i].uid);
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          user: user,
          date: notice[i].postedDate,
          plan: null,
          notice: notice[i],
          purchase: null,
          journal: null,
          issue: null,
          comment: null,
          subComment: null);
      if (i > 0) {
        noticeList.insert(0, obj);
      } else {
        noticeList.add(obj);
      }
    }

    for(int i=0; i< plan.length; i++) {
      User user = await FMHomeRepository().getDetailUserInfo(plan[i].uid);
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          user: user,
          date: plan[i].postedDate,
          plan: plan[i],
          notice: null,
          purchase: null,
          journal: null,
          issue: null,
          comment: null,
          subComment: null);
      if (i > 0) {
        planList.insert(0, obj);
      } else {
        planList.add(obj);
      }
    }

    for(int i=0; i< purchase.length; i++) {
      User user = await FMHomeRepository().getDetailUserInfo(purchase[i].reqUser.uid);
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          user: user,
          date: purchase[i].requestDate,
          plan: null,
          notice: null,
          purchase: purchase[i],
          journal: null,
          issue: null,
          comment: null,
          subComment: null);
      if (i > 0) {
        purchaseList.insert(0, obj);
      } else {
        purchaseList.add(obj);
      }
    }

    for(int i=0; i< journal.length; i++) {
      User user = await FMHomeRepository().getDetailUserInfo(journal[i].uid);
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          user: user,
          date: journal[i].date,
          plan: null,
          notice: null,
          purchase: null,
          journal: journal[i],
          issue: null,
          comment: null,
          subComment: null);
      if (i > 0) {
        journalList.insert(0, obj);
      } else {
        journalList.add(obj);
      }
    }

    for(int i=0; i< issue.length; i++) {
      User user = await FMHomeRepository().getDetailUserInfo(issue[i].uid);
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          user: user,
          date: issue[i].date,
          plan: null,
          notice: null,
          purchase: null,
          journal: null,
          issue: issue[i],
          comment: null,
          subComment: null);
      if (i > 0) {
        issueList.insert(0, obj);
      } else {
        issueList.add(obj);
      }
    }

    // notice.asMap().forEach((index, element) async {
    //   User user = await FMHomeRepository().getDetailUserInfo(element.uid);
    //   FMHomeRecentUpdates obj = FMHomeRecentUpdates(
    //       user: user,
    //       date: element.postedDate,
    //       plan: null,
    //       notice: element,
    //       purchase: null,
    //       journal: null,
    //       issue: null,
    //       comment: null,
    //       subComment: null);
    //   if (index > 0) {
    //     noticeList.insert(0, obj);
    //   } else {
    //     noticeList.add(obj);
    //   }
    // });

    // print('noticeList ${noticeList.length}');
    // print('planList ${planList.length}');
    // print('purchaseList ${purchaseList.length}');
    // print('journalList ${journalList.length}');
    // print('issueList ${issueList.length}');

    updateList = [
      ...noticeList,
      ...planList,
      ...purchaseList,
      ...journalList,
      ...issueList
    ];
    updateList.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    updateList = List.from(updateList.reversed);

    // updateList.forEach((element) {
    //   print('${element.date.toDate()}');
    // });

    yield state.update(
      recentUpdateList: updateList,
      isLoading: false,
      notice: notice,
      plan: plan,
      purchase: purchase,
      journal: journal,
      issue: issue,
    );
  }

  Stream<FMHomeState> _mapSetFcmTokenToState() async* {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    String fcmToken = await _fcm.getToken();
    await FMHomeRepository().updateFcmToken(await UserUtil.getUser().uid, fcmToken);
    yield state.update();
  }

  Stream<FMHomeState> _mapCheckAsReadToState(int index) async* {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    if (obj.notice != null) {
      NotificationNotice notice = NotificationNotice(
          no: obj.notice.no,
          uid: obj.notice.uid,
          name: obj.notice.name,
          imgUrl: obj.notice.imgUrl,
          fid: obj.notice.fid,
          farmid: obj.notice.farmid,
          title: obj.notice.title,
          content: obj.notice.content,
          postedDate: obj.notice.postedDate,
          scheduledDate: obj.notice.scheduledDate,
          isReadByFM: !obj.notice.isReadByFM,
          isReadByOffice: obj.notice.isReadByOffice,
          isReadBySFM: obj.notice.isReadBySFM,
          notid: obj.notice.notid,
          type: obj.notice.type,
          department: obj.notice.department,
          jid: obj.notice.jid,
          issid: obj.notice.issid,
          planid: obj.notice.planid
      );

      FMHomeRepository().updateNotice(notice);

      List<NotificationNotice> list = state.notice;
      int tmp = list.indexWhere((element) => notice.notid == element.notid) ?? -1;
      list.removeAt(tmp);
      list.insert(tmp, notice);

      FMHomeRecentUpdates newObj = FMHomeRecentUpdates(
          date: obj.date,
          user: obj.user,
          plan: obj.plan,
          notice: notice,
          purchase: obj.purchase,
          journal: obj.journal,
          issue: obj.issue,
          comment: obj.comment,
          subComment: obj.subComment
      );

      List<FMHomeRecentUpdates> rplist = state.recentUpdateList;
      rplist.removeAt(index);
      rplist.insert(index, newObj);
      yield state.update(
        recentUpdateList: rplist,
        notice: list,
      );
    } else if (obj.plan != null) {
      // TODO
    } else if (obj.purchase != null) {
      // TODO
    } else if (obj.journal != null) {
      // TODO
    } else if (obj.issue != null) {
      SubJournalIssue issue = SubJournalIssue(
          date: obj.issue.date,
          fid: obj.issue.fid,
          fieldCategory: obj.issue.fieldCategory,
          sfmid:obj.issue. sfmid,
          issid: obj.issue.issid,
          uid: obj.issue.uid,
          title: obj.issue.title,
          category: obj.issue.category,
          issueState: obj.issue.issueState,
          contents: obj.issue.contents,
          comments: obj.issue.comments,
          isReadByFM: !obj.issue.isReadByFM,
          isReadByOffice: obj.issue.isReadByOffice,
      );

      FMHomeRepository().updateIssue(issue);

      List<SubJournalIssue> list = state.issue;
      int tmp = list.indexWhere((element) => issue.issid == element.issid) ?? -1;
      list.removeAt(tmp);
      list.insert(tmp, issue);

      FMHomeRecentUpdates newObj = FMHomeRecentUpdates(
          date: obj.date,
          user: obj.user,
          plan: obj.plan,
          notice: obj.notice,
          purchase: obj.purchase,
          journal: obj.journal,
          issue: issue,
          comment: obj.comment,
          subComment: obj.subComment
      );

      List<FMHomeRecentUpdates> rplist = state.recentUpdateList;
      rplist.removeAt(index);
      rplist.insert(index, newObj);

      yield state.update(
        recentUpdateList: rplist,
        issue: list,
      );
    } else if (obj.comment != null) {
      // TODO
    } else {
      // TODO
    }
  }

  Stream<FMHomeState> _mapSetFieldToState(int index) async* {
    Field field;
    int fIndex = state.fieldList.indexWhere((element) => element.fid == state.recentUpdateList[index].issue.fid) ?? -1;
    if (fIndex != -1) {
      field = state.fieldList[fIndex];
    }

    yield state.update(
      field: field,
    );
  }

  Stream<FMHomeState> _mapGetPictureToState(int index) async* {
    List<ImagePicture> plist = [];
    if (state.recentUpdateList[index].issue != null) {
      String issid = state.recentUpdateList[index].issue.issid;
      plist = await FMHomeRepository().getIssueImage(issid);
      yield state.update(picture: plist);
    } else if (state.recentUpdateList[index].journal != null) {
      String jid = state.recentUpdateList[index].journal.jid;
      plist = await FMHomeRepository().getJournalImage(jid);
      yield state.update(picture: plist);
    } else {
      yield state.update();
    }
  }

  Stream<FMHomeState> _mapGetCommentToState(int index) async* {
    List<Comment> clist = [];
    if (state.recentUpdateList[index].issue != null) {
      String issid = state.recentUpdateList[index].issue.issid;
      clist = await FMHomeRepository().getIssueComment(issid);
      yield state.update(clist: clist);
    } else if (state.recentUpdateList[index].journal != null) {
      String jid = state.recentUpdateList[index].journal.jid;
      clist = await FMHomeRepository().getJournalComment(jid);
      yield state.update(clist: clist);
    } else {
      yield state.update();
    }
  }

  Stream<FMHomeState> _mapGetSCommentToState(int index) async* {
    List<SubComment> sclist = [];
    if (state.recentUpdateList[index].issue != null) {
      String issid = state.recentUpdateList[index].issue.issid;
      sclist = await FMHomeRepository().getIssueSComment(issid);
      yield state.update(sclist: sclist);
    } else if (state.recentUpdateList[index].journal != null) {
      String jid = state.recentUpdateList[index].journal.jid;
      sclist = await FMHomeRepository().getJournalSComment(jid);
      yield state.update(sclist: sclist);
    } else {
      yield state.update();
    }
  }

  Stream<FMHomeState> _mapGetUserToState(int index) async* {
    User user;
    if (state.recentUpdateList[index].issue != null) {
      String uid = state.recentUpdateList[index].issue.uid;
      user = await FMHomeRepository().getDetailUserInfo(uid);
      yield state.update(user: user);
    } else if (state.recentUpdateList[index].journal != null) {
      String uid = state.recentUpdateList[index].journal.uid;
      user = await FMHomeRepository().getDetailUserInfo(uid);
      yield state.update(user: user);
    } else {
      yield state.update();
    }
  }

  Stream<FMHomeState> _mapChangeExpandStateToState(int index) async* {
    List<Comment> clist = state.clist;
    Comment obj = clist[index];
    Comment newObj = Comment(
        date: obj.date,
        name: obj.name,
        uid: obj.uid,
        issid: obj.issid,
        jid: obj.jid,
        cmtid: obj.cmtid,
        comment: obj.comment,
        isThereSubComment: obj.isThereSubComment,
        isExpanded: !obj.isExpanded,
        fid: obj.fid,
        imgUrl: obj.imgUrl,
        isWriteSubCommentClicked: obj.isWriteSubCommentClicked,
        isReadByFM: obj.isReadByFM,
        isReadByOM: obj.isReadByOM,
        isReadBySFM: obj.isReadBySFM
    );
    clist.removeAt(index);
    clist.insert(index, newObj);
    yield state.update(
      clist: clist,
    );
  }

  Stream<FMHomeState> _mapWriteCommentToState(String cmt, int rpIndex) async* {
    SubJournalIssue issue = state.recentUpdateList[rpIndex].issue;
    Journal journal = state.recentUpdateList[rpIndex].journal;
    List<Comment> clist = state.clist;
    String id;
    String fid;
    List<FMHomeRecentUpdates> rplist = state.recentUpdateList;
    FMHomeRecentUpdates rpObj;
    SubJournalIssue _issue;
    Journal _journal;

    if (issue != null) {
      id = issue.issid;
      fid = issue.fid;
    } else {
      id = journal.jid;
      fid = journal.fid;
    }

    String cmtid = '';
    cmtid = FirebaseFirestore.instance.collection('Comment').doc().id;
    Comment _cmt = Comment(
      date: Timestamp.now(),
      jid: '--',
      uid: UserUtil.getUser().uid,
      issid: id,
      cmtid: cmtid,
      name: UserUtil.getUser().name,
      comment: cmt,
      isThereSubComment: false,
      isExpanded: false,
      fid: fid,
      imgUrl: '',
      isWriteSubCommentClicked: false,
      isReadByFM: true,
      isReadByOM: false,
      isReadBySFM: false,
    );

    clist.add(_cmt);


    if (issue != null) {
      _issue = SubJournalIssue(
        date: issue.date,
        fid: issue.fid,
        fieldCategory: issue.fieldCategory,
        sfmid: issue.sfmid,
        issid: issue.issid,
        uid: issue.uid,
        title: issue.title,
        category: issue.category,
        issueState: issue.issueState,
        contents: issue.contents,
        comments: issue.comments + 1,
        isReadByFM: issue.isReadByFM,
        isReadByOffice: issue.isReadByOffice,
      );

      rpObj = FMHomeRecentUpdates(
          date: state.recentUpdateList[rpIndex].date,
          user: state.recentUpdateList[rpIndex].user,
          plan: state.recentUpdateList[rpIndex].plan,
          notice: state.recentUpdateList[rpIndex].notice,
          purchase: state.recentUpdateList[rpIndex].purchase,
          journal: state.recentUpdateList[rpIndex].journal,
          issue: _issue,
          comment: state.recentUpdateList[rpIndex].comment,
          subComment: state.recentUpdateList[rpIndex].subComment
      );
    } else {
      // TODO
      _journal = Journal(
          fid: journal.fid,
          fieldCategory: journal.fieldCategory,
          jid: journal.jid,
          uid: journal.uid,
          date: journal.date,
          title: journal.title,
          content: journal.content,
          widgets: journal.widgets,
          widgetList: journal.widgetList,
          comments: journal.comments + 1,
          isReadByFM: journal.isReadByFM,
          isReadByOffice: journal.isReadByOffice,
          shipment: journal.shipment,
          fertilize: journal.fertilize,
          pesticide: journal.pesticide,
          pest: journal.pest,
          planting: journal.planting,
          seeding: journal.seeding,
          weeding: journal.weeding,
          watering: journal.watering,
          workforce: journal.workforce,
          farming: journal.farming
      );

      rpObj = FMHomeRecentUpdates(
          date: state.recentUpdateList[rpIndex].date,
          user: state.recentUpdateList[rpIndex].user,
          plan: state.recentUpdateList[rpIndex].plan,
          notice: state.recentUpdateList[rpIndex].notice,
          purchase: state.recentUpdateList[rpIndex].purchase,
          journal: _journal,
          issue: state.recentUpdateList[rpIndex].issue,
          comment: state.recentUpdateList[rpIndex].comment,
          subComment: state.recentUpdateList[rpIndex].subComment
      );
    }

    FMHomeRepository().addComment(cmt: _cmt);

    if (issue != null) {
      FMHomeRepository().updateIssue(_issue);
    } else {
      FMHomeRepository().updateJournal(_journal);
    }

    if (rpObj != null){
      rplist.removeAt(rpIndex);
      rplist.insert(rpIndex, rpObj);
    }

    yield state.update(
      clist: clist,
      recentUpdateList: rplist,
      cmt: _cmt,
    );
  }

  Stream<FMHomeState> _mapChangeWriteReplyStateToState(int index) async* {
    Comment obj = state.clist[index];
    List<Comment> cmt = state.clist;
    Comment _cmt = Comment(
      date: obj.date,
      name: obj.name,
      uid: obj.uid,
      issid: obj.issid,
      jid: obj.jid,
      cmtid: obj.cmtid,
      comment: obj.comment,
      isThereSubComment: obj.isThereSubComment,
      isExpanded: obj.isExpanded,
      fid: obj.fid,
      imgUrl: obj.imgUrl,
      isWriteSubCommentClicked: !obj.isWriteSubCommentClicked,
      isReadByFM: obj.isReadByFM,
      isReadByOM: obj.isReadByOM,
      isReadBySFM: obj.isReadBySFM,
    );

    cmt.removeAt(index);
    cmt.insert(index, _cmt);

    yield state.update(clist: cmt);
  }

  Stream<FMHomeState> _mapWriteReplyToState(String scmt, int rpIndex, int index) async* {
    SubJournalIssue issue = state.recentUpdateList[rpIndex].issue;
    Journal journal = state.recentUpdateList[rpIndex].journal;
    SubComment _scmt;
    Comment cmtObj = state.clist[index];
    List<Comment> cmtList = state.clist;
    Comment _cmt = Comment(
      date: cmtObj.date,
      name: cmtObj.name,
      uid: cmtObj.uid,
      issid: cmtObj.issid,
      jid: cmtObj.jid,
      cmtid: cmtObj.cmtid,
      comment: cmtObj.comment,
      isThereSubComment: cmtObj.isThereSubComment,
      isExpanded: cmtObj.isExpanded,
      fid: cmtObj.fid,
      imgUrl: cmtObj.imgUrl,
      isWriteSubCommentClicked: !cmtObj.isWriteSubCommentClicked,
      isReadByFM: cmtObj.isReadByFM,
      isReadByOM: cmtObj.isReadByOM,
      isReadBySFM: cmtObj.isReadBySFM,
    );

    cmtList.removeAt(index);
    cmtList.insert(index, _cmt);

    // write reply
    List<SubComment> scmtList = state.sclist;
    String scmtid = '';
    scmtid = FirebaseFirestore.instance.collection('SubComment').doc().id;

    if (issue != null) {
      _scmt = SubComment(
        date: Timestamp.now(),
        name: UserUtil.getUser().name,
        uid: UserUtil.getUser().uid,
        issid: issue.issid,
        jid: '--',
        scmtid: scmtid,
        cmtid: cmtObj.cmtid,
        scomment: scmt,
        imgUrl: UserUtil.getUser().imgUrl,
        fid: issue.fid,
        isReadByFM: true,
        isReadByOM: false,
        isReadBySFM: false,
      );
    } else {
      _scmt = SubComment(
        date: Timestamp.now(),
        name: UserUtil.getUser().name,
        uid: UserUtil.getUser().uid,
        issid: '--',
        jid: journal.jid,
        scmtid: scmtid,
        cmtid: cmtObj.cmtid,
        scomment: scmt,
        imgUrl: UserUtil.getUser().imgUrl,
        fid: journal.fid,
        isReadByFM: true,
        isReadByOM: false,
        isReadBySFM: false,
      );
    }


    if (_scmt != null){
      scmtList.add(_scmt);
      FMHomeRepository().addSComment(scmt: _scmt);
    }

    yield state.update(
      clist: cmtList,
      sclist: scmtList,
      scmt: _scmt,
    );
  }

  Stream<FMHomeState> _mapSendCommentNoticeToState(int index) async* {
    DateTime date = state.cmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notice.length; j++) {
        if(state.notice[j].no.contains(tmpNo)) {
          exist = true;
          break;
        }
      }
      if(!exist) {
        no = tmpNo;
        break;
      }
    }

    String _notid = '';
    _notid = FirebaseFirestore.instance.collection('Notification').doc().id;
    NotificationNotice _notice = NotificationNotice(
      no: no,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      imgUrl: '',
      fid: state.cmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: state.cmt.comment,
      postedDate: state.cmt.date,
      scheduledDate: state.cmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: state.cmt.jid,
      issid: state.cmt.issid,
      planid: '',
    );

    FMHomeRepository().postNotification(notice: _notice);
    List<NotificationNotice> nlist = state.notice;
    nlist.add(_notice);
    yield state.update(
      notice: nlist,
    );
  }

  Stream<FMHomeState> _mapSendSCommentNoticeToState(int index) async* {
    DateTime date = state.scmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notice.length; j++) {
        if(state.notice[j].no.contains(tmpNo)) {
          exist = true;
          break;
        }
      }
      if(!exist) {
        no = tmpNo;
        break;
      }
    }

    String _notid = '';
    _notid = FirebaseFirestore.instance.collection('Notification').doc().id;
    NotificationNotice _notice = NotificationNotice(
      no: no,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      imgUrl: '',
      fid: state.scmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: state.scmt.scomment,
      postedDate: state.scmt.date,
      scheduledDate: state.scmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: state.scmt.jid,
      issid: state.scmt.issid,
      planid: '',
    );

    List<NotificationNotice> nlist = state.notice;
    nlist.add(_notice);
    FMHomeRepository().postNotification(notice: _notice);
    yield state.update(
      notice: nlist,
    );
  }
}
