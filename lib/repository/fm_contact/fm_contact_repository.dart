
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/contact/contact_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMContactRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Farm> getFarmInfo() async {
    Farm farm;
    await _firestore
        .collection('Farm')
        .where('managerID', isEqualTo: UserUtil
        .getUser()
        .uid)
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

  Future<List<FMContact>> getContactList(List<Field> fieldList) async {
    List<FMContact> clist = [];
    User user;
    await Future.forEach(fieldList, (info) async {
      await _firestore
          .collection('User')
          .where('uid', isEqualTo: info.sfmid)
          .get()
          .then((qs) {qs.docs.forEach((ds) {
            user = User.fromSnapshot(ds);
          });});

      FMContact obj = FMContact(
        uid: user.uid,
        name: user.name,
        position: getPosition(user.position),
        phoneNum: user.phone,
        imgUrl: user.imgUrl,
      );

      if(clist.isNotEmpty) {
        clist.add(obj);
      } else {
        clist.insert(0, obj);
      }
    });

    return clist;
  }

  String getPosition(int num) {
    switch(num) {
      case 1 : {
        return '오피스 매니저';
      } break;
      case 2 : {
        return '필드 매니저';
      } break;
      case 3 : {
        return '필드 워커';
      } break;
      default : {
        return '관리자(마스터)';
      } break;
    }
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
}