
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMHomeRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateFcmToken(String uid, String deviceToken) async {
    DocumentReference reference = _firestore.collection('User').doc(uid);
    await reference.update({"fcmToken": deviceToken});
  }

  Future<void> updateIssue(SubJournalIssue issue) async {
    DocumentReference reference = _firestore.collection('Issue').doc(issue.issid);
    await reference.update(issue.toMap());
  }

  Future<void> updateJournal(Journal journal) async {
    DocumentReference reference = _firestore.collection('Journal').doc(journal.jid);
    await reference.update(journal.toMap());
  }

  Future<void> updateNotice(NotificationNotice notice) async {
    DocumentReference reference = _firestore.collection('Notification').doc(notice.notid);
    await reference.update(notice.toDocument());
  }

  Future<void> updatePlan(Plan plan) async {
    DocumentReference reference = _firestore.collection('Plan').doc(plan.planID);
    await reference.update(plan.toDocument());
  }

  Future<void> updatePurchase(Purchase purchase) async {
    DocumentReference reference = _firestore.collection('Purchase').doc(purchase.purchaseID);
    await reference.update(purchase.toDocument());
  }

  Future<void> updateComment(Comment comment) async {
    DocumentReference reference = _firestore.collection('Comment').doc(comment.cmtid);
    await reference.update(comment.toDocument());
  }

  Future<void> updateSComment(SubComment subComment) async {
    DocumentReference reference = _firestore.collection('SubComment').doc(subComment.scmtid);
    await reference.update(subComment.toDocument());
  }

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

  Future<Farm> getFarmInfo() async {
    Farm farm;
    await _firestore
        .collection('Farm')
        .where('managerID', isEqualTo: UserUtil.getUser().uid)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        farm = Farm.fromSnapshot(ds);
      });
    });
    return farm;
  }

  Future<List<Field>> getFieldList(String fieldCategory) async {
    List<Field> fieldList = [];
    QuerySnapshot _fieldList = await _firestore
        .collection('Field')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .get();

    _fieldList.docs.forEach((ds) {
      fieldList.add(Field.fromSnapshot(ds));
    });

    return fieldList;
  }

  Future<List<NotificationNotice>> getRecentNoticeList(String farmID) async {
    List<NotificationNotice> notice = [];
    QuerySnapshot _notice = await _firestore
        .collection('Notification')
        .where('farmid', isEqualTo: farmID)
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    _notice.docs.forEach((ds) {
      notice.add(NotificationNotice.fromSnapshot(ds));
    });

    return notice;
  }

  Future<List<Plan>> getRecentPlanList(String farmID) async {
    List<Plan> plan = [];
    QuerySnapshot _plan = await _firestore
        .collection('Plan')
        .where('farmID', isEqualTo: farmID)
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    _plan.docs.forEach((ds) {
      plan.add(Plan.fromSnapshot(ds));
    });

    return plan;
  }

  Future<List<Purchase>> getRecentPurchaseList(String farmID) async {
    List<Purchase> purchase = [];
    QuerySnapshot _purchase = await _firestore
        .collection('Purchase')
        .where('farmID', isEqualTo: farmID)
        .orderBy('requestDate', descending: true)
        .limit(10)
        .get();

    _purchase.docs.forEach((ds) {
      purchase.add(Purchase.fromSnapshot(ds));
    });

    return purchase;
  }

  Future<List<Journal>> getRecentJournalList(String fieldCategory) async {
    List<Journal> journal = [];
    QuerySnapshot _journal = await _firestore
        .collection('Journal')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _journal.docs.forEach((ds) {
      journal.add(Journal.fromDs(ds));
    });

    return journal;
  }

  Future<List<SubJournalIssue>> getRecentIssueList(String fieldCategory) async {
    List<SubJournalIssue> issue = [];
    QuerySnapshot _issue = await _firestore
        .collection('Issue')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _issue.docs.forEach((ds) {
      issue.add(SubJournalIssue.fromSnapshot(ds));
    });

    return issue;
  }

  Future<List<Comment>> getRecentCommentList(String fieldCategory) async {
    List<Comment> comment = [];
    QuerySnapshot _comment = await _firestore
        .collection('Comment')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _comment.docs.forEach((ds) {
      comment.add(Comment.fromSnapshot(ds));
    });

    return comment;
  }

  Future<List<SubComment>> getRecentSubCommentList(String fieldCategory) async {
    List<SubComment> subComment = [];
    QuerySnapshot _subComment = await _firestore
        .collection('SubComment')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _subComment.docs.forEach((ds) {
      subComment.add(SubComment.fromSnapshot(ds));
    });

    return subComment;
  }

  Future<void> addComment({
    Comment cmt,
  })async{
    DocumentReference reference = _firestore.collection('Comment').doc(cmt.cmtid);
    await reference.set(cmt.toDocument());
  }

  Future<void> addSComment({
    SubComment scmt
  })async{
    DocumentReference reference = _firestore.collection('SubComment').doc(scmt.scmtid);
    await reference.set(scmt.toDocument());
  }

  Future<void> postNotification({
    NotificationNotice notice
  })async{
    DocumentReference reference = _firestore.collection('Notification').doc(notice.notid);
    await reference.set(notice.toDocument());
  }

  Future<List<ImagePicture>> getIssueImage(String issid) async {
    List<ImagePicture> image = [];
    QuerySnapshot img = await _firestore
        .collection('Picture')
        .where('issid', isEqualTo: issid)
        .get();
    img.docs.forEach((ds) {
      image.add(ImagePicture.fromSnapshot(ds));
    });

    return image;
  }

  Future<List<ImagePicture>> getJournalImage(String jid) async {
    List<ImagePicture> image = [];
    QuerySnapshot img = await _firestore
        .collection('Picture')
        .where('jid', isEqualTo: jid)
        .get();
    img.docs.forEach((ds) {
      image.add(ImagePicture.fromSnapshot(ds));
    });

    return image;
  }

  Future<List<Comment>> getIssueComment(String issid) async {
    List<Comment> comment = [];
    QuerySnapshot _comment = await _firestore
        .collection('Comment')
        .where('issid', isEqualTo: issid)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _comment.docs.forEach((ds) {
      comment.add(Comment.fromSnapshot(ds));
    });

    return comment;
  }

  Future<List<Comment>> getJournalComment(String jid) async {
    List<Comment> comment = [];
    QuerySnapshot _comment = await _firestore
        .collection('Comment')
        .where('jid', isEqualTo: jid)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _comment.docs.forEach((ds) {
      comment.add(Comment.fromSnapshot(ds));
    });

    return comment;
  }

  Future<List<SubComment>> getIssueSComment(String issid) async {
    List<SubComment> subComment = [];
    QuerySnapshot _subComment = await _firestore
        .collection('SubComment')
        .where('issid', isEqualTo: issid)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _subComment.docs.forEach((ds) {
      subComment.add(SubComment.fromSnapshot(ds));
    });

    return subComment;
  }

  Future<List<SubComment>> getJournalSComment(String jid) async {
    List<SubComment> subComment = [];
    QuerySnapshot _subComment = await _firestore
        .collection('SubComment')
        .where('jid', isEqualTo: jid)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    _subComment.docs.forEach((ds) {
      subComment.add(SubComment.fromSnapshot(ds));
    });

    return subComment;
  }

  // Future<void> updateIssueComment({String issid, int cmts}) async {
  //   DocumentReference reference = _firestore.collection('Issue').doc(issid);
  //   await reference.update({"comments": cmts});
  // }
}
