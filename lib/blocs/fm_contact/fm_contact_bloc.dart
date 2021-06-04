import 'package:BrandFarm/blocs/fm_contact/fm_contact_event.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_state.dart';
import 'package:BrandFarm/models/contact/contact_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/repository/fm_contact/fm_contact_repository.dart';
import 'package:bloc/bloc.dart';

class FMContactBloc extends Bloc<FMContactEvent, FMContactState> {
  FMContactBloc() : super(FMContactState.empty());

  @override
  Stream<FMContactState> mapEventToState(FMContactEvent event) async* {
    if (event is LoadFMContact) {
      yield* _mapLoadFMContactToState();
    } else if (event is GetContactList) {
      yield* _mapGetContactListToState();
    }
  }

  Stream<FMContactState> _mapLoadFMContactToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMContactState> _mapGetContactListToState() async* {
    // get contact list
    Farm farm = await FMContactRepository().getFarmInfo();

    List<Field> fieldList =
        await FMContactRepository().getFieldList(farm.fieldCategory);

    List<FMContact> contactList =
        await FMContactRepository().getContactList(fieldList);

    // int len = contactList.length;
    // int num;
    // if (len % 2 != 0) {
    //   num = len + 1;
    // } else {
    //   num = len;
    // }
    //
    // double x = num / 2;
    // int col = x.toInt();
    // int row = 2;

    List<List<FMContact>> cList = [];
    // List<FMContact> tmp = [];
    // int obj = 0;
    // print('1111');
    // for (int i = 0; i < col; i++) {
    //   for (int j = 0; j < row; j++) {
    //     if (contactList[obj].uid.isNotEmpty) {
    //       if (tmp.isEmpty) {
    //         tmp.insert(0, contactList[obj]);
    //         obj += 1;
    //       } else {
    //         tmp.add(contactList[obj]);
    //         obj += 1;
    //       }
    //     } else {
    //       break;
    //     }
    //   }
    //   if (cList.isEmpty) {
    //     cList.insert(0, tmp);
    //   } else {
    //     cList.add(tmp);
    //   }
    // }

    // print('${cList.length}');

    yield state.update(
      contactList: contactList,
      col: 0,
      row: 0,
      cList: cList,
    );
  }
}
