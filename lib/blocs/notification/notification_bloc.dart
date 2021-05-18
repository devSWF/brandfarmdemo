
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/notification/notification_repository.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:bloc/bloc.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState.empty());

  @override
  Stream<NotificationState> mapEventToState(
      NotificationEvent event) async* {
    if (event is LoadNotification) {
      yield* _mapLoadFMNotificationToState();
    } else if (event is GetNotificationList) {
      yield* _mapGetNotificationListToState();
    } else if (event is CheckAsRead) {
      yield* _mapCheckAsReadToState(event.obj);
    } else if (event is GetJournalNotificationInitials) {
      yield* _mapGetJournalNotificationInitialsToState(event.obj);
    } else if (event is SetExpansionState) {
      yield* _mapSetExpansionStateToState(event.index);
    } else if (event is GetIssueNotificationInitials) {
      yield* _mapGetIssueNotificationInitialsToState(event.obj);
    } else if (event is GetPlanNotificationInitials) {
      yield* _mapGetPlanNotificationInitialsToState(event.obj);
    }
  }

  Stream<NotificationState> _mapLoadFMNotificationToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<NotificationState> _mapGetNotificationListToState() async* {
    Farm farm = await NotificationRepository().getFarmInfo(FieldUtil.getField().fieldCategory);

    // List<NotificationNotice> officeList = await NotificationRepository().getOfficeNotification();
    List<NotificationNotice> farmList = await NotificationRepository().getFarmNotification(farm.farmID);

    List<NotificationNotice> importantList = farmList.where((element) => element.type != '일반').toList();
    List<NotificationNotice> generalList = farmList.where((element) => element.type == '일반').toList();

    // List<NotificationNotice> totalList = [
    //   ...farmList,
    //   ...officeList,
    // ];

    int unRead = 0;
    farmList.forEach((element) {
      if(!element.isReadBySFM){
        unRead += 1;
      }
    });

    yield state.update(
      farm: farm,
      allList: farmList,
      importantList: importantList,
      generalList: generalList,
      unRead: unRead,
      isLoading: false,
    );
  }

  Stream<NotificationState> _mapCheckAsReadToState(NotificationNotice obj) async* {
    NotificationNotice isRead = NotificationNotice(
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
        isReadByFM: obj.isReadByFM,
        isReadByOffice: obj.isReadByOffice,
        isReadBySFM: true,
        notid: obj.notid,
        type: obj.type,
        department: obj.department,
        jid: obj.jid,
      issid: obj.issid,
      planid: obj.planid,
    );

    List<NotificationNotice> impList = state.importantList;
    List<NotificationNotice> genList = state.generalList;

    int index1 = impList.indexWhere((data) => data.notid == obj.notid) ?? -1;
    int index2 = genList.indexWhere((data) => data.notid == obj.notid) ?? -1;

    if (index1 != -1) {
      impList.removeAt(index1);
      impList.insert(index1, isRead);
    }
    if (index2 != -1) {
      genList.removeAt(index2);
      genList.insert(index2, isRead);
    }

    NotificationRepository().updateNotification(obj: isRead);

    yield state.update(
      importantList: impList,
      generalList: genList,
      unRead: state.unRead - 1,
    );
  }

  Stream<NotificationState> _mapGetJournalNotificationInitialsToState(
      NotificationNotice obj) async* {
    Journal _jObj;
    List<Comment> _cmt = [];
    List<SubComment> _scmt = [];
    List<ImagePicture> _pic = [];
    List<User> _cmtUsers = [];
    List<User> _scmtUsers = [];

    _jObj = await NotificationRepository().getJournal(obj.jid);
    _cmt = await NotificationRepository().getCommentForJournal(obj.jid);
    _scmt = await NotificationRepository().getSubCommentForJournal(obj.jid);
    _pic = await NotificationRepository().getImagePictureForJournal(obj.jid);

    await Future.forEach(_cmt, (element) async {
      _cmtUsers.add(await NotificationRepository().getUserInfo(element.uid));
    });

    await Future.forEach(_scmt, (element) async {
      _scmtUsers.add(await NotificationRepository().getUserInfo(element.uid));
    });

    yield state.update(
      jObj: _jObj,
      clist: _cmt,
      sclist: _scmt,
      piclist: _pic,
      commentUser: _cmtUsers,
      scommentUser: _scmtUsers,
    );
  }

  Stream<NotificationState> _mapSetExpansionStateToState(
      int index) async* {
    List<Comment> list = state.clist;
    Comment cObj = list[index];
    Comment newObj = Comment(
      date: cObj.date,
      name: cObj.name,
      uid: cObj.uid,
      issid: cObj.issid,
      jid: cObj.jid,
      cmtid: cObj.cmtid,
      comment: cObj.comment,
      isThereSubComment: cObj.isThereSubComment,
      isExpanded: !cObj.isExpanded,
      fid: cObj.fid,
      imgUrl: cObj.imgUrl,
      isWriteSubCommentClicked: cObj.isWriteSubCommentClicked,
      isReadByFM: cObj.isReadByFM,
      isReadByOM: cObj.isReadByOM,
      isReadBySFM: cObj.isReadBySFM,
    );
    list.removeAt(index);
    list.insert(index, newObj);
    yield state.update(
      clist: list,
    );
  }

  Stream<NotificationState> _mapGetIssueNotificationInitialsToState(
      NotificationNotice obj) async* {
    SubJournalIssue _iObj;
    List<Comment> _cmt = [];
    List<SubComment> _scmt = [];
    List<ImagePicture> _pic = [];
    List<User> _cmtUsers = [];
    List<User> _scmtUsers = [];

    _iObj = await NotificationRepository().getIssue(obj.issid);
    _cmt = await NotificationRepository().getCommentForIssue(obj.issid);
    _scmt = await NotificationRepository().getSubCommentForIssue(obj.issid);
    _pic = await NotificationRepository().getImagePictureForIssue(obj.issid);

    await Future.forEach(_cmt, (element) async {
      _cmtUsers.add(await NotificationRepository().getUserInfo(element.uid));
    });

    await Future.forEach(_scmt, (element) async {
      _scmtUsers.add(await NotificationRepository().getUserInfo(element.uid));
    });

    yield state.update(
      iObj: _iObj,
      clist: _cmt,
      sclist: _scmt,
      piclist: _pic,
      commentUser: _cmtUsers,
      scommentUser: _scmtUsers,
    );
  }

  Stream<NotificationState> _mapGetPlanNotificationInitialsToState(
      NotificationNotice obj) async* {
    FMPlan _plan;

    _plan = await NotificationRepository().getPlan(obj.planid);

    yield state.update(
      plan: _plan,
    );
  }
}
