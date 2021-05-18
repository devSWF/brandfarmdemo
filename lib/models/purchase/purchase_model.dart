import 'package:BrandFarm/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Purchase {
  final String purchaseID;
  final String farmID;
  final String requester;
  final String receiver;
  final Timestamp requestDate;
  final Timestamp receiveDate;
  final String productName;
  final String amount;
  final String price;
  final String marketUrl;
  final String fid;
  final String memo;
  final String officeReply;
  final int waitingState;
  final bool isFieldSelectionButtonClicked;
  final bool isThereUpdates;
  final User reqUser;
  final User recUser;

  Purchase({
    @required this.purchaseID,
    @required this.farmID,
    @required this.requester,
    @required this.receiver,
    @required this.requestDate,
    @required this.receiveDate,
    @required this.productName,
    @required this.amount,
    @required this.price,
    @required this.marketUrl,
    @required this.fid,
    @required this.memo,
    @required this.officeReply,
    @required this.waitingState,
    @required this.isFieldSelectionButtonClicked,
    @required this.isThereUpdates,
    @required this.reqUser,
    @required this.recUser,
  });

  factory Purchase.fromSnapshot(DocumentSnapshot ds) {
    return Purchase(
      purchaseID: ds.data()['purchaseID'],
      farmID: ds.data()['farmID'],
      requester: ds.data()['requester'],
      receiver: ds.data()['receiver'],
      requestDate: ds.data()['requestDate'],
      receiveDate: ds.data()['receiveDate'],
      productName: ds.data()['productName'],
      amount: ds.data()['amount'],
      price: ds.data()['price'],
      marketUrl: ds.data()['marketUrl'],
      fid: ds.data()['fid'],
      memo: ds.data()['memo'],
      officeReply: ds.data()['officeReply'],
      waitingState: ds.data()['waitingState'],
      isFieldSelectionButtonClicked: ds.data()['isFieldSelectionButtonClicked'],
      isThereUpdates: ds.data()['isThereUpdates'],
      reqUser: ds.data()['reqUser'] == null
          ? null
          : User.fromMap(ds['reqUser']),
      recUser: ds.data()['recUser'] == null
          ? null
          : User.fromMap(ds['recUser']),
    );
  }

  Map<String, Object> toDocument() {
    Map<String, dynamic> reqUser = null;
    Map<String, dynamic> recUser = null;
    if (this.reqUser != null) {
      reqUser = this.reqUser.toDocument();
    }

    if (this.recUser != null) {
      recUser = this.recUser.toDocument();
    }

    return {
      'purchaseID': purchaseID,
      'farmID': farmID,
      'requester': requester,
      'receiver': receiver,
      'requestDate': requestDate,
      'receiveDate': receiveDate,
      'productName': productName,
      'amount': amount,
      'price': price,
      'marketUrl': marketUrl,
      'fid': fid,
      'memo': memo,
      'officeReply': officeReply,
      'waitingState': waitingState,
      'isFieldSelectionButtonClicked': isFieldSelectionButtonClicked,
      'isThereUpdates': isThereUpdates,
      'reqUser': reqUser,
      'recUser': recUser,
    };
  }
}
