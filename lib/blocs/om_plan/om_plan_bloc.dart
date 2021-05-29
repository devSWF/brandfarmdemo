import 'package:BrandFarm/blocs/om_plan/om_plan_event.dart';
import 'package:BrandFarm/blocs/om_plan/om_plan_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/repository/om_plan/om_plan_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OMPlanBloc extends Bloc<OMPlanEvent, OMPlanState> {
  OMPlanBloc() : super(OMPlanState.empty());

  @override
  Stream<OMPlanState> mapEventToState(OMPlanEvent event) async* {
    if (event is LoadOMPlan) {
      yield* _mapLoadOMPlanToState();
    } else if (event is GetFarmListForOMPlan) {
      yield* _mapGetFarmListForOMPlanToState();
    } else if (event is GetPlanList) {
      yield* _mapGetPlanListToState();
    } else if (event is PostNewPlan) {
      yield* _mapPostNewPlanToState();
    } else if (event is SetDate) {
      yield* _mapSetDateToState(event.date);
    } else if (event is SetSelectedFarm) {
      yield* _mapSetSelectedFarmToState(event.selectedFarm);
    } else if (event is SetStartDate) {
      yield* _mapSetStartDateToState(event.startDate);
    } else if (event is SetEndDate) {
      yield* _mapSetEndDateToState(event.endDate);
    } else if (event is SetWaitingPlan) {
      yield* _mapSetWaitingPlanToState(event.wPlan);
    } else if (event is CheckConfirmState) {
      yield* _mapCheckConfirmStateToState(event.confirmState);
    } else if (event is SetCalendarIndex) {
      yield* _mapSetCalendarIndexToState(event.index);
    }
  }

  Stream<OMPlanState> _mapLoadOMPlanToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<OMPlanState> _mapGetFarmListForOMPlanToState() async* {
    List<Farm> tmp = await OMPlanRepository().getFarmList();
    List<Farm> first = [];
    first.add(Farm(
        farmID: '',
        fieldCategory: '',
        managerID: '',
        officeNum: 1,
        name: '전체일정'));

    yield state.update(
      farm: first[0],
      farmList: [...first, ...tmp],
    );
  }

  Stream<OMPlanState> _mapGetPlanListToState() async* {
    // get plan list
    List<OMPlan> plist = [];
    plist = await OMPlanRepository().getOPlanList();

    yield state.update(
      planList: plist,
    );
  }

  Stream<OMPlanState> _mapPostNewPlanToState() async* {
    // post new plan
    String planID = '';
    planID = FirebaseFirestore.instance.collection('OMPlan').doc().id;
    OMPlan newPlan = OMPlan(
      planID: planID,
      uid: UserUtil.getUser().uid,
      startDate: Timestamp.fromDate(state.wPlan.startDate),
      endDate: Timestamp.fromDate(state.wPlan.endDate),
      postedDate: Timestamp.now(),
      title: state.wPlan.title,
      content: state.wPlan.content,
      isReadByFM: false,
      isReadByOffice: true,
      isReadBySFM: false,
      from: 1, // 1 : office, 2 : FM
      farmID: (state.wPlan.selectedFarmIndex > 0)
          ? state.farmList[state.wPlan.selectedFarmIndex].farmID
          : '',
      officeNum: 1,
      isUpdated: true,
    );

    OMPlanRepository().postPlan(newPlan);

    List<OMPlan> plist = state.planList;
    if (plist.isEmpty) {
      plist.insert(0, newPlan);
    } else {
      plist.add(newPlan);
    }

    yield state.update(
      planList: plist,
      newPlan: newPlan,
    );
  }

  Stream<OMPlanState> _mapSetDateToState(DateTime date) async* {
    // set date and show detail plan
    print('//////////////////${date}');
    List<OMPlan> detailList = [];
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

  Stream<OMPlanState> _mapSetSelectedFarmToState(int selectedFarm) async* {
    // set selected field
    yield state.update(
      selectedFarm: selectedFarm,
    );
  }

  Stream<OMPlanState> _mapSetStartDateToState(DateTime start) async* {
    // set start date
    yield state.update(
      startDate: start,
    );
  }

  Stream<OMPlanState> _mapSetEndDateToState(DateTime end) async* {
    // set end date
    yield state.update(
      endDate: end,
    );
  }

  Stream<OMPlanState> _mapSetWaitingPlanToState(
      OMWaitingConfirmation wPlan) async* {
    // wait for post confirmation
    yield state.update(
      wPlan: wPlan,
    );
  }

  Stream<OMPlanState> _mapCheckConfirmStateToState(bool cState) async* {
    // check if confirm button is pressed
    yield state.update(
      isConfirmed: cState,
    );
  }

  Stream<OMPlanState> _mapSetCalendarIndexToState(int index) async* {
    // set selected index
    yield state.update(
      selectedIndex: index,
    );
  }
}
