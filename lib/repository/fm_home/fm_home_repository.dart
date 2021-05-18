
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
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

  Future<List<FMPlan>> getRecentPlanList(String farmID) async {
    List<FMPlan> plan = [];
    QuerySnapshot _plan = await _firestore
        .collection('Plan')
        .where('farmID', isEqualTo: farmID)
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    _plan.docs.forEach((ds) {
      plan.add(FMPlan.fromSnapshot(ds));
    });

    return plan;
  }

  Future<List<FMPurchase>> getRecentPurchaseList(String farmID) async {
    List<FMPurchase> purchase = [];
    QuerySnapshot _purchase = await _firestore
        .collection('Purchase')
        .where('farmID', isEqualTo: farmID)
        .orderBy('requestDate', descending: true)
        .limit(10)
        .get();

    _purchase.docs.forEach((ds) {
      purchase.add(FMPurchase.fromSnapshot(ds));
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

  // Future<void> updateIssue({
  //   SubJournalIssue obj,
  // }) async {
  //   DocumentReference reference = _firestore.collection('Issue').doc(obj.issid);
  //   await reference.update(obj.toMap());
  // }
  //
  // Future<void> addCommentIssue({
  //   String issid,
  // })async{
  //   DocumentReference reference = _firestore.collection('Issue').doc(issid);
  //
  //   await reference.update({"comments": FieldValue.increment(1)});
  // }
  //
  // Future<void> addCommentJournal({
  //   String jid,
  // })async{
  //   DocumentReference reference = _firestore.collection('Journal').doc(jid);
  //
  //   await reference.update({"comments": FieldValue.increment(1)});
  // }
  //
  // Future<List<ImagePicture>> getImage(Field field) async {
  //   List<ImagePicture> image = [];
  //   QuerySnapshot img = await _firestore
  //       .collection('Picture')
  //       .where('uid', isEqualTo: field.sfmid)
  //       .where('jid', isEqualTo: '--')
  //       .get();
  //   img.docs.forEach((ds) {
  //     image.add(ImagePicture.fromSnapshot(ds));
  //   });
  //
  //   return image;
  // }
  //
  // Future<List<Comment>> getComment(String issid) async {
  //   List<Comment> cmt = [];
  //   QuerySnapshot _cmt = await _firestore
  //       .collection('Comment')
  //       .where('issid', isEqualTo: issid)
  //       .get();
  //
  //   _cmt.docs.forEach((ds) {
  //     cmt.add(Comment.fromSnapshot(ds));
  //   });
  //
  //   return cmt;
  // }
  //
  // Future<List<SubComment>> getSubComment(String issid) async {
  //   List<SubComment> scmt = [];
  //   QuerySnapshot _scmt = await _firestore
  //       .collection('SubComment')
  //       .where('issid', isEqualTo: issid)
  //       .get();
  //
  //   _scmt.docs.forEach((ds) {
  //     scmt.add(SubComment.fromSnapshot(ds));
  //   });
  //
  //   return scmt;
  // }
  //
  // Future<void> updateIssueComment({String issid, int cmts}) async {
  //   DocumentReference reference = _firestore.collection('Issue').doc(issid);
  //   await reference.update({"comments": cmts});
  // }
}
