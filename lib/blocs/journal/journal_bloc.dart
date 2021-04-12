import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/repository/sub_journal/sub_journal_repository.dart';
import 'package:BrandFarm/utils/issue/issue_util.dart';
import 'package:BrandFarm/utils/journal/journal_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../utils/user/user_util.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc() : super(JournalState.empty());

  DateTime now = DateTime.now();

  @override
  Stream<JournalState> mapEventToState(JournalEvent event) async* {
    if (event is LoadJournal) {
      yield* _mapLoadJournalToState();
    } else if (event is LoadJournalDetail) {
      yield* _mapLoadJournalDetailToState();
    } else if (event is JournalDetailLoaded) {
      yield* _mapJournalDetailLoadedToState();
    } else if (event is GetInitialList) {
      yield* _mapGetInitialListToState();
    }else if (event is GetListBySelectedDate) {
      yield* _mapGetListBySelectedDateToState(
          month: event.month, year: event.year);
    } else if (event is LoadMore) {
      yield* _mapLoadMoretToState(tab: event.tab);
    } else if (event is GetIssueListByTimeOrder) {
      yield* _mapGetIssueListByTimeOrderToState(
          issueListOption: event.issueListOption,
          issueListOrderOption: event.issueListOrderOption);
    } else if (event is GetIssueListByCategory) {
      yield* _mapGetIssueListByCategoryToState(issueState: event.issueState);
    } else if (event is WaitForLoadMore) {
      yield* _mapWaitForLoadMoreToState();
    } else if (event is AddIssueComment) {
      yield* _mapAddIssueCommentToState(
        issid: event.id,
      );
    } else if (event is AddJournalComment) {
      yield* _mapAddJournalCommentToState(
        jid: event.id,
      );
    } else if (event is PassSelectedJournal){
      yield* _mapPassSelectedJournalToState(event.journal);
    } else if (event is PassSelectedIssue){
      yield* _mapPassSelectedIssueToState(event.issue);
    }
  }

  Stream<JournalState> _mapLoadJournalToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<JournalState> _mapLoadJournalDetailToState() async* {
    yield state.update(isDetailLoading: true);
  }

  Stream<JournalState> _mapJournalDetailLoadedToState() async* {
    yield state.update(isDetailLoading: false);
  }

  Stream<JournalState> _mapGetInitialListToState() async* {
    List<Journal> orderByRecent = [];
    List<Journal> orderByOldest = [];
    List<SubJournalIssue> issueList = [];
    List<SubJournalIssue> reverseIssueList = [];
    List<ImagePicture> imageList = [];

    // get journal list
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    orderByRecent = await SubJournalRepository().getJournal();
    orderByOldest = List.from(orderByRecent.reversed);

    /// get issue list
    issueList = await SubJournalRepository().getIssue();
    reverseIssueList = List.from(issueList.reversed);

    /// get image
    imageList = await SubJournalRepository().getImage();

    yield state.update(
      isLoading: false,
      orderByOldest: orderByOldest,
      orderByRecent: orderByRecent,
      issueList: issueList,
      reverseIssueList: reverseIssueList,
      imageList: imageList,
    );
  }

  Stream<JournalState> _mapGetListBySelectedDateToState(
      {String month, String year}) async* {
    List<Journal> listBySelection = [];
    List<Journal> fromExistingList = state.orderByRecent;

    listBySelection = fromExistingList
        .where((element) =>
            DateFormat('yyyy-MM').format(DateTime.fromMicrosecondsSinceEpoch(
                element.date.microsecondsSinceEpoch)) ==
            '${year}-${month}')
        .toList();

    yield state.update(
      isLoading: false,
      listBySelection: listBySelection,
    );
  }

  Stream<JournalState> _mapGetIssueListByTimeOrderToState(
      {String issueListOption, String issueListOrderOption}) async* {
    List<SubJournalIssue> reverseIssueList = [];

    if (issueListOption == '전체') {
      reverseIssueList = state.issueList;
      reverseIssueList = List.from(reverseIssueList.reversed);
    } else {
      reverseIssueList = state.issueListByCategorySelection;
      reverseIssueList = List.from(reverseIssueList.reversed);
    }

    yield state.update(
      isLoading: false,
      reverseIssueList: reverseIssueList,
    );
  }

  Stream<JournalState> _mapGetIssueListByCategoryToState(
      {int issueState}) async* {
    List<SubJournalIssue> issueListByCategorySelection = [];

    // print(issueState);

    issueListByCategorySelection = state.issueList.where((element) {
      // print(element.issueState);
      return element.issueState == issueState;
    }).toList();

    // issueListByCategorySelection.forEach((element) => print(element.title));

    yield state.update(
      isLoading: false,
      issueListByCategorySelection: issueListByCategorySelection,
    );
  }

  Stream<JournalState> _mapLoadMoretToState({int tab}) async* {
    List<Journal> currentJournalList = [];
    List<SubJournalIssue> currentIssueList = [];
    List<Journal> newJournalList = [];
    List<SubJournalIssue> newIssueList = [];
    List<ImagePicture> currentImageList = [];
    List<ImagePicture> newImageList = [];
    List<Journal> combinedJournalList = [];
    List<SubJournalIssue> combinedIssueList = [];
    List<ImagePicture> combinedImageList = [];
    List<Journal> reverseJournalList = [];
    List<SubJournalIssue> reverseIssueList = [];

    if (tab == 0) {
      currentJournalList = state.orderByRecent;
      currentImageList = state.imageList;
      int length1 = state.orderByRecent.length - 1;
      int length2 = state.imageList.length - 1;

      QuerySnapshot _issue = await FirebaseFirestore.instance
          .collection('Issue')
          .where('uid', isEqualTo: UserUtil.getUser().uid)
          .where('date', isLessThan: state.issueList[length1].date)
          .orderBy('date', descending: true)
          .limit(20)
          .get();

      _issue.docs.forEach((ds) {
        newJournalList.add(Journal.fromDs(ds));
      });

      QuerySnapshot pic = await FirebaseFirestore.instance
          .collection('Picture')
          .where('uid', isEqualTo: UserUtil.getUser().uid)
          .where('dttm', isLessThan: state.imageList[length2].dttm)
          .orderBy('dttm', descending: true)
          .limit(20)
          .get();
      pic.docs.forEach((ds) {
        newImageList.add(ImagePicture.fromSnapshot(ds));
      });

      combinedJournalList = [...currentJournalList, ...newJournalList];
      combinedImageList = [...currentImageList, ...newImageList];
      reverseJournalList = List.from(combinedJournalList.reversed);

      yield state.update(
        isLoadingToGetMore: false,
        orderByRecent: combinedJournalList,
        imageList: combinedImageList,
        orderByOldest: reverseJournalList,
      );
    } else {
      currentIssueList = state.issueList;
      currentImageList = state.imageList;
      int length1 = state.issueList.length - 1;
      int length2 = state.imageList.length - 1;

      QuerySnapshot _issue = await FirebaseFirestore.instance
          .collection('Issue')
          .where('uid', isEqualTo: UserUtil.getUser().uid)
          .where('date', isLessThan: state.issueList[length1].date)
          .orderBy('date', descending: true)
          .limit(20)
          .get();

      _issue.docs.forEach((ds) {
        newIssueList.add(SubJournalIssue.fromSnapshot(ds));
      });

      QuerySnapshot pic = await FirebaseFirestore.instance
          .collection('Picture')
          .where('uid', isEqualTo: UserUtil.getUser().uid)
          .where('dttm', isLessThan: state.imageList[length2].dttm)
          .orderBy('dttm', descending: true)
          .limit(20)
          .get();
      pic.docs.forEach((ds) {
        newImageList.add(ImagePicture.fromSnapshot(ds));
      });

      combinedIssueList = [...currentIssueList, ...newIssueList];
      combinedImageList = [...currentImageList, ...newImageList];
      reverseIssueList = List.from(combinedIssueList.reversed);

      // for (int i = combinedList.length - 1; i >= 0; i--) {
      //   reverseList.add(combinedList[i]);
      // }

      yield state.update(
        isLoadingToGetMore: false,
        issueList: combinedIssueList,
        imageList: combinedImageList,
        reverseIssueList: reverseIssueList,
      );
    }
  }

  Stream<JournalState> _mapWaitForLoadMoreToState() async* {
    yield state.update(isLoadingToGetMore: true);
  }

  Stream<JournalState> _mapAddIssueCommentToState({String issid}) async* {
    List<SubJournalIssue> issue = state.issueList;
    List<SubJournalIssue> cat = state.issueListByCategorySelection;
    List<SubJournalIssue> rev = state.reverseIssueList;

    int index1 = issue.indexWhere((data) => data.issid == issid) ?? -1;
    int index2 = cat.indexWhere((data) => data.issid == issid) ?? -1;
    int index3 = rev.indexWhere((data) => data.issid == issid) ?? -1;

    await SubJournalRepository()
        .updateIssueComment(issid: issid, cmts: issue[index1].comments + 1);

    await IssueUtil.setIssue(SubJournalIssue(
      category: issue[index1].category,
      comments: issue[index1].comments + 1,
      contents: issue[index1].contents,
      date: issue[index1].date,
      fid: issue[index1].fid,
      uid: issue[index1].uid,
      sfmid: issue[index1].sfmid,
      issid: issue[index1].issid,
      title: issue[index1].title,
      issueState: issue[index1].issueState,
      isReadByFM: issue[index1].isReadByFM,
      isReadByOffice: issue[index1].isReadByOffice,
    ));

    if (index1 != -1) {
      issue.removeAt(index1);
      issue.insert(index1, await IssueUtil.getIssue());
    }
    if (index2 != -1) {
      cat.removeAt(index2);
      cat.insert(index2, await IssueUtil.getIssue());
    }
    if (index3 != -1) {
      rev.removeAt(index3);
      rev.insert(index3, await IssueUtil.getIssue());
    }

    yield state.update(
      issueList: issue,
      issueListByCategorySelection: cat,
      reverseIssueList: rev,
    );
  }

  Stream<JournalState> _mapAddJournalCommentToState(
      {String jid}) async* {
    List<Journal> journal = state.orderByRecent;
    List<Journal> cat = state.listBySelection;
    List<Journal> rev = state.orderByOldest;

    int index1 = journal.indexWhere((data) => data.jid == jid) ?? -1;
    int index2 = cat.indexWhere((data) => data.jid == jid) ?? -1;
    int index3 = rev.indexWhere((data) => data.jid == jid) ?? -1;

    await SubJournalRepository()
        .updateJournalComment(jid: jid, cmts: journal[index1].comments + 1);

    await JournalUtil.setJournal(Journal(
      planting: journal[index1].planting,
      pest: journal[index1].pest,
      weeding: journal[index1].weeding,
      pesticide: journal[index1].pesticide,
      uid: journal[index1].uid,
      comments: journal[index1].comments +1,
      date: journal[index1].date,
      title: journal[index1].title,
      farming: journal[index1].farming,
      jid: journal[index1].jid,
      fid: journal[index1].fid,
      fertilize: journal[index1].fertilize,
      content: journal[index1].content,
      workforce: journal[index1].workforce,
      seeding: journal[index1].seeding,
      shipment: journal[index1].shipment,
      widgetList: journal[index1].widgetList,
      widgets: journal[index1].widgets,
      watering: journal[index1].watering,
    ));

    if (index1 != -1) {
      journal.removeAt(index1);
      journal.insert(index1, await JournalUtil.getJournal());
    }
    if (index2 != -1) {
      cat.removeAt(index2);
      cat.insert(index2, await JournalUtil.getJournal());
    }
    if (index3 != -1) {
      rev.removeAt(index3);
      rev.insert(index3, await JournalUtil.getJournal());
    }

    yield state.update(
      orderByRecent: journal,
      listBySelection: cat,
      orderByOldest: rev,
    );
  }

  Stream<JournalState> _mapPassSelectedJournalToState(Journal journal) async*{
    yield state.update(selectedJournal: journal);
  }

  Stream<JournalState> _mapPassSelectedIssueToState(SubJournalIssue issue) async*{
    yield state.update(selectedIssue: issue);
  }

}
