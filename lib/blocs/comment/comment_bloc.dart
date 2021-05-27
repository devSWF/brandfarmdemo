import 'package:BrandFarm/blocs/comment/bloc.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/comment/comment_repository.dart';
import 'package:BrandFarm/utils/comment/comment_util.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentState.empty());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is LoadComment) {
      yield* _mapLoadCommentToState();
    } else if (event is GetComment) {
      yield* _mapGetCommentToState(event.id, event.from);
    } else if (event is AddComment) {
      yield* _mapAddCommentToState(
          from: event.from, id: event.id, comment: event.comment);
    } else if (event is AddSubComment) {
      yield* _mapAddSubCommentToState(
          from: event.from,
          id: event.id,
          comment: event.comment,
          cmtid: event.cmtid);
    } else if (event is ExpandComment) {
      yield* _mapExpandCommentToState(index: event.index);
    } else if (event is CloseComment) {
      yield* _mapCloseCommentToState(index: event.index);
    }
  }

  Stream<CommentState> _mapLoadCommentToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<CommentState> _mapGetCommentToState(String id, String from) async* {
    List<Comment> comments = [];
    List<SubComment> subComments = [];
    List<User> commentUser = [];
    List<User> subCommentUser = [];

    QuerySnapshot _cmt = await FirebaseFirestore.instance
        .collection('Comment')
        .where(from, isEqualTo: id)
        .orderBy('date', descending: true)
        .get();

    _cmt.docs.forEach((ds) {
      comments.add(Comment.fromSnapshot(ds));
    });

    await Future.forEach(comments, (comments)async{
      QuerySnapshot _cmtUserUrl = await FirebaseFirestore.instance
          .collection('User')
          .where('uid', isEqualTo: comments.uid)
          .get();


      commentUser.add(User.fromSnapshot(_cmtUserUrl.docs.first));
    });

    QuerySnapshot _scmt = await FirebaseFirestore.instance
        .collection('SubComment')
        .where(from, isEqualTo: id)
        .orderBy('date', descending: true)
        .get();

    _scmt.docs.forEach((ds) {
      subComments.add(SubComment.fromSnapshot(ds));
    });


    await Future.forEach(subComments, (subComments)async{
      QuerySnapshot _scmtUserUrl = await FirebaseFirestore.instance
          .collection('User')
          .where('uid', isEqualTo: subComments.uid)
          .get();


      subCommentUser.add(User.fromSnapshot(_scmtUserUrl.docs.first));
    });


    yield state.update(
      isLoading: false,
      comments: comments,
      subComments: subComments,
      commentsUser: commentUser,
      subCommentsUser: subCommentUser,
    );
  }

  Stream<CommentState> _mapAddCommentToState(
      {String from, String id, String comment}) async* {
    List<Comment> comments = [];

    comments = state.comments;

    if (from == 'journal') {
      String cmtid = '';
      cmtid = FirebaseFirestore.instance.collection('Comment').doc().id;
      Comment cmt = Comment(
        date: Timestamp.now(),
        jid: id,
        uid: UserUtil.getUser().uid ?? '--',
        issid: '--',
        cmtid: cmtid,
        name: UserUtil.getUser().name,
        comment: comment,
        isThereSubComment: false,
        isExpanded: false,
        fid: FieldUtil.getField().fid,
        imgUrl: UserUtil.getUser().imgUrl,
        isWriteSubCommentClicked: false,
        isReadByFM: false,
        isReadByOM: false,
        isReadBySFM: true,
      );

      await CommentRepository().uploadComment(comment: cmt);

      comments.add(cmt);
    } else {
      String cmtid = '';
      cmtid = FirebaseFirestore.instance.collection('Comment').doc().id;
      Comment cmt = Comment(
        date: Timestamp.now(),
        jid: '--',
        uid: UserUtil.getUser().uid ?? '--',
        issid: id,
        cmtid: cmtid,
        name: UserUtil.getUser().name,
        comment: comment,
        isThereSubComment: false,
        isExpanded: false,
        fid: FieldUtil.getField().fid,
        imgUrl: UserUtil.getUser().imgUrl,
        isWriteSubCommentClicked: false,
        isReadByFM: false,
        isReadByOM: false,
        isReadBySFM: true,
      );

      await CommentRepository().uploadComment(comment: cmt);
      comments.add(cmt);
    }

    yield state.update(
      isLoading: false,
      comments: comments,
    );
  }

  Stream<CommentState> _mapAddSubCommentToState(
      {String from, String id, String comment, String cmtid}) async* {
    List<SubComment> subComments = [];

    subComments = state.subComments;

    if (from == 'journal') {
      String scmtid = FirebaseFirestore.instance.collection('SubComment').doc().id;
      SubComment scmt = SubComment(
        date: Timestamp.now(),
        jid: id,
        uid: UserUtil.getUser().uid ?? '--',
        issid: '--',
        scmtid: scmtid,
        cmtid: cmtid,
        name: UserUtil.getUser().name,
        scomment: comment,
        imgUrl: UserUtil.getUser().imgUrl,
        fid: FieldUtil.getField().fid,
        isReadByFM: false,
        isReadByOM: false,
        isReadBySFM: true,
      );

      await CommentRepository().uploadSubComment(scomment: scmt);
      await CommentRepository()
          .updateComment(isThereSubComment: true, cmtid: cmtid);

      subComments.add(scmt);
    } else {
      String scmtid = '';
      scmtid = FirebaseFirestore.instance.collection('SubComment').doc().id;
      SubComment scmt = SubComment(
        date: Timestamp.now(),
        jid: '--',
        uid: UserUtil.getUser().uid ?? '--',
        issid: id,
        scmtid: scmtid,
        cmtid: cmtid,
        name: UserUtil.getUser().name,
        scomment: comment,
        imgUrl: UserUtil.getUser().imgUrl,
        fid: FieldUtil.getField().fid,
        isReadByFM: false,
        isReadByOM: false,
        isReadBySFM: true,
      );

      await CommentRepository().uploadSubComment(scomment: scmt);
      await CommentRepository()
          .updateComment(isThereSubComment: true, cmtid: cmtid);

      subComments.add(scmt);
    }

    yield state.update(
      isLoading: false,
      subComments: subComments,
    );
  }

  Stream<CommentState> _mapExpandCommentToState({int index}) async* {
    List<Comment> cmts = [];
    cmts = state.comments;

    CommentUtil.setComment(Comment(
      date: cmts[index].date,
      name: cmts[index].name,
      uid: cmts[index].uid,
      issid: cmts[index].issid,
      jid: cmts[index].jid,
      cmtid: cmts[index].cmtid,
      comment: cmts[index].comment,
      isThereSubComment: cmts[index].isThereSubComment,
      isExpanded: true,
      fid: cmts[index].fid,
      imgUrl: cmts[index].imgUrl,
      isWriteSubCommentClicked: cmts[index].isWriteSubCommentClicked,
      isReadByFM: cmts[index].isReadByFM,
      isReadByOM: cmts[index].isReadByOM,
      isReadBySFM: cmts[index].isReadBySFM,
    ));

    cmts.removeAt(index);
    cmts.insert(index, CommentUtil.getComment());

    yield state.update(
      comments: cmts,
    );
  }

  Stream<CommentState> _mapCloseCommentToState({int index}) async* {
    List<Comment> cmts = [];
    cmts = state.comments;

    await CommentUtil.setComment(Comment(
      date: cmts[index].date,
      name: cmts[index].name,
      uid: cmts[index].uid,
      issid: cmts[index].issid,
      jid: cmts[index].jid,
      cmtid: cmts[index].cmtid,
      comment: cmts[index].comment,
      isThereSubComment: cmts[index].isThereSubComment,
      isExpanded: false,
      fid: cmts[index].fid,
      imgUrl: cmts[index].imgUrl,
      isWriteSubCommentClicked: cmts[index].isWriteSubCommentClicked,
      isReadByFM: cmts[index].isReadByFM,
      isReadByOM: cmts[index].isReadByOM,
      isReadBySFM: cmts[index].isReadBySFM,
    ));

    cmts.removeAt(index);
    cmts.insert(index, await CommentUtil.getComment());

    yield state.update(
      comments: cmts,
    );
  }
}
