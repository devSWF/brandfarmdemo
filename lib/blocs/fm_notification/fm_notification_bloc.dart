import 'package:BrandFarm/blocs/fm_notification/fm_notification_event.dart';
import 'package:BrandFarm/blocs/fm_notification/fm_notification_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/repository/fm_notification/fm_notification_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FMNotificationBloc
    extends Bloc<FMNotificationEvent, FMNotificationState> {
  FMNotificationBloc() : super(FMNotificationState.empty());

  @override
  Stream<FMNotificationState> mapEventToState(
      FMNotificationEvent event) async* {
    if (event is LoadFMNotification) {
      yield* _mapLoadFMNotificationToState();
    } else if (event is GetFieldList) {
      yield* _mapGetFieldListToState();
    } else if (event is SetField) {
      yield* _mapSetFieldToState(event.field);
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
    } else if (event is PushSCommentNotification) {
      yield* _mapPushSCommentNotificationToState(event.scmt);
    } else if (event is PostCommentNotification) {
      yield* _mapPostCommentNotificationToState(event.cmt);
    } else if (event is PostIssueCommentNotice) {
      yield* _mapPostIssueCommentNoticeToState(event.cmt);
    } else if (event is PostIssueSCommentNotice) {
      yield* _mapPostIssueSCommentNoticeToState(event.scmt);
    }
  }

  Stream<FMNotificationState> _mapLoadFMNotificationToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMNotificationState> _mapGetFieldListToState() async* {
    Farm farm = await FMNotificationRepository().getFarmInfo();
    List<Field> currFieldList = [
      Field(
          fieldCategory: farm.fieldCategory,
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: '모든 필드')
    ];
    List<Field> newFieldList =
        await FMNotificationRepository().getFieldList(farm.fieldCategory);
    List<Field> totalFieldList = [
      ...currFieldList,
      ...newFieldList,
    ];

    yield state.update(
      farm: farm,
      fieldList: totalFieldList,
      field: totalFieldList[0],
    );
  }

  Stream<FMNotificationState> _mapSetFieldToState(Field field) async* {
    yield state.update(field: field);
  }

  Stream<FMNotificationState> _mapPostNotificationToState(
      NotificationNotice obj) async* {
    // post notification
    String year = obj.postedDate.toDate().year.toString().substring(2);
    String month = DateFormat('MM').format(obj.postedDate.toDate());
    String day = DateFormat('dd').format(obj.postedDate.toDate());
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      uid: obj.uid,
      name: obj.name,
      imgUrl: obj.imgUrl,
      fid: obj.fid,
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
      jid: obj.jid,
      issid: obj.issid,
      planid: obj.planid,
    );

    FMNotificationRepository().postNotification(_notice);

    yield state.update(isLoading: false);
  }

  Stream<FMNotificationState> _mapSetNotificationListOrderToState(
      int columnIndex) async* {

    List<NotificationNotice> nlist = state.notificationList;
    bool isAscending;
    if (state.isAscending == true) {
      isAscending = false;
      // sort the product list in Ascending, order by Price
      nlist.sort((listA, listB) =>
          listB.postedDate.compareTo(
              listA.postedDate));
    } else {
      isAscending = true;
      // sort the product list in Descending, order by Price
      nlist.sort((listA, listB) =>
          listA.postedDate.compareTo(
              listB.postedDate));
    }

    yield state.update(
      currentSortColumn: columnIndex,
      isAscending: isAscending,
      notificationList: nlist,
    );
  }

  Stream<FMNotificationState> _mapSetNotificationToState(
      NotificationNotice notice) async* {
    yield state.update(
      notice: notice,
    );
  }

  Stream<FMNotificationState> _mapUpdateNotDropdownMenuStateToState() async* {
    yield state.update(
      showDropdownMenu: !state.showDropdownMenu,
    );
  }

  Stream<FMNotificationState> _mapUpdateNotMenuIndexStateToState(int index) async* {
    yield state.update(
      menuIndex: index,
    );
  }

  Stream<FMNotificationState> _mapGetNotificationListBySearchToState(String word) async* {
    // notification list by search
    List<NotificationNotice> nlist = [];

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

  Stream<FMNotificationState> _mapGetNotificationListToState() async* {
    // get notification list from firebase
    List<NotificationNotice> nlist = [];
    nlist = await FMNotificationRepository().getNotificationList(state.farm.farmID);

    yield state.update(
      notificationList: nlist,
      notificationListFromDB: nlist,
    );
  }

  Stream<FMNotificationState> _mapShowTotalListToState() async* {
    yield state.update(
      notificationList: state.notificationListFromDB,
    );
  }

  Stream<FMNotificationState> _mapSetNoticeAsReadToState(int index) async* {
    NotificationNotice obj = state.notificationList[index];
    NotificationNotice newObj = NotificationNotice(
        no: obj.no,
        uid: obj.uid,
        name: obj.name,
        imgUrl: obj.imgUrl,
        fid: obj.fid,
        farmid: obj.farmid,
        title: obj.title,
        content: obj.content,
        postedDate: obj.postedDate,
        scheduledDate: obj.scheduledDate,
        isReadByFM: !obj.isReadByFM,
        isReadByOffice: obj.isReadByOffice,
        isReadBySFM: obj.isReadBySFM,
        notid: obj.notid,
        type: obj.type,
        department: obj.department,
      jid: obj.jid,
      issid: obj.issid,
      planid: obj.planid,
    );

    int index1 = state.notificationList.indexWhere((element) => element.notid == obj.notid) ?? -1;
    int index2 = state.notificationListFromDB.indexWhere((element) => element.notid == obj.notid) ?? -1;

    List<NotificationNotice> nlist = state.notificationList;
    List<NotificationNotice> nlistFromDB = state.notificationListFromDB;
    if(index1 != -1) {
      nlist.removeAt(index1);
      nlist.insert(index1, newObj);
    }

    if(index2 != -1) {
      nlistFromDB.removeAt(index2);
      nlistFromDB.insert(index2, newObj);
    }

    FMNotificationRepository().updateNotice(obj: newObj);

    yield state.update(
      notificationList: nlist,
      notificationListFromDB: nlistFromDB,
    );
  }

  Stream<FMNotificationState> _mapPushPlanNotificationToState(
      FMPlan plan) async* {
    DateTime date = plan.postedDate.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      imgUrl: UserUtil.getUser().imgUrl,
      fid: plan.fid,
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
      department: 'farm',
      jid: '',
      issid: '',
      planid: plan.planID,
    );

    FMNotificationRepository().postNotification(_notice);
    yield state.update();
  }

  Stream<FMNotificationState> _mapPushSCommentNotificationToState(
      SubComment scmt) async* {
    DateTime date = scmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      imgUrl: UserUtil.getUser().imgUrl,
      fid: scmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: scmt.scomment,
      postedDate: scmt.date,
      scheduledDate: scmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: scmt.jid,
      issid: scmt.issid,
      planid: '',
    );

    FMNotificationRepository().postNotification(_notice);
    yield state.update();
  }

  Stream<FMNotificationState> _mapPostCommentNotificationToState(
      Comment cmt) async* {
    DateTime date = cmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      imgUrl: UserUtil.getUser().imgUrl,
      fid: cmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: cmt.comment,
      postedDate: cmt.date,
      scheduledDate: cmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: cmt.jid,
      issid: cmt.issid,
      planid: '',
    );

    FMNotificationRepository().postNotification(_notice);
    yield state.update();
  }

  Stream<FMNotificationState> _mapPostIssueCommentNoticeToState(
      Comment cmt) async* {
    DateTime date = cmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      imgUrl: UserUtil.getUser().imgUrl,
      fid: cmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: cmt.comment,
      postedDate: cmt.date,
      scheduledDate: cmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: cmt.jid,
      issid: cmt.issid,
      planid: '',
    );

    FMNotificationRepository().postNotification(_notice);
    yield state.update();
  }

  Stream<FMNotificationState> _mapPostIssueSCommentNoticeToState(
      SubComment scmt) async* {
    DateTime date = scmt.date.toDate();
    String year = date.year.toString().substring(2);
    String month = DateFormat('MM').format(date);
    String day = DateFormat('dd').format(date);
    String no;

    for(int i=0; i< 10; i++){
      String tmpNo = '${year}${month}${day}${i}';
      bool exist = false;
      for(int j=0; j<state.notificationListFromDB.length; j++) {
        if(state.notificationListFromDB[j].no.contains(tmpNo)) {
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
      imgUrl: UserUtil.getUser().imgUrl,
      fid: scmt.fid,
      farmid: state.farm.farmID,
      title: 'New Comment',
      content: scmt.scomment,
      postedDate: scmt.date,
      scheduledDate: scmt.date,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      notid: _notid,
      type: '일반',
      department: 'farm',
      jid: scmt.jid,
      issid: scmt.issid,
      planid: '',
    );

    FMNotificationRepository().postNotification(_notice);
    yield state.update();
  }
}
