import 'package:BrandFarm/models/field_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FMPurchase {
  final String purchaseID;
  final String requester;
  final String receiver;
  final Timestamp requestDate;
  final Timestamp receiveDate;
  final String productName;
  final String amount;
  final String price;
  final String marketUrl;
  final Field field;
  final String memo;
  final String officeReply;
  final int waitingState;
  final bool isFieldSelectionButtonClicked;
  final bool isThereUpdates;

  FMPurchase({
    @required this.purchaseID,
    @required this.requester,
    @required this.receiver,
    @required this.requestDate,
    @required this.receiveDate,
    @required this.productName,
    @required this.amount,
    @required this.price,
    @required this.marketUrl,
    @required this.field,
    @required this.memo,
    @required this.officeReply,
    @required this.waitingState,
    @required this.isFieldSelectionButtonClicked,
    @required this.isThereUpdates,
  });

  factory FMPurchase.fromSnapshot(DocumentSnapshot ds) {
    return FMPurchase(
      purchaseID: ds['purchaseID'],
      requester: ds['requester'],
      receiver: ds['receiver'],
      requestDate: ds['requestDate'],
      receiveDate: ds['receiveDate'],
      productName: ds['productName'],
      amount: ds['amount'],
      price: ds['price'],
      marketUrl: ds['marketUrl'],
      field: ds['field'],
      memo: ds['memo'],
      officeReply: ds['officeReply'],
      waitingState: ds['waitingState'],
      isFieldSelectionButtonClicked: ds['isFieldSelectionButtonClicked'],
      isThereUpdates: ds['isThereUpdates'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'planID': purchaseID,
      'requester': requester,
      'receiver': receiver,
      'requestDate': requestDate,
      'receiveDate': receiveDate,
      'productName': productName,
      'amount': amount,
      'price': price,
      'marketUrl': marketUrl,
      'field': field,
      'memo': memo,
      'officeReply': officeReply,
      'waitingState': waitingState,
      'isFieldSelectionButtonClicked': isFieldSelectionButtonClicked,
      'isThereUpdates': isThereUpdates,
    };
  }
}
