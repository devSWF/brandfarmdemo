
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

    List<FMContact> contactList = await FMContactRepository().getContactList(fieldList);

    yield state.update(
      contactList: contactList,
    );
  }
}
