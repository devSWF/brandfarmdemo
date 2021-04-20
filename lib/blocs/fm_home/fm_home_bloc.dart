import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/repository/fm_home/fm_home_repository.dart';
import 'package:bloc/bloc.dart';

class FMHomeBloc extends Bloc<FMHomeEvent, FMHomeState> {
  FMHomeBloc() : super(FMHomeState.empty());

  @override
  Stream<FMHomeState> mapEventToState(FMHomeEvent event) async* {
    if (event is LoadFMHome) {
      yield* _mapLoadFMHomeToState();
    } else if (event is SetPageIndex) {
      yield* _mapSetPageIndexToState(event.index);
    } else if (event is SetSubPageIndex) {
      yield* _mapSetSubPageIndexToState(event.index);
    } else if (event is SetSelectedIndex) {
      yield* _mapSetSelectedIndexToState(event.index);
    } else if (event is GetRecentUpdates) {
      yield* _mapGetRecentUpdatesToState();
    }
  }

  Stream<FMHomeState> _mapLoadFMHomeToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMHomeState> _mapSetPageIndexToState(int index) async* {
    yield state.update(pageIndex: index);
  }

  Stream<FMHomeState> _mapSetSubPageIndexToState(int index) async* {
    yield state.update(subPageIndex: index);
  }

  Stream<FMHomeState> _mapSetSelectedIndexToState(int index) async* {
    yield state.update(selectedIndex: index);
  }

  Stream<FMHomeState> _mapGetRecentUpdatesToState() async* {
    List<FMHomeRecentUpdates> updateList = [];
    List<NotificationNotice> notice = await FMHomeRepository().getRecentNoticeList(state.farm.farmID);
    List<FMPlan> plan = await FMHomeRepository().getRecentPlanList(state.farm.farmID);
    List<FMPurchase> purchase = await FMHomeRepository().getRecentPurchaseList(state.farm.farmID);
    List<Journal> journal = await FMHomeRepository().getRecentJournalList(state.farm.fieldCategory);
    List<SubJournalIssue> issue = await FMHomeRepository().getRecentIssueList(state.farm.fieldCategory);
    // List<Comment> comment = await FMHomeRepository().getRecentCommentList();
    // List<SubComment> subComment = await FMHomeRepository().getRecentSubCommentList();

    yield state.update(
      recentUpdateList: updateList,
    );
  }
}
