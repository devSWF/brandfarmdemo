import 'package:BrandFarm/blocs/om_home/om_home_event.dart';
import 'package:BrandFarm/blocs/om_home/om_home_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_home/om_home_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/om_home/om_home_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OMHomeBloc extends Bloc<OMHomeEvent, OMHomeState> {
  OMHomeBloc() : super(OMHomeState.empty());

  @override
  Stream<OMHomeState> mapEventToState(OMHomeEvent event) async* {
    if (event is LoadOMHome) {
      yield* _mapLoadOMHomeToState();
    } else if (event is SetPageIndex) {
      yield* _mapSetPageIndexToState(event.index);
    } else if (event is SetSubPageIndex) {
      yield* _mapSetSubPageIndexToState(event.index);
    } else if (event is SetSelectedIndex) {
      yield* _mapSetSelectedIndexToState(event.index);
    } else if (event is GetFarmListForOMHome) {
      yield* _mapGetFarmListForOMHomeToState();
    } else if (event is GetRecentUpdates) {
      yield* _mapGetRecentUpdatesToState();
    } else if (event is SetFcmToken) {
      yield* _mapSetFcmTokenToState();
    } else if (event is CheckAsRead) {
      yield* _mapCheckAsReadToState(event.index);
    } else if (event is ChangeCurrFarmIndex) {
      yield* _mapChangeCurrFarmIndexToState(event.index);
    }
  }

  Stream<OMHomeState> _mapLoadOMHomeToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<OMHomeState> _mapSetPageIndexToState(int index) async* {
    yield state.update(pageIndex: index);
  }

  Stream<OMHomeState> _mapSetSubPageIndexToState(int index) async* {
    yield state.update(subPageIndex: index);
  }

  Stream<OMHomeState> _mapSetSelectedIndexToState(int index) async* {
    yield state.update(selectedIndex: index);
  }

  Stream<OMHomeState> _mapGetFarmListForOMHomeToState() async* {
    List<Farm> flist = await OMHomeRepository().getFarmList();

    yield state.update(
      farm: flist[0],
      farmList: flist,
    );
  }

  Stream<OMHomeState> _mapGetRecentUpdatesToState() async* {
    List<OMHomeRecentUpdates> updateList = [];
    List<OMHomeRecentUpdates> noticeList = [];
    List<OMHomeRecentUpdates> planList = [];
    List<OMHomeRecentUpdates> purchaseList = [];

    List<OMNotificationNotice> notice = [];
    List<OMPlan> plan = [];
    List<Purchase> purchase = [];

    notice = await OMHomeRepository().getRecentNoticeList();
    print('got notice');
    plan = await OMHomeRepository().getRecentPlanList();
    print('got plan');
    purchase =
        await OMHomeRepository().getRecentPurchaseList(state.farm.farmID);
    print('got purchase');

    // print('notice ${notice.length}');
    // print('plan ${plan.length}');
    // print('purchase ${purchase.length}');

    for (int i = 0; i < notice.length; i++) {
      User user = await OMHomeRepository().getDetailUserInfo(notice[i].uid);
      OMHomeRecentUpdates obj = OMHomeRecentUpdates(
        user: user,
        date: notice[i].postedDate,
        plan: null,
        notice: notice[i],
        purchase: null,
      );
      if (i > 0) {
        noticeList.insert(0, obj);
      } else {
        noticeList.add(obj);
      }
    }

    for (int i = 0; i < plan.length; i++) {
      User user = await OMHomeRepository().getDetailUserInfo(plan[i].uid);
      OMHomeRecentUpdates obj = OMHomeRecentUpdates(
        user: user,
        date: plan[i].postedDate,
        plan: plan[i],
        notice: null,
        purchase: null,
      );
      if (i > 0) {
        planList.insert(0, obj);
      } else {
        planList.add(obj);
      }
    }

    for (int i = 0; i < purchase.length; i++) {
      User user =
          await OMHomeRepository().getDetailUserInfo(purchase[i].reqUser.uid);
      OMHomeRecentUpdates obj = OMHomeRecentUpdates(
        user: user,
        date: purchase[i].requestDate,
        plan: null,
        notice: null,
        purchase: purchase[i],
      );
      if (i > 0) {
        purchaseList.insert(0, obj);
      } else {
        purchaseList.add(obj);
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

    updateList = [
      ...noticeList,
      ...planList,
      ...purchaseList,
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
    );
  }

  Stream<OMHomeState> _mapSetFcmTokenToState() async* {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    String fcmToken = await _fcm.getToken();
    await OMHomeRepository()
        .updateFcmToken(await UserUtil.getUser().uid, fcmToken);
    yield state.update();
  }

  Stream<OMHomeState> _mapCheckAsReadToState(int index) async* {
    OMHomeRecentUpdates obj = state.recentUpdateList[index];
    if (obj.notice != null) {
      OMNotificationNotice notice = OMNotificationNotice(
          no: obj.notice.no,
          uid: obj.notice.uid,
          name: obj.notice.name,
          farmid: obj.notice.farmid,
          title: obj.notice.title,
          content: obj.notice.content,
          postedDate: obj.notice.postedDate,
          scheduledDate: obj.notice.scheduledDate,
          isReadByFM: obj.notice.isReadByFM,
          isReadByOffice: true,
          isReadBySFM: obj.notice.isReadBySFM,
          notid: obj.notice.notid,
          type: obj.notice.type,
          department: obj.notice.department,
          planid: obj.notice.planid);

      OMHomeRepository().updateNotice(notice);

      List<OMNotificationNotice> list = state.notice;
      int tmp =
          list.indexWhere((element) => notice.notid == element.notid) ?? -1;
      list.removeAt(tmp);
      list.insert(tmp, notice);

      OMHomeRecentUpdates newObj = OMHomeRecentUpdates(
        date: obj.date,
        user: obj.user,
        plan: obj.plan,
        notice: notice,
        purchase: obj.purchase,
      );

      List<OMHomeRecentUpdates> rplist = state.recentUpdateList;
      rplist.removeAt(index);
      rplist.insert(index, newObj);
      yield state.update(
        recentUpdateList: rplist,
        notice: list,
      );
    } else if (obj.plan != null) {
      OMPlan plan = OMPlan(
          planID: obj.plan.planID,
          uid: obj.plan.uid,
          startDate: obj.plan.startDate,
          endDate: obj.plan.endDate,
          postedDate: obj.plan.postedDate,
          title: obj.plan.title,
          content: obj.plan.content,
          isReadByFM: obj.plan.isReadByFM,
          isReadByOffice: true,
          isReadBySFM: obj.plan.isReadBySFM,
          from: obj.plan.from,
          farmID: obj.plan.farmID,
          isUpdated: obj.plan.isUpdated);

      OMHomeRepository().updatePlan(plan);

      List<OMPlan> list = state.plan;
      int tmp =
          list.indexWhere((element) => plan.planID == element.planID) ?? -1;
      list.removeAt(tmp);
      list.insert(tmp, plan);

      OMHomeRecentUpdates newObj = OMHomeRecentUpdates(
        date: obj.date,
        user: obj.user,
        plan: plan,
        notice: obj.notice,
        purchase: obj.purchase,
      );

      List<OMHomeRecentUpdates> rplist = state.recentUpdateList;
      rplist.removeAt(index);
      rplist.insert(index, newObj);

      yield state.update(
        recentUpdateList: rplist,
        plan: list,
      );
    } else if (obj.purchase != null) {
      Purchase purchase = Purchase(
          purchaseID: obj.purchase.purchaseID,
          farmID: obj.purchase.farmID,
          requester: obj.purchase.requester,
          receiver: obj.purchase.receiver,
          requestDate: obj.purchase.requestDate,
          receiveDate: obj.purchase.receiveDate,
          productName: obj.purchase.productName,
          amount: obj.purchase.amount,
          price: obj.purchase.price,
          marketUrl: obj.purchase.marketUrl,
          fid: obj.purchase.fid,
          memo: obj.purchase.memo,
          officeReply: obj.purchase.officeReply,
          waitingState: obj.purchase.waitingState,
          isFieldSelectionButtonClicked:
              obj.purchase.isFieldSelectionButtonClicked,
          isThereUpdates: false,
          reqUser: obj.purchase.reqUser,
          recUser: obj.purchase.recUser);

      OMHomeRepository().updatePurchase(purchase);

      List<Purchase> list = state.purchase;
      int tmp = list.indexWhere(
              (element) => purchase.purchaseID == element.purchaseID) ??
          -1;
      list.removeAt(tmp);
      list.insert(tmp, purchase);

      OMHomeRecentUpdates newObj = OMHomeRecentUpdates(
        date: obj.date,
        user: obj.user,
        plan: obj.plan,
        notice: obj.notice,
        purchase: purchase,
      );

      List<OMHomeRecentUpdates> rplist = state.recentUpdateList;
      rplist.removeAt(index);
      rplist.insert(index, newObj);

      yield state.update(
        recentUpdateList: rplist,
        purchase: list,
      );
    } else {
      // TODO
      print('object not matching : om home / check as read');
    }
  }

  Stream<OMHomeState> _mapChangeCurrFarmIndexToState(int index) async* {
    yield state.update(currentFarmIndex: index);
  }
}
