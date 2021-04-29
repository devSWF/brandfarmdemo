import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/comment/comment_repository.dart';
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
    } else if (event is UpdateReadState) {
      yield* _mapUpdateReadStateToState();
    } else if (event is GetJournalComments) {
      yield* _mapGetJournalCommentsToState();
    } else if (event is GetJournalDetailUserInfo) {
      yield* _mapGetJournalDetailUserInfoToState();
    } else if (event is ChangeJournalWriteReplyState) {
      yield* _mapChangeJournalWriteReplyStateToState(event.index);
    } else if (event is ChangeJournalExpandState) {
      yield* _mapChangeJournalExpandStateToState(event.index);
    } else if (event is WriteJournalReply) {
      yield* _mapWriteJournalReplyToState(event.cmt, event.index);
    } else if (event is WriteJournalComment) {
      yield* _mapWriteJournalCommentToState(event.cmt,);
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

  Stream<FMJournalState> _mapUpdateReadStateToState() async* {
    List<Journal> modifiedList = [];
    List<Journal> reverseList = [];

    Journal _obj = Journal(
        fid: state.journal.fid,
        fieldCategory: state.journal.fieldCategory,
        jid: state.journal.jid,
        uid: state.journal.uid,
        date: state.journal.date,
        title: state.journal.title,
        content: state.journal.content,
        widgets: state.journal.widgets,
        widgetList: state.journal.widgetList,
        comments: state.journal.comments,
        isReadByFM: !state.journal.isReadByFM,
        isReadByOffice: state.journal.isReadByOffice,
        shipment: state.journal.shipment,
        fertilize: state.journal.fertilize,
        pesticide: state.journal.pesticide,
        pest: state.journal.pest,
        planting: state.journal.planting,
        seeding: state.journal.seeding,
        weeding: state.journal.weeding,
        watering: state.journal.watering,
        workforce: state.journal.workforce,
        farming: state.journal.farming,
    );

    int index;

    if(state.order == '최신 순') {
      modifiedList = state.journalList;
      reverseList = state.reverseList;
      modifiedList.removeAt(state.index);
      modifiedList.insert(state.index, _obj);
      index = reverseList.indexWhere((element) =>
      element.jid == modifiedList[state.index].jid);
    } else {
      modifiedList = state.reverseList;
      reverseList = state.journalList;
      modifiedList.removeAt(state.index);
      modifiedList.insert(state.index, _obj);
      index = reverseList.indexWhere((element) =>
      element.jid == modifiedList[state.index].jid);
    }

    reverseList.removeAt(index);
    reverseList.insert(index, _obj);

    FMJournalRepository().updateJournal(journal: _obj);

    if(state.order == '최신 순') {
      yield state.update(
        journal: _obj,
        journalList: modifiedList,
        reverseList: reverseList,
      );
    } else {
      yield state.update(
        journal: _obj,
        reverseList: modifiedList,
        journalList: reverseList,
      );
    }
  }

  Stream<FMJournalState> _mapGetJournalCommentsToState() async* {
    // get comments
    List<Comment> cmt = [];
    List<SubComment> scmt = [];
    if(state.order == '최신 순'){
      cmt = await FMJournalRepository().getComment(state.journalList[state.index].jid);
      scmt = await FMJournalRepository().getSubComment(state.journalList[state.index].jid);
    } else {
      cmt = await FMJournalRepository().getComment(state.reverseList[state.index].jid);
      scmt = await FMJournalRepository().getSubComment(state.reverseList[state.index].jid);
    }

    yield state.update(
      commentList: cmt,
      subCommentList: scmt,
    );
  }

  Stream<FMJournalState> _mapGetJournalDetailUserInfoToState() async* {
    // get user info
    User detailUser = await FMJournalRepository().getDetailUserInfo(state.journal.fid);

    yield state.update(
      detailUser: detailUser,
    );
  }

  Stream<FMJournalState> _mapChangeJournalWriteReplyStateToState(int index) async* {
    Comment obj = state.commentList[index];
    List<Comment> cmt = state.commentList;
    Comment _cmt = Comment(
      date: obj.date,
      name: obj.name,
      uid: obj.uid,
      issid: obj.issid,
      jid: obj.jid,
      cmtid: obj.cmtid,
      comment: obj.comment,
      isThereSubComment: obj.isThereSubComment,
      isExpanded: obj.isExpanded,
      fid: obj.fid,
      imgUrl: obj.imgUrl,
      isWriteSubCommentClicked: !obj.isWriteSubCommentClicked,
      isReadByFM: obj.isReadByFM,
      isReadByOM: obj.isReadByOM,
      isReadBySFM: obj.isReadBySFM,
    );

    cmt.removeAt(index);
    cmt.insert(index, _cmt);

    yield state.update(commentList: cmt);
  }

  Stream<FMJournalState> _mapChangeJournalExpandStateToState(int index) async* {
    Comment obj = state.commentList[index];
    List<Comment> cmt = state.commentList;
    Comment _cmt = Comment(
      date: obj.date,
      name: obj.name,
      uid: obj.uid,
      issid: obj.issid,
      jid: obj.jid,
      cmtid: obj.cmtid,
      comment: obj.comment,
      isThereSubComment: obj.isThereSubComment,
      isExpanded: !obj.isExpanded,
      fid: obj.fid,
      imgUrl: obj.imgUrl,
      isWriteSubCommentClicked: obj.isWriteSubCommentClicked,
      isReadByFM: obj.isReadByFM,
      isReadByOM: obj.isReadByOM,
      isReadBySFM: obj.isReadBySFM,
    );

    cmt.removeAt(index);
    cmt.insert(index, _cmt);

    yield state.update(commentList: cmt);
  }

  Stream<FMJournalState> _mapWriteJournalReplyToState(String cmt, int index) async* {
    Comment cmtObj = state.commentList[index];
    List<Comment> cmtList = state.commentList;
    Comment _cmt = Comment(
      date: cmtObj.date,
      name: cmtObj.name,
      uid: cmtObj.uid,
      issid: cmtObj.issid,
      jid: cmtObj.jid,
      cmtid: cmtObj.cmtid,
      comment: cmtObj.comment,
      isThereSubComment: cmtObj.isThereSubComment,
      isExpanded: cmtObj.isExpanded,
      fid: cmtObj.fid,
      imgUrl: cmtObj.imgUrl,
      isWriteSubCommentClicked: !cmtObj.isWriteSubCommentClicked,
      isReadByFM: cmtObj.isReadByFM,
      isReadByOM: cmtObj.isReadByOM,
      isReadBySFM: cmtObj.isReadBySFM,
    );

    cmtList.removeAt(index);
    cmtList.insert(index, _cmt);

    // write reply
    List<SubComment> scmtList = state.subCommentList;
    String scmtid = '';
    scmtid = FirebaseFirestore.instance.collection('SubComment').doc().id;
    SubComment _scmt = SubComment(
      date: Timestamp.now(),
      name: UserUtil.getUser().name,
      uid: UserUtil.getUser().uid,
      issid: '--',
      jid: state.journal.jid,
      scmtid: scmtid,
      cmtid: cmtObj.cmtid,
      scomment: cmt,
      imgUrl: UserUtil.getUser().imgUrl,
      fid: state.journal.fid,
      isReadByFM: true,
      isReadByOM: false,
      isReadBySFM: false,
    );

    scmtList.add(_scmt);

    CommentRepository().uploadSubComment(scomment: _scmt);

    yield state.update(
      commentList: cmtList,
      subCommentList: scmtList,
    );
  }

  Stream<FMJournalState> _mapWriteJournalCommentToState(String cmt) async* {
    List<Comment> cmtList = state.commentList;
    String cmtid = '';
    cmtid = FirebaseFirestore.instance.collection('Comment').doc().id;
    Comment _cmt = Comment(
      date: Timestamp.now(),
      jid: state.journal.jid,
      uid: UserUtil.getUser().uid,
      issid: '--',
      cmtid: cmtid,
      name: UserUtil.getUser().name,
      comment: cmt,
      isThereSubComment: false,
      isExpanded: false,
      fid: state.journal.fid,
      imgUrl: UserUtil.getUser().imgUrl,
      isWriteSubCommentClicked: false,
      isReadByFM: true,
      isReadByOM: false,
      isReadBySFM: false,
    );

    cmtList.add(_cmt);

    // CommentRepository().uploadComment(comment: _cmt);

    // update issuelist
    List<Journal> journalList = state.journalList;
    List<Journal> reverseList = state.reverseList;
    Journal _jour = Journal(
        fid: state.journal.fid,
        fieldCategory: state.journal.fieldCategory,
        jid: state.journal.jid,
        uid: state.journal.uid,
        date: state.journal.date,
        title: state.journal.title,
        content: state.journal.content,
        widgets: state.journal.widgets,
        widgetList: state.journal.widgetList,
        comments: state.journal.comments + 1,
        isReadByFM: state.journal.isReadByFM,
        isReadByOffice: state.journal.isReadByOffice,
        shipment: state.journal.shipment,
        fertilize: state.journal.fertilize,
        pesticide: state.journal.pesticide,
        pest: state.journal.pest,
        planting: state.journal.planting,
        seeding: state.journal.seeding,
        weeding: state.journal.weeding,
        watering: state.journal.watering,
        workforce: state.journal.workforce,
        farming: state.journal.farming,
    );

    int index1 = journalList.indexWhere((data) => data.jid == state.journal.jid) ?? -1;
    int index2 = reverseList.indexWhere((data) => data.jid == state.journal.jid) ?? -1;

    if (index1 != -1) {
      journalList.removeAt(index1);
      journalList.insert(index1, _jour);
    }
    if (index2 != -1) {
      reverseList.removeAt(index2);
      reverseList.insert(index2, _jour);
    }

    CommentRepository().uploadComment(comment: _cmt);
    FMJournalRepository().updateJournalComment(jid: state.journal.jid, cmts: state.journal.comments + 1);

    yield state.update(
      commentList: cmtList,
      journalList: journalList,
      reverseList: reverseList,
    );
  }
}
