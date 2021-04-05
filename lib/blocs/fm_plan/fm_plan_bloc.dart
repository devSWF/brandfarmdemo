import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/repository/fm_plan/fm_plan_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMPlanBloc extends Bloc<FMPlanEvent, FMPlanState> {
  FMPlanBloc() : super(FMPlanState.empty());

  @override
  Stream<FMPlanState> mapEventToState(FMPlanEvent event) async* {
    if (event is LoadFMPlan) {
      yield* _mapLoadFMPlanToState();
    } else if (event is GetFieldListForFMPlan) {
      yield* _mapGetFieldListForFMPlanToState();
    } else if (event is GetPlanList) {
      yield* _mapGetPlanListToState();
    } else if (event is PostNewPlan) {
      yield* _mapPostNewPlanToState();
    } else if (event is SetDate) {
      yield* _mapSetDateToState(event.date);
    } else if (event is SetSelectedField) {
      yield* _mapSetSelectedFieldToState(event.selectedField);
    } else if (event is SetStartDate) {
      yield* _mapSetStartDateToState(event.startDate);
    } else if (event is SetEndDate) {
      yield* _mapSetEndDateToState(event.endDate);
    } else if (event is SetWaitingPlan) {
      yield* _mapSetWaitingPlanToState(event.wPlan);
    } else if (event is CheckConfirmState) {
      yield* _mapCheckConfirmStateToState(event.confirmState);
    } else if (event is GetShortDetailList) {
      yield* _mapGetShortDetailListToState();
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

  Stream<FMPlanState> _mapGetPlanListToState() async* {
    // get plan list
    List<FMPlan> plist = [];
    plist = await FMPlanRepository().getPlanList(state.farm.farmID);

    yield state.update(
      planList: plist,
    );
  }

  Stream<FMPlanState> _mapPostNewPlanToState() async* {
    // post new plan
    String planID = '';
    planID = FirebaseFirestore.instance.collection('Plan').doc().id;
    FMPlan newPlan = FMPlan(
      planID: planID,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      imgUrl: UserUtil.getUser().imgUrl,
      startDate: Timestamp.fromDate(state.wPlan.startDate),
      endDate: Timestamp.fromDate(state.wPlan.endDate),
      title: state.wPlan.title,
      content: state.wPlan.content,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      from: 2,
      // 1 : office, 2 : FM
      fid: (state.wPlan.selectedFieldIndex > 0) ? state.fieldList[state.wPlan.selectedFieldIndex].fid : '',
      farmID: state.farm.farmID,
    );

    FMPlanRepository().postPlan(newPlan);

    List<FMPlan> plist = state.planList;
    if (plist.isEmpty) {
      plist.insert(0, newPlan);
    } else {
      plist.add(newPlan);
    }

    yield state.update(
      planList: plist,
    );
  }

  Stream<FMPlanState> _mapSetDateToState(DateTime date) async* {
    // set date and show detail plan
    print('//////////////////${date}');
    List<FMPlan> detailList = [];
    detailList = (state.planList.length > 0)
        ? state.planList.where((element) {
            // print('${element.startDate.toDate()}');
            // print(
            //     'date is after start date : ${date.isAfter(element.startDate.toDate())}');
            // print(
            //     'date is before end date : ${date.isBefore(element.endDate.toDate())}');
            // print(
            //     'date is equal to start date : ${DateTime.utc(date.year, date.month, date.day).isAtSameMomentAs(DateTime.utc(element.startDate.toDate().year, element.startDate.toDate().month, element.startDate.toDate().day))}');
            // print(
            //     'date is equal to end date : ${DateTime.utc(date.year, date.month, date.day).isAtSameMomentAs(DateTime.utc(element.endDate.toDate().year, element.endDate.toDate().month, element.endDate.toDate().day))}');
            // print('${element.endDate.toDate()}');
            return ((element.startDate.toDate().isBefore(date) ||
                    DateTime.utc(date.year, date.month, date.day)
                        .isAtSameMomentAs(DateTime.utc(
                            element.startDate.toDate().year,
                            element.startDate.toDate().month,
                            element.startDate.toDate().day))) &&
                (element.endDate.toDate().isAfter(date) ||
                    DateTime.utc(date.year, date.month, date.day)
                        .isAtSameMomentAs(DateTime.utc(
                            element.endDate.toDate().year,
                            element.endDate.toDate().month,
                            element.endDate.toDate().day))));
          }).toList()
        : [];

    yield state.update(
      selectedDate: date,
      detailList: detailList,
    );
  }

  Stream<FMPlanState> _mapSetSelectedFieldToState(int selectedField) async* {
    // set selected field
    yield state.update(
      selectedField: selectedField,
    );
  }

  Stream<FMPlanState> _mapSetStartDateToState(DateTime start) async* {
    // set start date
    yield state.update(
      startDate: start,
    );
  }

  Stream<FMPlanState> _mapSetEndDateToState(DateTime end) async* {
    // set end date
    yield state.update(
      endDate: end,
    );
  }

  Stream<FMPlanState> _mapSetWaitingPlanToState(WaitingConfirmation wPlan) async* {
    // wait for post confirmation
    yield state.update(
      wPlan: wPlan,
    );
  }

  Stream<FMPlanState> _mapCheckConfirmStateToState(bool cState) async* {
    // check if confirm button is pressed
    yield state.update(
      isConfirmed: cState,
    );
  }

  Stream<FMPlanState> _mapGetShortDetailListToState() async* {
    // get short detail list
    DateTime now = DateTime.now();
    DateTime twoDaysLess = DateTime.utc(now.year, now.month, now.day - 2);
    DateTime oneDayLess = DateTime.utc(now.year, now.month, now.day - 1);
    DateTime curr = DateTime.utc(now.year, now.month, now.day);
    DateTime oneDayMore = DateTime.utc(now.year, now.month, now.day + 1);
    DateTime twoDaysMore = DateTime.utc(now.year, now.month, now.day + 2);
    List<FMPlan> _selectedList = state.planList
        .where((plan) => (
        // two days less
        ((plan.endDate.toDate().isAfter(twoDaysLess) || twoDaysLess.isAtSameMomentAs(DateTime.utc(plan.endDate.toDate().year, plan.endDate.toDate().month, plan.endDate.toDate().day))) &&
            ((plan.startDate.toDate().isBefore(twoDaysLess) ||
                twoDaysLess.isAtSameMomentAs(DateTime.utc(
                    plan.startDate.toDate().year,
                    plan.startDate.toDate().month,
                    plan.startDate.toDate().day))))) ||
            // one day less
            ((plan.endDate.toDate().isAfter(oneDayLess) || oneDayLess.isAtSameMomentAs(DateTime.utc(plan.endDate.toDate().year, plan.endDate.toDate().month, plan.endDate.toDate().day))) &&
                ((plan.startDate.toDate().isBefore(oneDayLess) ||
                    oneDayLess.isAtSameMomentAs(DateTime.utc(
                        plan.startDate.toDate().year,
                        plan.startDate.toDate().month,
                        plan.startDate.toDate().day))))) ||
            // today
            ((plan.endDate.toDate().isAfter(curr) || curr.isAtSameMomentAs(DateTime.utc(plan.endDate.toDate().year, plan.endDate.toDate().month, plan.endDate.toDate().day))) &&
                ((plan.startDate.toDate().isBefore(curr) ||
                    curr.isAtSameMomentAs(DateTime.utc(
                        plan.startDate.toDate().year,
                        plan.startDate.toDate().month,
                        plan.startDate.toDate().day))))) ||
            // one day more
            ((plan.endDate.toDate().isAfter(oneDayMore) || oneDayMore.isAtSameMomentAs(DateTime.utc(plan.endDate.toDate().year, plan.endDate.toDate().month, plan.endDate.toDate().day))) &&
                ((plan.startDate.toDate().isBefore(oneDayMore) ||
                    oneDayMore.isAtSameMomentAs(DateTime.utc(
                        plan.startDate.toDate().year,
                        plan.startDate.toDate().month,
                        plan.startDate.toDate().day))))) ||
            // two days more
            ((plan.endDate.toDate().isAfter(twoDaysMore) || twoDaysMore.isAtSameMomentAs(DateTime.utc(plan.endDate.toDate().year, plan.endDate.toDate().month, plan.endDate.toDate().day))) &&
                ((plan.startDate.toDate().isBefore(twoDaysMore) || twoDaysMore.isAtSameMomentAs(DateTime.utc(plan.startDate.toDate().year, plan.startDate.toDate().month, plan.startDate.toDate().day)))))))
        .toList();
    // print('sorted list: ${_selectedList.length}');
    yield state.update(
      detailListShort: _selectedList,
    );
  }
}
