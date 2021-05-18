import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/fm_home/fm_home_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    List<FMPlan> plan = [];
    List<FMPurchase> purchase = [];
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
}
