import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OMHomeRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateFcmToken(String uid, String deviceToken) async {
    DocumentReference reference = _firestore.collection('User').doc(uid);
    await reference.update({"fcmToken": deviceToken});
  }

  Future<void> updateNotice(OMNotificationNotice notice) async {
    DocumentReference reference =
        _firestore.collection('OMNotification').doc(notice.notid);
    await reference.update(notice.toDocument());
  }

  Future<void> updatePlan(OMPlan plan) async {
    DocumentReference reference =
        _firestore.collection('OMPlan').doc(plan.planID);
    await reference.update(plan.toDocument());
  }

  Future<void> updatePurchase(Purchase purchase) async {
    DocumentReference reference =
        _firestore.collection('Purchase').doc(purchase.purchaseID);
    await reference.update(purchase.toDocument());
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

  Future<List<Farm>> getFarmList() async {
    List<Farm> flist = [];
    QuerySnapshot _flist = await _firestore
        .collection('Farm')
        .where('officeNum', isEqualTo: 1)
        .get();

    _flist.docs.forEach((ds) {
      flist.add(Farm.fromSnapshot(ds));
    });

    return flist;
  }

  Future<List<OMNotificationNotice>> getRecentNoticeList() async {
    List<OMNotificationNotice> notice = [];
    QuerySnapshot _notice = await _firestore
        .collection('OMNotification')
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    _notice.docs.forEach((ds) {
      notice.add(OMNotificationNotice.fromSnapshot(ds));
    });

    return notice;
  }

  Future<List<OMPlan>> getRecentPlanList() async {
    List<OMPlan> plan = [];
    QuerySnapshot _plan = await _firestore
        .collection('OMPlan')
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    _plan.docs.forEach((ds) {
      plan.add(OMPlan.fromSnapshot(ds));
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

  Future<void> postNotification({OMNotificationNotice notice}) async {
    DocumentReference reference =
        _firestore.collection('OMNotification').doc(notice.notid);
    await reference.set(notice.toDocument());
  }

// Future<void> updateIssueComment({String issid, int cmts}) async {
//   DocumentReference reference = _firestore.collection('Issue').doc(issid);
//   await reference.update({"comments": cmts});
// }
}
