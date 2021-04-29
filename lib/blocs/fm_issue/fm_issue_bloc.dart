import 'package:BrandFarm/blocs/fm_issue/fm_issue_event.dart';
import 'package:BrandFarm/blocs/fm_issue/fm_issue_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/comment/comment_repository.dart';
import 'package:BrandFarm/repository/fm_issue/fm_issue_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMIssueBloc extends Bloc<FMIssueEvent, FMIssueState> {
  FMIssueBloc() : super(FMIssueState.empty());

  @override
  Stream<FMIssueState> mapEventToState(FMIssueEvent event) async* {
    if (event is LoadFMIssueList) {
      yield* _mapLoadFMIssueListToState();
    } else if (event is GetIssueList) {
      yield* _mapGetIssueListToState(event.field);
    } else if (event is SetIssYear) {
      yield* _mapSetIssYearToState(event.year);
    } else if (event is SetIssMonth) {
      yield* _mapSetIssMonthToState(event.month);
    } else if (event is GetDetailUserInfo) {
      yield* _mapGetDetailUserInfoToState(event.sfmid);
    } else if (event is CheckAsRead) {
      yield* _mapCheckAsReadToState(event.obj, event.index, event.order);
    } else if (event is GetCommentList) {
      yield* _mapGetCommentListToState(event.obj);
    } else if (event is ChangeExpandState) {
      yield* _mapChangeExpandStateToState(event.index);
    } else if (event is WriteComment) {
      yield* _mapWriteCommentToState(event.cmt, event.obj);
    } else if (event is ChangeWriteReplyState) {
      yield* _mapChangeWriteReplyStateToState(event.index);
    } else if (event is WriteReply) {
      yield* _mapWriteReplyToState(event.cmt, event.obj, event.index);
    }
  }

  Stream<FMIssueState> _mapLoadFMIssueListToState() async* {
    // loading
    yield state.update(isLoading: true);
  }

  Stream<FMIssueState> _mapGetIssueListToState(Field field) async* {
    // get list
    int year = int.parse(state.year);
    int month = int.parse(state.month);
    DateTime firstDay = DateTime(year, month, 1);
    DateTime lastDay = DateTime(year, month + 1, 0);
    Timestamp fDay = Timestamp.fromDate(firstDay);
    Timestamp lDay = Timestamp.fromDate(lastDay);

    List<SubJournalIssue> issueList =
        await FMIssueRepository().getIssueList(field.fid, fDay, lDay);

    List<SubJournalIssue> reverseList = List.from(issueList.reversed);

    List<ImagePicture> pictureList = await FMIssueRepository().getImage(field);

    yield state.update(
      isLoading: false,
      issueList: issueList,
      reverseList: reverseList,
      imageList: pictureList,
    );
  }

  Stream<FMIssueState> _mapSetIssYearToState(String year) async* {
    // year
    yield state.update(year: year);
  }

  Stream<FMIssueState> _mapSetIssMonthToState(String month) async* {
    // month
    yield state.update(month: month);
  }

  Stream<FMIssueState> _mapGetDetailUserInfoToState(String sfmid) async* {
    // get info of issue writer
    User detailUser = await FMIssueRepository().getDetailUserInfo(sfmid);
    yield state.update(detailUser: detailUser);
  }

  Stream<FMIssueState> _mapCheckAsReadToState(
      SubJournalIssue obj, int index, String order) async* {
    // check as read
    List<SubJournalIssue> ModifiedList = [];
    (order == '최신 순') ? ModifiedList = state.issueList : ModifiedList = state.reverseList;

    SubJournalIssue _obj = SubJournalIssue(
      date: obj.date,
      fid: obj.fid,
      fieldCategory: obj.fieldCategory,
      sfmid: obj.sfmid,
      issid: obj.issid,
      uid: obj.uid,
      title: obj.title,
      category: obj.category,
      issueState: obj.issueState,
      contents: obj.contents,
      comments: obj.comments,
      isReadByFM: true,
      isReadByOffice: obj.isReadByOffice,
    );

    ModifiedList.removeAt(index);
    ModifiedList.insert(index, _obj);

    FMIssueRepository().updateIssue(obj: _obj);

    if(order == '최신 순') {
      yield state.update(issueList: ModifiedList);
    } else {
      yield state.update(reverseList: ModifiedList);
    }
  }

  Stream<FMIssueState> _mapGetCommentListToState(SubJournalIssue obj) async* {
    // get comment / sub comment
    List<Comment> cmt = await FMIssueRepository().getComment(obj.issid);
    List<SubComment> scmt = await FMIssueRepository().getSubComment(obj.issid);

    yield state.update(
      commentList: cmt,
      subCommentList: scmt,
    );
  }

  Stream<FMIssueState> _mapChangeExpandStateToState(int index) async* {
    // comment expand state
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

  Stream<FMIssueState> _mapWriteCommentToState(String cmt, SubJournalIssue obj) async* {
    // write comment
    List<Comment> cmtList = state.commentList;
    String cmtid = '';
    cmtid = FirebaseFirestore.instance.collection('Comment').doc().id;
    Comment _cmt = Comment(
      date: Timestamp.now(),
      jid: '--',
      uid: UserUtil.getUser().uid,
      issid: obj.issid,
      cmtid: cmtid,
      name: UserUtil.getUser().name,
      comment: cmt,
      isThereSubComment: false,
      isExpanded: false,
      fid: obj.fid,
      imgUrl: UserUtil.getUser().imgUrl,
      isWriteSubCommentClicked: false,
      isReadByFM: true,
      isReadByOM: false,
      isReadBySFM: false,
    );

    cmtList.add(_cmt);

    // CommentRepository().uploadComment(comment: _cmt);

    // update issuelist
    List<SubJournalIssue> issueList = state.issueList;
    List<SubJournalIssue> reverseList = state.reverseList;
    SubJournalIssue _issue = SubJournalIssue(
      date: obj.date,
      fid: obj.fid,
      fieldCategory: obj.fieldCategory,
      sfmid: obj.sfmid,
      issid: obj.issid,
      uid: obj.uid,
      title: obj.title,
      category: obj.category,
      issueState: obj.issueState,
      contents: obj.contents,
      comments: obj.comments + 1,
      isReadByFM: obj.isReadByFM,
      isReadByOffice: obj.isReadByOffice,
    );

    int index1 = issueList.indexWhere((data) => data.issid == obj.issid) ?? -1;
    int index2 = reverseList.indexWhere((data) => data.issid == obj.issid) ?? -1;

    if (index1 != -1) {
      issueList.removeAt(index1);
      issueList.insert(index1, _issue);
    }
    if (index2 != -1) {
      reverseList.removeAt(index2);
      reverseList.insert(index2, _issue);
    }

    CommentRepository().uploadComment(comment: _cmt);
    FMIssueRepository().updateIssueComment(issid: obj.issid, cmts: obj.comments + 1);

    yield state.update(
        commentList: cmtList,
      issueList: issueList,
      reverseList: reverseList,
    );
  }

  Stream<FMIssueState> _mapChangeWriteReplyStateToState(int index) async* {
    // change write reply state
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

  Stream<FMIssueState> _mapWriteReplyToState(String cmt, SubJournalIssue obj, int index) async* {
    // change reply state
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
      issid: obj.issid,
      jid: '--',
      scmtid: scmtid,
      cmtid: cmtObj.cmtid,
      scomment: cmt,
      imgUrl: UserUtil.getUser().imgUrl,
      fid: obj.fid,
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
}
