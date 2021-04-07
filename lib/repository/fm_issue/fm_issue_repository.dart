import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMIssueRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getDetailUserInfo(uid) async {
    User user;
    await _firestore
        .collection('User')
        .where('uid', isEqualTo: uid)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        user = User.fromSnapshot(ds);
      });
    });
    return user;
  }

  Future<List<SubJournalIssue>> getIssueList(
      String fid, Timestamp firstDayOfMonth, Timestamp lastDayOfMonth) async {
    List<SubJournalIssue> issueList = [];
    QuerySnapshot _issue = await _firestore
        .collection('Issue')
        .where('fid', isEqualTo: fid)
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('date', descending: true)
        .get();

    _issue.docs.forEach((ds) {
      issueList.add(SubJournalIssue.fromSnapshot(ds));
    });

    return issueList;
  }

  Future<void> updateIssue({
    SubJournalIssue obj,
  }) async {
    DocumentReference reference = _firestore.collection('Issue').doc(obj.issid);
    await reference.update(obj.toMap());
  }

  Future<void> addCommentIssue({
    String issid,
  })async{
    DocumentReference reference = _firestore.collection('Issue').doc(issid);

    await reference.update({"comments": FieldValue.increment(1)});
  }

  Future<void> addCommentJournal({
    String jid,
  })async{
    DocumentReference reference = _firestore.collection('Journal').doc(jid);

    await reference.update({"comments": FieldValue.increment(1)});
  }

  Future<List<ImagePicture>> getImage(Field field) async {
    List<ImagePicture> image = [];
    QuerySnapshot img = await _firestore
        .collection('Picture')
        .where('uid', isEqualTo: field.sfmid)
        .where('jid', isEqualTo: '--')
        .get();
    img.docs.forEach((ds) {
      image.add(ImagePicture.fromSnapshot(ds));
    });

    return image;
  }

  Future<List<Comment>> getComment(String issid) async {
    List<Comment> cmt = [];
    QuerySnapshot _cmt = await _firestore
        .collection('Comment')
        .where('issid', isEqualTo: issid)
        .get();

    _cmt.docs.forEach((ds) {
      cmt.add(Comment.fromSnapshot(ds));
    });

    return cmt;
  }

  Future<List<SubComment>> getSubComment(String issid) async {
    List<SubComment> scmt = [];
    QuerySnapshot _scmt = await _firestore
        .collection('SubComment')
        .where('issid', isEqualTo: issid)
        .get();

    _scmt.docs.forEach((ds) {
      scmt.add(SubComment.fromSnapshot(ds));
    });

    return scmt;
  }

  Future<void> updateIssueComment({String issid, int cmts}) async {
    DocumentReference reference = _firestore.collection('Issue').doc(issid);
    await reference.update({"comments": cmts});
  }
}
