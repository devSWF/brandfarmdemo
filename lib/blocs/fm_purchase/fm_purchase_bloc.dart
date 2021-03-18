
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_event.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/repository/fm_purchase/fm_purchase_repository.dart';
import 'package:bloc/bloc.dart';

class FMPurchaseBloc
    extends Bloc<FMPurchaseEvent, FMPurchaseState> {
  FMPurchaseBloc() : super(FMPurchaseState.empty());

  @override
  Stream<FMPurchaseState> mapEventToState(
      FMPurchaseEvent event) async* {
    if (event is LoadFMPurchase) {
      yield* _mapLoadFMPurchaseToState();
    } else if (event is GetFieldList) {
      yield* _mapGetFieldListToState();
    }
  }

  Stream<FMPurchaseState> _mapLoadFMPurchaseToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMPurchaseState> _mapGetFieldListToState() async* {
    Farm farm = await FMPurchaseRepository().getFarmInfo();
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
    await FMPurchaseRepository().getFieldList(farm.fieldCategory);
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
