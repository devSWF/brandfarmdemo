import 'package:BrandFarm/blocs/home/bloc.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/repository/sub_home/sub_home_repository.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc() : super(HomeState.empty());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async*{
    if(event is NextMonthClicked){
      yield* _mapNextMonthClickedToState();
    } else if(event is PrevMonthClicked){
      yield* _mapPrevMonthClickedToState();
    } else if(event is DateClicked){
      yield* _mapDateClickedToState(event.SelectedDay);
    } else if(event is BottomNavBarClicked){
      yield* _mapBottomNavBarClickedToState(event.index);
    } else if(event is GetHomePlanList){
      yield* _mapGetHomePlanListToState();
    } else if(event is SortPlanList){
      yield* _mapSortPlanListToState();
    }
  }

  Stream<HomeState> _mapNextMonthClickedToState() async*{
    if(state.selectedMonth==12){
      yield state.update(monthState: 1, yearState: state.selectedYear+1, dayState: 1);
    }else{
      yield state.update(monthState: state.selectedMonth+1, dayState: 1);
    }
  }

  Stream<HomeState> _mapPrevMonthClickedToState() async*{
    if(state.selectedMonth==1){
      yield state.update(monthState: 12, yearState: state.selectedYear-1, dayState: 1);
    }else{
      yield state.update(monthState: state.selectedMonth-1, dayState: 1);
    }
  }

  Stream<HomeState> _mapDateClickedToState(int SelectedDay) async*{
    yield state.update(dayState: SelectedDay);
  }

  Stream<HomeState> _mapBottomNavBarClickedToState(int index) async*{
    yield state.update(currentIndex: index);
  }

  Stream<HomeState> _mapGetHomePlanListToState() async*{
    List<FMPlan> plist = [];
    plist = await SubHomeRepository().getPlanList(FieldUtil.getField().fid);
    yield state.update(
      planListFromDB: plist,
    );
  }

  Stream<HomeState> _mapSortPlanListToState() async*{
    List<FMPlan> plist = state.planListFromDB;
    List<CalendarPlan> sortedlist = [];
    List<CalendarPlan> tmplist = [];

    if(plist.length > 0) {
      for(int i = 0; i < plist.length; i++) {
        int period = (plist[i].endDate.toDate().isAtSameMomentAs(plist[i].startDate.toDate()))
            ? 1 : plist[i].endDate.toDate().difference(plist[i].startDate.toDate()).inDays + 1;
        // print('period: ${period}');
        for(int j = 0; j < period; j++) {
          int year = plist[i].startDate.toDate().year;
          int month = plist[i].startDate.toDate().month;
          int day = plist[i].startDate.toDate().day;

          CalendarPlan cp = CalendarPlan(
            date: DateTime(year, month, day + j),
            title: plist[i].title,
            content: plist[i].content,
            farmID: plist[i].farmID,
            fid: plist[i].fid,
            planID: plist[i].planID,
          );

          if(tmplist.length > 0) {
            tmplist.add(cp);
          } else {
            tmplist.insert(0, cp);
          }
        }
      }
    }

    if(tmplist.length > 0) {
      tmplist.sort((a,b) => a.date.compareTo(b.date));
      sortedlist = List.from(tmplist);
    }

    yield state.update(
      planList: sortedlist,
    );
  }
}