import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/repository/fm_journal/fm_journal_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMJournalBloc extends Bloc<FMJournalEvent, FMJournalState> {
  FMJournalBloc() : super(FMJournalState.empty());

  @override
  Stream<FMJournalState> mapEventToState(FMJournalEvent event) async* {
    if (event is LoadFMJournalList) {
      yield* _mapLoadFMJournalListToState();
    } else if (event is ChangeScreen) {
      yield* _mapChangeScreenToState(event.navTo, event.index);
    } else if (event is SetField) {
      yield* _mapSetFieldToState(event.field);
    } else if (event is GetFieldList) {
      yield* _mapGetFieldListToState();
    } else if (event is SetJourYear) {
      yield* _mapSetJourYearToState(event.year);
    } else if (event is SetJourMonth) {
      yield* _mapSetJourMonthToState(event.month);
    } else if (event is ChangeSwitchState) {
      yield* _mapChangeSwitchStateToState();
    } else if (event is ReloadFMJournal) {
      yield* _mapReloadFMJournalToState();
    } else if (event is ChangeListOrder) {
      yield* _mapChangeListOrderToState(event.order);
    } else if (event is SetFieldButtonSize) {
      yield* _mapSetFieldButtonSizeToState(event.height, event.width);
    } else if (event is SetFieldButtonPosition) {
      yield* _mapSetFieldButtonPositionToState(event.x, event.y);
    } else if (event is UpdateFieldButtonState) {
      yield* _mapUpdateFieldButtonStateToState();
    } else if (event is GetJournalList) {
      yield* _mapGetJournalListToState();
    } else if (event is SetJournal) {
      yield* _mapSetJournalToState();
    }
  }

  Stream<FMJournalState> _mapLoadFMJournalListToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMJournalState> _mapChangeScreenToState(int navTo, int index) async* {
    yield state.update(
        shouldReload: false,
        navTo: navTo,
        index: index,
    );
  }

  Stream<FMJournalState> _mapSetFieldToState(Field field) async* {
    yield state.update(
      field: field,
      isFieldMenuButtonVisible: !state.isFieldMenuButtonVisible,
    );
  }

  Stream<FMJournalState> _mapGetFieldListToState() async* {
    Farm farm = await FMJournalRepository().getFarmInfo();
    List<Field> fieldList =
        await FMJournalRepository().getFieldList(farm.fieldCategory);

    yield state.update(
      farm: farm,
      fieldList: fieldList,
      field: fieldList[0],
    );
  }

  Stream<FMJournalState> _mapSetJourYearToState(String year) async* {
    // year
    yield state.update(
      year: year,
    );
  }

  Stream<FMJournalState> _mapSetJourMonthToState(String month) async* {
    // month
    yield state.update(
      month: month,
    );
  }

  Stream<FMJournalState> _mapChangeSwitchStateToState() async* {
    // switch
    yield state.update(
      isIssue: !state.isIssue,
    );
  }

  Stream<FMJournalState> _mapReloadFMJournalToState() async* {
    // reload
    yield state.update(
      shouldReload: true,
    );
  }

  Stream<FMJournalState> _mapChangeListOrderToState(String order) async* {
    // list order by recent / oldest
    yield state.update(
      order: order,
    );
  }

  Stream<FMJournalState> _mapSetFieldButtonSizeToState(double height, double width) async* {
    // set field menu size
    yield state.update(
      fieldMenuButtonHeight: height,
      fieldMenuButtonWidth: width,
    );
  }

  Stream<FMJournalState> _mapSetFieldButtonPositionToState(double x, double y) async* {
    // set field menu position
    yield state.update(
      fieldMenuButtonX: x,
      fieldMenuButtonY: y,
    );
  }

  Stream<FMJournalState> _mapUpdateFieldButtonStateToState() async* {
    // update field button visible state
    yield state.update(
      isFieldMenuButtonVisible: !state.isFieldMenuButtonVisible,
    );
  }

  Stream<FMJournalState> _mapGetJournalListToState() async* {
    int year = int.parse(state.year);
    int month = int.parse(state.month);
    DateTime firstDay = DateTime(year, month, 1);
    DateTime lastDay = DateTime(year, month + 1, 0);
    Timestamp fDay = Timestamp.fromDate(firstDay);
    Timestamp lDay = Timestamp.fromDate(lastDay);

    List<Journal> journalList =
    await FMJournalRepository().getJournalList(state.field, fDay, lDay);

    List<Journal> reverseList = List.from(journalList.reversed);

    List<ImagePicture> pictureList = await FMJournalRepository().getImage(state.field);
    yield state.update(
      journalList: journalList,
      reverseList: reverseList,
      imageList: pictureList,
    );
  }

  Stream<FMJournalState> _mapSetJournalToState() async* {
    Journal obj;
    if(state.order == '최신 순'){
      obj = state.journalList[state.index];
    } else {
      obj = state.reverseList[state.index];
    }

    yield state.update(
      journal: obj,
    );
  }
}
