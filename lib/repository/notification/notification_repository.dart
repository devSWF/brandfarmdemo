import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Farm> getFarmInfo(String fieldCategory) async {
    Farm farm;
    await _firestore
        .collection('Farm')
        .where('fieldCategory', isEqualTo: fieldCategory)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        farm = Farm.fromSnapshot(ds);
      });
    });
    return farm;
  }

  Future<List<NotificationNotice>> getFarmNotification(String farmid) async {
    List<NotificationNotice> totalList = [];
    QuerySnapshot _list = await _firestore
        .collection('Notification')
        .where('farmid', isEqualTo: farmid)
        .orderBy('postedDate', descending: true)
        .get();

    _list.docs.forEach((ds) {
      totalList.add(NotificationNotice.fromSnapshot(ds));
    });

    return totalList;
  }

  Future<void> postNotification(NotificationNotice notice,) async {
    DocumentReference reference =
    _firestore.collection('Notification').doc(notice.notid);
    await reference.set(notice.toDocument());
  }

  Future<void> updateNotification({
    NotificationNotice obj,
  }) async {
    DocumentReference reference = _firestore.collection('Notification').doc(obj.notid);
    await reference.update(obj.toDocument());
  }

  Future<User> getUserInfo(String uid) async {
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

  Future<FMPlan> getPlan(String planID) async {
    FMPlan plan;
    await _firestore
        .collection('Plan')
        .where('planID', isEqualTo: planID)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        plan = FMPlan.fromSnapshot(ds);
      });
    });
    return plan;
  }

  Future<Journal> getJournal(String jid) async {
    Journal journal;
    await _firestore
        .collection('Journal')
        .where('jid', isEqualTo: jid)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        journal = Journal.fromDs(ds);
      });
    });
    return journal;
  }

  Future<SubJournalIssue> getIssue(String issid) async {
    SubJournalIssue issue;
    await _firestore
        .collection('Issue')
        .where('issid', isEqualTo: issid)
        .get()
        .then((qs) {
      qs.docs.forEach((ds) {
        issue = SubJournalIssue.fromSnapshot(ds);
      });
    });
    return issue;
  }

  Future<List<Comment>> getCommentForJournal(String jid) async {
    List<Comment> clist = [];
    QuerySnapshot _list = await _firestore
        .collection('Comment')
        .where('jid', isEqualTo: jid)
        .orderBy('date', descending: true)
        .get();

    _list.docs.forEach((ds) {
      clist.add(Comment.fromSnapshot(ds));
    });

    return clist;
  }

  Future<List<Comment>> getCommentForIssue(String issid) async {
    List<Comment> clist = [];
    QuerySnapshot _list = await _firestore
        .collection('Comment')
        .where('issid', isEqualTo: issid)
        .orderBy('date', descending: true)
        .get();

    _list.docs.forEach((ds) {
      clist.add(Comment.fromSnapshot(ds));
    });

    return clist;
  }

  Future<List<SubComment>> getSubCommentForJournal(String jid) async {
    List<SubComment> sclist = [];
    QuerySnapshot _list = await _firestore
        .collection('SubComment')
        .where('jid', isEqualTo: jid)
        .orderBy('date', descending: true)
        .get();

    _list.docs.forEach((ds) {
      sclist.add(SubComment.fromSnapshot(ds));
    });

    return sclist;
  }

  Future<List<SubComment>> getSubCommentForIssue(String issid) async {
    List<SubComment> sclist = [];
    QuerySnapshot _list = await _firestore
        .collection('SubComment')
        .where('issid', isEqualTo: issid)
        .orderBy('date', descending: true)
        .get();

    _list.docs.forEach((ds) {
      sclist.add(SubComment.fromSnapshot(ds));
    });

    return sclist;
  }

  Future<List<ImagePicture>> getImagePictureForJournal(String jid) async {
    List<ImagePicture> pic = [];
    QuerySnapshot _list = await _firestore
        .collection('Picture')
        .where('jid', isEqualTo: jid)
        .orderBy('dttm', descending: true)
        .get();

    _list.docs.forEach((ds) {
      pic.add(ImagePicture.fromSnapshot(ds));
    });

    return pic;
  }

  Future<List<ImagePicture>> getImagePictureForIssue(String issid) async {
    List<ImagePicture> pic = [];
    QuerySnapshot _list = await _firestore
        .collection('Picture')
        .where('issid', isEqualTo: issid)
        .orderBy('dttm', descending: true)
        .get();

    _list.docs.forEach((ds) {
      pic.add(ImagePicture.fromSnapshot(ds));
    });

    return pic;
  }

// Future<User> getDetailUserInfo(uid) async {
//   User user;
//   await _firestore
//       .collection('User')
//       .where('uid', isEqualTo: uid)
//       .get()
//       .then((qs) {
//     qs.docs.forEach((ds) {
//       user = User.fromSnapshot(ds);
//     });
//   });
//   return user;
// }
//
// Future<List<SubJournalIssue>> getIssueList(
//     String fid, Timestamp firstDayOfMonth, Timestamp lastDayOfMonth) async {
//   List<SubJournalIssue> issueList = [];
//   QuerySnapshot _issue = await _firestore
//       .collection('Issue')
//       .where('fid', isEqualTo: fid)
//       .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
//       .where('date', isLessThanOrEqualTo: lastDayOfMonth)
//       .orderBy('date', descending: true)
//       .get();
//
//   _issue.docs.forEach((ds) {
//     issueList.add(SubJournalIssue.fromSnapshot(ds));
//   });
//
//   return issueList;
// }

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

// Future<void> updateIssueComment({String issid, int cmts}) async {
//   DocumentReference reference = _firestore.collection('Issue').doc(issid);
//   await reference.update({"comments": cmts});
// }
}
