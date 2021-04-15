import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMJournalRepository {
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

  Future<List<Journal>> getJournalList(
      Field field, Timestamp firstDayOfMonth, Timestamp lastDayOfMonth) async {
    List<Journal> journal = [];
    QuerySnapshot jour = await _firestore
        .collection('Journal')
        .where('fid', isEqualTo: field.sfmid)
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('date', descending: true)
        .get();

    jour.docs.forEach((ds) {
      journal.add(Journal.fromDs(ds));
    });

    return journal;
  }

  Future<List<ImagePicture>> getImage(Field field) async {
    List<ImagePicture> image = [];
    QuerySnapshot img = await _firestore
        .collection('Picture')
        .where('uid', isEqualTo: field.sfmid)
        .where('issid', isEqualTo: '--')
        .get();
    img.docs.forEach((ds) {
      image.add(ImagePicture.fromSnapshot(ds));
    });

    return image;
  }

  Future<List<Comment>> getComment(String jid) async {
    List<Comment> cmt = [];
    QuerySnapshot _cmt = await _firestore
        .collection('Comment')
        .where('jid', isEqualTo: jid)
        .get();

    _cmt.docs.forEach((ds) {
      cmt.add(Comment.fromSnapshot(ds));
    });

    return cmt;
  }

  Future<List<SubComment>> getSubComment(String jid) async {
    List<SubComment> scmt = [];
    QuerySnapshot _scmt = await _firestore
        .collection('SubComment')
        .where('jid', isEqualTo: jid)
        .get();

    _scmt.docs.forEach((ds) {
      scmt.add(SubComment.fromSnapshot(ds));
    });

    return scmt;
  }

  // Future<void> uploadIssue({
  //   SubJournalIssue subJournalIssue,
  // }) async {
  //   DocumentReference reference =
  //   _firestore.collection('Issue').doc(subJournalIssue.issid);
  //   await reference.set(subJournalIssue.toMap());
  // }
  //
  // Future<void> updateIssue({
  //   SubJournalIssue subJournalIssue,
  // }) async {
  //   DocumentReference reference =
  //   _firestore.collection('Issue').doc(subJournalIssue.issid);
  //   await reference.update(subJournalIssue.toMap());
  // }
  //
  // Future<void> updateIssueComment({String issid, int cmts}) async {
  //   DocumentReference reference = _firestore.collection('Issue').doc(issid);
  //   await reference.update({"comments": cmts});
  // }
}
