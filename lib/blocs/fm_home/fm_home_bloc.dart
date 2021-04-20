import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
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
    } else if (event is GetFieldListForFMHome) {
      yield* _mapGetFieldListForFMHomeToState();
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

  Stream<FMHomeState> _mapGetFieldListForFMHomeToState() async* {
    Farm farm = await FMHomeRepository().getFarmInfo();
    List<Field> fieldList = await FMHomeRepository().getFieldList(farm.fieldCategory);

    yield state.update(
      farm: farm,
      fieldList: fieldList,
    );
  }

  Stream<FMHomeState> _mapGetRecentUpdatesToState() async* {
    List<FMHomeRecentUpdates> updateList = [];
    List<FMHomeRecentUpdates> noticeList = [];
    List<FMHomeRecentUpdates> planList = [];
    List<FMHomeRecentUpdates> purchaseList = [];
    List<FMHomeRecentUpdates> journalList = [];
    List<FMHomeRecentUpdates> issueList = [];
    // List<FMHomeRecentUpdates> commentList = [];
    // List<FMHomeRecentUpdates> subCommentList = [];
    List<NotificationNotice> notice = await FMHomeRepository().getRecentNoticeList(state.farm.farmID);
    List<FMPlan> plan = await FMHomeRepository().getRecentPlanList(state.farm.farmID);
    List<FMPurchase> purchase = await FMHomeRepository().getRecentPurchaseList(state.farm.farmID);
    List<Journal> journal = await FMHomeRepository().getRecentJournalList(state.farm.fieldCategory);
    List<SubJournalIssue> issue = await FMHomeRepository().getRecentIssueList(state.farm.fieldCategory);
    // List<Comment> comment = await FMHomeRepository().getRecentCommentList(state.farm.fieldCategory);
    // List<SubComment> subComment = await FMHomeRepository().getRecentSubCommentList(state.farm.fieldCategory);

    notice.asMap().forEach((index, element) {
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          date: element.postedDate,
          plan: null,
          notice: element,
          purchase: null,
          journal: null,
          issue: null,
          comment: null,
          subComment: null
      );
      if(index > 0) {
        noticeList.insert(0, obj);
      } else {
        noticeList.add(obj);
      }
    });

    plan.asMap().forEach((index, element) {
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          date: element.postedDate,
          plan: element,
          notice: null,
          purchase: null,
          journal: null,
          issue: null,
          comment: null,
          subComment: null
      );
      if(index > 0) {
        planList.insert(0, obj);
      } else {
        planList.add(obj);
      }
    });

    purchase.asMap().forEach((index, element) {
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          date: element.requestDate,
          plan: null,
          notice: null,
          purchase: element,
          journal: null,
          issue: null,
          comment: null,
          subComment: null
      );
      if(index > 0) {
        purchaseList.insert(0, obj);
      } else {
        purchaseList.add(obj);
      }
    });

    journal.asMap().forEach((index, element) {
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          date: element.date,
          plan: null,
          notice: null,
          purchase: null,
          journal: element,
          issue: null,
          comment: null,
          subComment: null
      );
      if(index > 0) {
        journalList.insert(0, obj);
      } else {
        journalList.add(obj);
      }
    });

    issue.asMap().forEach((index, element) {
      FMHomeRecentUpdates obj = FMHomeRecentUpdates(
          date: element.date,
          plan: null,
          notice: null,
          purchase: null,
          journal: null,
          issue: element,
          comment: null,
          subComment: null
      );
      if(index > 0) {
        issueList.insert(0, obj);
      } else {
        issueList.add(obj);
      }
    });

    updateList = [...noticeList, ...planList, ...purchaseList, ...journalList, ...issueList];
    updateList.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    updateList = List.from(updateList.reversed);

    // updateList.forEach((element) {
    //   print('${element.date.toDate()}');
    // });

    yield state.update(
      recentUpdateList: updateList,
    );
  }
}
