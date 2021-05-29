import 'package:BrandFarm/blocs/om_notification/om_notification_event.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/send_to_farm/send_to_farm_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/om_notification/om_notification_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OMNotificationBloc
    extends Bloc<OMNotificationEvent, OMNotificationState> {
  OMNotificationBloc() : super(OMNotificationState.empty());

  @override
  Stream<OMNotificationState> mapEventToState(
      OMNotificationEvent event) async* {
    if (event is LoadOMNotification) {
      yield* _mapLoadOMNotificationToState();
    } else if (event is GetFarmList) {
      yield* _mapGetFarmListToState();
    } else if (event is SetFarm) {
      yield* _mapSetFarmToState(event.farm);
    } else if (event is PostNotification) {
      yield* _mapPostNotificationToState(event.obj);
    } else if (event is SetNotificationListOrder) {
      yield* _mapSetNotificationListOrderToState(event.columnIndex);
    } else if (event is SetNotification) {
      yield* _mapSetNotificationToState(event.notice);
    } else if (event is UpdateNotDropdownMenuState) {
      yield* _mapUpdateNotDropdownMenuStateToState();
    } else if (event is UpdateNotMenuIndex) {
      yield* _mapUpdateNotMenuIndexStateToState(event.menuIndex);
    } else if (event is GetNotificationListBySearch) {
      yield* _mapGetNotificationListBySearchToState(event.word);
    } else if (event is GetNotificationList) {
      yield* _mapGetNotificationListToState();
    } else if (event is ShowTotalList) {
      yield* _mapShowTotalListToState();
    } else if (event is SetNoticeAsRead) {
      yield* _mapSetNoticeAsReadToState(event.index);
    } else if (event is PushPlanNotification) {
      yield* _mapPushPlanNotificationToState(event.plan);
    }
  }

  Stream<OMNotificationState> _mapLoadOMNotificationToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<OMNotificationState> _mapGetFarmListToState() async* {
    List<Farm> tmp = await OMNotificationRepository().getFarmInfo();
    List<Farm> first = [];
    first.add(Farm(
        farmID: '',
        fieldCategory: '',
        managerID: '',
        officeNum: 1,
        name: '전체알림'));

    yield state.update(
      farm: first[0],
      farmList: [...first, ...tmp],
    );
  }

  Stream<OMNotificationState> _mapSetFarmToState(Farm farm) async* {
    yield state.update(farm: farm);
  }

  Stream<OMNotificationState> _mapPostNotificationToState(
      OMNotificationNotice obj) async* {
    // post notification
    String year = obj.postedDate.toDate().year.toString().substring(2);
    String month = DateFormat('MM').format(obj.postedDate.toDate());
    String day = DateFormat('dd').format(obj.postedDate.toDate());
    String no;

    for (int i = 0; i < 10; i++) {
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for (int j = 0; j < state.notificationListFromDB.length; j++) {
        if (state.notificationListFromDB[j].no.contains(tmpNo)) {
          exist = true;
          break;
        }
      }
      if (!exist) {
        no = tmpNo;
        break;
      }
    }

    String _notid = '';
    _notid = FirebaseFirestore.instance.collection('OMNotification').doc().id;
    OMNotificationNotice _notice = OMNotificationNotice(
      no: no,
      uid: obj.uid,
      name: obj.name,
      farmid: obj.farmid,
      title: obj.title,
      content: obj.content,
      postedDate: obj.postedDate,
      scheduledDate: obj.scheduledDate,
      isReadByFM: obj.isReadByFM,
      isReadByOffice: obj.isReadByOffice,
      isReadBySFM: obj.isReadBySFM,
      notid: _notid,
      type: obj.type,
      department: obj.department,
      planid: obj.planid,
    );

    OMNotificationRepository().postNotification(_notice);

    Farm farm = await OMNotificationRepository().getFarm(obj.farmid);
    User user = await OMNotificationRepository().getUser(farm.managerID);
    String docID =
        await FirebaseFirestore.instance.collection('SendToFarm').doc().id;
    SendToFarm _sendToFarm = SendToFarm(
      docID: docID,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      farmid: farm.farmID,
      title: '오피스 매니저 알림',
      content: '새로운 알림 내용이 있습니다',
      postedDate: Timestamp.now(),
      jid: '',
      issid: '',
      cmtid: '',
      scmtid: '',
      fcmToken: user.fcmToken,
    );
    OMNotificationRepository().sendNotification(_sendToFarm);

    yield state.update(isLoading: false);
  }

  Stream<OMNotificationState> _mapSetNotificationListOrderToState(
      int columnIndex) async* {
    List<OMNotificationNotice> nlist = state.notificationList;
    bool isAscending;
    if (state.isAscending == true) {
      isAscending = false;
      // sort the product list in Ascending, order by Price
      nlist
          .sort((listA, listB) => listB.postedDate.compareTo(listA.postedDate));
    } else {
      isAscending = true;
      // sort the product list in Descending, order by Price
      nlist
          .sort((listA, listB) => listA.postedDate.compareTo(listB.postedDate));
    }

    yield state.update(
      currentSortColumn: columnIndex,
      isAscending: isAscending,
      notificationList: nlist,
    );
  }

  Stream<OMNotificationState> _mapSetNotificationToState(
      OMNotificationNotice notice) async* {
    yield state.update(
      notice: notice,
    );
  }

  Stream<OMNotificationState> _mapUpdateNotDropdownMenuStateToState() async* {
    yield state.update(
      showDropdownMenu: !state.showDropdownMenu,
    );
  }

  Stream<OMNotificationState> _mapUpdateNotMenuIndexStateToState(
      int index) async* {
    yield state.update(
      menuIndex: index,
    );
  }

  Stream<OMNotificationState> _mapGetNotificationListBySearchToState(
      String word) async* {
    // notification list by search
    List<OMNotificationNotice> nlist = [];

    if (state.menu[state.menuIndex].contains('No.')) {
      nlist = state.notificationList
          .where((element) => element.notid.contains(word))
          .toList();
    } else if (state.menu[state.menuIndex].contains('제목')) {
      nlist = state.notificationList
          .where((element) => element.title.contains(word))
          .toList();
    } else {
      nlist = state.notificationList
          .where((element) => element.name.contains(word))
          .toList();
    }

    yield state.update(
      notificationList: nlist,
    );
  }

  Stream<OMNotificationState> _mapGetNotificationListToState() async* {
    // get notification list from firebase
    List<OMNotificationNotice> nlist = [];
    nlist = await OMNotificationRepository().getNotificationList();

    yield state.update(
      notificationList: nlist,
      notificationListFromDB: nlist,
    );
  }

  Stream<OMNotificationState> _mapShowTotalListToState() async* {
    yield state.update(
      notificationList: state.notificationListFromDB,
    );
  }

  Stream<OMNotificationState> _mapSetNoticeAsReadToState(int index) async* {
    OMNotificationNotice obj = state.notificationList[index];
    OMNotificationNotice newObj = OMNotificationNotice(
      no: obj.no,
      uid: obj.uid,
      name: obj.name,
      farmid: obj.farmid,
      title: obj.title,
      content: obj.content,
      postedDate: obj.postedDate,
      scheduledDate: obj.scheduledDate,
      isReadByFM: obj.isReadByFM,
      isReadByOffice: !obj.isReadByOffice,
      isReadBySFM: obj.isReadBySFM,
      notid: obj.notid,
      type: obj.type,
      department: obj.department,
      planid: obj.planid,
    );

    int index1 = state.notificationList
            .indexWhere((element) => element.notid == obj.notid) ??
        -1;
    int index2 = state.notificationListFromDB
            .indexWhere((element) => element.notid == obj.notid) ??
        -1;

    List<OMNotificationNotice> nlist = state.notificationList;
    List<OMNotificationNotice> nlistFromDB = state.notificationListFromDB;
    if (index1 != -1) {
      nlist.removeAt(index1);
      nlist.insert(index1, newObj);
    }

    if (index2 != -1) {
      nlistFromDB.removeAt(index2);
      nlistFromDB.insert(index2, newObj);
    }

    OMNotificationRepository().updateNotice(obj: newObj);

    yield state.update(
      notificationList: nlist,
      notificationListFromDB: nlistFromDB,
    );
  }

  Stream<OMNotificationState> _mapPushPlanNotificationToState(
      OMPlan plan) async* {
    DateTime date = plan.postedDate.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for (int i = 0; i < 10; i++) {
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for (int j = 0; j < state.notificationListFromDB.length; j++) {
        if (state.notificationListFromDB[j].no.contains(tmpNo)) {
          exist = true;
          break;
        }
      }
      if (!exist) {
        no = tmpNo;
        break;
      }
    }

    String _notid = '';
    _notid = FirebaseFirestore.instance.collection('OMNotification').doc().id;
    OMNotificationNotice _notice = OMNotificationNotice(
      no: no,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      farmid: plan.farmID,
      title: plan.title,
      content: plan.content,
      postedDate: plan.postedDate,
      scheduledDate: plan.postedDate,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'office',
      planid: plan.planID,
    );

    OMNotificationRepository().postNotification(_notice);
    yield state.update();
  }
}
