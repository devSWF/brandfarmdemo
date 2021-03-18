
import 'package:BrandFarm/models/fm_purchase/fm_purchase_material_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FMPurchase {
  final String uid;
  final Timestamp postedDate;
  final String materialName;
  final String amount;
  final String state;
  final Timestamp materialReceivedDate;
  final String requester;
  final String receiver;
  final List<FMPurchaseMaterial> material;
  final String purchaseID;

  FMPurchase({
    @required this.uid,
    @required this.postedDate,
    @required this.materialName,
    @required this.amount,
    @required this.state,
    @required this.materialReceivedDate,
    @required this.requester,
    @required this.receiver,
    @required this.material,
    @required this.purchaseID,
  });

  factory FMPurchase.empty(){
    return FMPurchase(
      uid: '',
      postedDate: Timestamp.now(),
      materialName: '',
      amount: '',
      state: '',
      materialReceivedDate: Timestamp.now(),
      requester: '',
      receiver: '',
      material: [],
      purchaseID: '',
    );
  }

  factory FMPurchase.fromDs(DocumentSnapshot ds) {
    return FMPurchase(
      uid: ds['uid'],
      postedDate: ds['postedDate'],
      materialName: ds['materialName'],
      amount: ds['amount'],
      state: ds['state'],
      materialReceivedDate: ds['materialReceivedDate'],
      requester: ds['requester'],
      receiver: ds['receiver'],
      material: ds['material'] == null
          ? null
          : ds["material"]
          .map((dynamic item) {
        return FMPurchaseMaterial.fromDs(item);
      })
          .cast<FMPurchaseMaterial>()
          .toList(),
      purchaseID: ds['purchaseID'],
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> material = [];

    if (this.material != null) {
      material = this.material.map((FMPurchaseMaterial material) {
        return material.toMap();
      }).toList();
    }

    return {
      'uid' : this.uid,
      'postedDate' : this.postedDate,
      'materialName' : this.materialName,
      'amount' : this.amount,
      'state' : this.state,
      'materialReceivedDate' : this.materialReceivedDate,
      'requester' : this.requester,
      'receiver' : this.receiver,
      'material': this.material == null ? null : material,
      'purchaseID': this.purchaseID,
    };
  }
}
