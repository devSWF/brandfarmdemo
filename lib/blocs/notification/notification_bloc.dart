
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
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
      importantList: importantList,
      generalList: generalList,
      unRead: unRead,
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
        department: obj.department
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

  // Stream<NotificationState> _mapPostNotificationToState(
  //     NotificationNotice obj) async* {
  //   // post notification
  //   String _notid = '';
  //   _notid = FirebaseFirestore.instance.collection('Notification').doc().id;
  //   NotificationNotice _notice = NotificationNotice(
  //     uid: obj.uid,
  //     name: obj.name,
  //     imgUrl: obj.imgUrl,
  //     fid: obj.fid,
  //     farmid: obj.farmid,
  //     title: obj.title,
  //     content: obj.content,
  //     postedDate: obj.postedDate,
  //     scheduledDate: obj.scheduledDate,
  //     isReadByFM: obj.isReadByFM,
  //     isReadByOffice: obj.isReadByOffice,
  //     isReadBySFM: obj.isReadBySFM,
  //     notid: _notid,
  //     type: obj.type,
  //   );
  //
  //   NotificationRepository().postNotification(_notice);
  //
  //   yield state.update(isLoading: false);
  // }
}
