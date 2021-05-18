

import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> postPlan(Plan plan,) async {
    DocumentReference reference =
    _firestore.collection('Plan').doc(plan.planID);
    await reference.set(plan.toDocument());
  }

  Future<List<Plan>> getPlanList(String farmID) async {
    List<Plan> plist = [];
    QuerySnapshot _plist = await _firestore
        .collection('Plan')
        .where('farmID', isEqualTo: farmID)
        .get();

    _plist.docs.forEach((ds) {
      plist.add(Plan.fromSnapshot(ds));
    });

    return plist;
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
//
// Future<void> updateIssue({
//   SubJournalIssue obj,
// }) async {
//   DocumentReference reference = _firestore.collection('Issue').doc(obj.issid);
//   await reference.update(obj.toMap());
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

// Future<void> updateIssueComment({String issid, int cmts}) async {
//   DocumentReference reference = _firestore.collection('Issue').doc(issid);
//   await reference.update({"comments": cmts});
// }
}
