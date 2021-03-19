import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/repository/fm_plan/fm_plan_repository.dart';
import 'package:bloc/bloc.dart';

class FMPlanBloc
    extends Bloc<FMPlanEvent, FMPlanState> {
  FMPlanBloc() : super(FMPlanState.empty());

  @override
  Stream<FMPlanState> mapEventToState(
      FMPlanEvent event) async* {
    if (event is LoadFMPlan) {
      yield* _mapLoadFMPlanToState();
    } else if (event is GetFieldListForFMPlan) {
      yield* _mapGetFieldListForFMPlanToState();
    }
  }

  Stream<FMPlanState> _mapLoadFMPlanToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMPlanState> _mapGetFieldListForFMPlanToState() async* {
    Farm farm = await FMPlanRepository().getFarmInfo();
    List<Field> currFieldList = [
      Field(
          fieldCategory: farm.fieldCategory,
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: '전체일정')
    ];
    List<Field> newFieldList =
    await FMPlanRepository().getFieldList(farm.fieldCategory);
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

//   Stream<FMPurchaseState> _mapSetFieldToState(Field field) async* {
//     yield state.update(field: field);
//   }
//
//   Stream<FMPurchaseState> _mapPostNotificationToState(
//       NotificationNotice obj) async* {
//     // post notification
//     String _notid = '';
//     _notid = FirebaseFirestore.instance.collection('Notification').doc().id;
//     NotificationNotice _notice = NotificationNotice(
//       uid: obj.uid,
//       name: obj.name,
//       imgUrl: obj.imgUrl,
//       fid: obj.fid,
//       farmid: obj.farmid,
//       title: obj.title,
//       content: obj.content,
//       postedDate: obj.postedDate,
//       scheduledDate: obj.scheduledDate,
//       isReadByFM: obj.isReadByFM,
//       isReadByOffice: obj.isReadByOffice,
//       isReadBySFM: obj.isReadBySFM,
//       notid: _notid,
//       type: obj.type,
//       department: obj.department,
//     );
//
//     FMNotificationRepository().postNotification(_notice);
//
//     yield state.update(isLoading: false);
//   }
}
