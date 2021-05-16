import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FMIssueState {
  bool isLoading;
  List<SubJournalIssue> issueList;
  List<SubJournalIssue> reverseList;
  List<ImagePicture> imageList;
  List<Comment> commentList;
  List<SubComment> subCommentList;

  String year;
  String month;
  User detailUser;

  Comment newComment;
  SubComment newSComment;

  FMIssueState({
    @required this.isLoading,
    @required this.year,
    @required this.month,
    @required this.issueList,
    @required this.reverseList,
    @required this.imageList,
    @required this.detailUser,
    @required this.commentList,
    @required this.subCommentList,
    @required this.newComment,
    @required this.newSComment,
  });

  factory FMIssueState.empty() {
    return FMIssueState(
      isLoading: false,
      year: DateTime.now().year.toString(),
      month: DateTime.now().month.toString(),
      issueList: [],
      reverseList: [],
      imageList: [],
      detailUser: User(
        email: '',
        fcmToken: '',
        imgUrl: '',
        id: '',
        name: '',
        psw: '',
        phone: '',
        position: 0,
        uid: '',
      ),
      commentList: [],
      subCommentList: [],
      newComment: null,
      newSComment: null,
    );
  }

  FMIssueState copyWith({
    bool isLoading,
    String year,
    String month,
    List<SubJournalIssue> issueList,
    List<SubJournalIssue> reverseList,
    List<ImagePicture> imageList,
    User detailUser,
    List<Comment> commentList,
    List<SubComment> subCommentList,
    Comment newComment,
    SubComment newSComment,
  }) {
    return FMIssueState(
      isLoading: isLoading ?? this.isLoading,
      year: year ?? this.year,
      month: month ?? this.month,
      issueList: issueList ?? this.issueList,
      reverseList: reverseList ?? this.reverseList,
      imageList: imageList ?? this.imageList,
      detailUser: detailUser ?? this.detailUser,
      commentList: commentList ?? this.commentList,
      subCommentList: subCommentList ?? this.subCommentList,
      newComment: newComment ?? this.newComment,
      newSComment: newSComment ?? this.newSComment,
    );
  }

  FMIssueState update({
    bool isLoading,
    String year,
    String month,
    List<SubJournalIssue> issueList,
    List<SubJournalIssue> reverseList,
    List<ImagePicture> imageList,
    User detailUser,
    List<Comment> commentList,
    List<SubComment> subCommentList,
    Comment newComment,
    SubComment newSComment,
  }) {
    return copyWith(
      isLoading: isLoading,
      year: year,
      month: month,
      issueList: issueList,
      reverseList: reverseList,
      imageList: imageList,
      detailUser: detailUser,
      commentList: commentList,
      subCommentList: subCommentList,
      newComment: newComment,
      newSComment: newSComment,
    );
  }

  @override
  String toString() {
    return '''FMIssueState{
    isLoading: $isLoading,
    year: $year,
    month: $month,
    issueList: ${issueList.length},
    reverseList: ${reverseList.length},
    imageList: ${imageList.length},
    detailUser: ${detailUser},
    commentList: ${commentList},
    subCommentList: ${subCommentList},
    newComment: ${newComment},
    newSComment: ${newSComment},
    }
    ''';
  }
}
