import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OMNotificationRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<Farm> getFarmInfo() async {
  //   Farm farm;
  //   await _firestore
  //       .collection('Farm')
  //       .where('managerID', isEqualTo: UserUtil.getUser().uid)
  //       .get()
  //       .then((qs) {
  //     qs.docs.forEach((ds) {
  //       farm = Farm.fromSnapshot(ds);
  //     });
  //   });
  //   return farm;
  // }

  Future<List<Farm>> getFarmInfo() async {
    List<Farm> fList = [];
    QuerySnapshot _fList = await _firestore.collection('Farm').get();

    _fList.docs.forEach((ds) {
      fList.add(Farm.fromSnapshot(ds));
    });

    return fList;
  }

  Future<void> postNotification(
    OMNotificationNotice notice,
  ) async {
    DocumentReference reference =
        _firestore.collection('OMNotification').doc(notice.notid);
    await reference.set(notice.toDocument());
  }

  Future<List<OMNotificationNotice>> getNotificationList() async {
    List<OMNotificationNotice> nlist = [];
    QuerySnapshot _nlist = await _firestore
        .collection('OMNotification')
        .orderBy('postedDate', descending: true)
        .get();

    _nlist.docs.forEach((ds) {
      nlist.add(OMNotificationNotice.fromSnapshot(ds));
    });

    return nlist;
  }

  Future<void> updateNotice({
    OMNotificationNotice obj,
  }) async {
    DocumentReference reference =
        _firestore.collection('OMNotification').doc(obj.notid);
    await reference.update(obj.toDocument());
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
