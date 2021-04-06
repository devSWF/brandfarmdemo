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
    } else if (event is GetSortedDetailList) {
      yield* _mapGetSortedDetailListToState();
    } else if (event is SetCalendarIndex) {
      yield* _mapSetCalendarIndexToState(event.index);
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
    List<DateTime> dList = [twoDaysLess, oneDayLess, curr, oneDayMore, twoDaysMore,];
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
    // _selectedList.forEach((element) {
    //   print('start: ${element.startDate.toDate()} // end: ${element.endDate.toDate()}');
    // });

    // divide period to days
    List<CalendarPlan> cpList = [];
    for(int i = 0; i < _selectedList.length; i++) {
      int period = (_selectedList[i].endDate.toDate().isAtSameMomentAs(_selectedList[i].startDate.toDate()))
          ? 1 : _selectedList[i].endDate.toDate().difference(_selectedList[i].startDate.toDate()).inDays + 1;
      // print('period: ${period}');
      for(int j = 0; j < period; j++) {
        int year = _selectedList[i].startDate.toDate().year;
        int month = _selectedList[i].startDate.toDate().month;
        int day = _selectedList[i].startDate.toDate().day;
        CalendarPlan cp = CalendarPlan(
          date: DateTime(year, month, day + j),
          title: _selectedList[i].title,
          content: _selectedList[i].content,
          farmID: _selectedList[i].farmID,
          fid: _selectedList[i].fid,
          planID: _selectedList[i].planID,
        );
        // if(cpList.isNotEmpty) {
        //   cpList.add(cp);
        // } else {
        //   cpList.insert(0, cp);
        // }
        if((cp.date.isAfter(DateTime(twoDaysLess.year, twoDaysLess.month, twoDaysLess.day - 1)))
            && (cp.date.isBefore(twoDaysMore))){
          if(cpList.isNotEmpty) {
            cpList.add(cp);
          } else {
            cpList.insert(0, cp);
          }
        } else {
          print('date is not within range');
        }
      }
    }

    // cpList.forEach((element) {print('${element.date}');});

    yield state.update(
      detailListShort: cpList,
      fmHomeCalendarDateList: dList,
      todoPlanListShort: _selectedList,
    );
  }

  Stream<FMPlanState> _mapGetSortedDetailListToState() async* {
    // get sorted detail list
    // sort list by field id
    List<List<CalendarPlan>> listByField =
    List.generate(state.fieldList.length, (col) {
      List<CalendarPlan> cpList = state.detailListShort.where((element) {
        if (col == 0) {
          return element.farmID == state.farm.farmID && element.fid.isEmpty;
        } else {
          return element.fid == state.fieldList[col].fid;
        }
      }).toList();
      // print('fieldList ${col} : ${cpList.length}');
      return cpList;
    });
    // print('list by field : ${listByField.length}');

    // sort list by date
    List<List<List<CalendarPlan>>> listByDate = List.generate(state.fmHomeCalendarDateList.length, (row) {
      List<List<CalendarPlan>> fieldList = List.generate(listByField.length, (col) {
        List<CalendarPlan> dateList = [];
        for(int i = 0; i < listByField[col].length; i++) {
          if(listByField[col][i].date.year == state.fmHomeCalendarDateList[row].year
          && listByField[col][i].date.month == state.fmHomeCalendarDateList[row].month
          && listByField[col][i].date.day == state.fmHomeCalendarDateList[row].day) {
            if(dateList.isEmpty) {
              dateList.insert(0, listByField[col][i]);
            } else {
              dateList.add(listByField[col][i]);
            }
          }
        }
        // print('listByDate: ${row} // ListbyField: ${col} // dateList: ${dateList.length}');
        return dateList;
      });
      // print('field list : ${fieldList.length}');
      return fieldList;
    });

    yield state.update(
      sortedList: listByDate,
    );
  }

  Stream<FMPlanState> _mapSetCalendarIndexToState(int index) async* {
    // set selected index
    yield state.update(
      selectedIndex: index,
    );
  }
}
