import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubJournalRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// issue related
  Future<List<SubJournalIssue>> getIssue() async {
    List<SubJournalIssue> issueList = [];
    QuerySnapshot _issue = await FirebaseFirestore.instance
        .collection('Issue')
        .where('fieldCategory', isEqualTo: FieldUtil.getField().fieldCategory)
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    _issue.docs.forEach((ds) {
      issueList.add(SubJournalIssue.fromSnapshot(ds));
    });

    return issueList;
  }

  Future<void> uploadIssue({
    SubJournalIssue subJournalIssue,
  }) async {
    DocumentReference reference =
        _firestore.collection('Issue').doc(subJournalIssue.issid);
    await reference.set(subJournalIssue.toMap());
  }

  Future<void> updateIssue({
    SubJournalIssue subJournalIssue,
  }) async {
    DocumentReference reference =
        _firestore.collection('Issue').doc(subJournalIssue.issid);
    await reference.update(subJournalIssue.toMap());
  }

  Future<void> updateIssueComment({String issid, int cmts}) async {
    DocumentReference reference = _firestore.collection('Issue').doc(issid);
    await reference.update({"comments": cmts});
  }

  /// journal related
  Future<List<Journal>> getJournal() async {
    List<Journal> journal = [];
    QuerySnapshot jour = await FirebaseFirestore.instance
        .collection('Journal')
        .where('fieldCategory', isEqualTo: FieldUtil.getField().fieldCategory)
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    jour.docs.forEach((ds) {
      journal.add(Journal.fromDs(ds));
    });

    return journal;
  }

  Future<void> uploadJournal({
    Journal journal,
  }) async {
    DocumentReference reference =
        _firestore.collection('Journal').doc(journal.jid);
    await reference.set(journal.toMap());
  }

  Future<void> updateJournal({
    Journal journal,
  }) async {
    DocumentReference reference =
        _firestore.collection('Journal').doc(journal.jid);
    await reference.update(journal.toMap());
  }

  Future<void> updateJournalComment({String jid, int cmts}) async {
    DocumentReference reference = _firestore.collection('Journal').doc(jid);
    await reference.update({"comments": cmts});
  }

  /// image related
  Future<List<ImagePicture>> getImage() async {
    List<ImagePicture> image = [];
    QuerySnapshot img = await FirebaseFirestore.instance
        .collection('Picture')
        .where('uid', isEqualTo: UserUtil.getUser().uid)
        .orderBy('dttm', descending: true)
        .limit(200)
        .get();
    img.docs.forEach((ds) {
      image.add(ImagePicture.fromSnapshot(ds));
    });

    return image;
  }
}
