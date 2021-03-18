import 'package:BrandFarm/models/field_model.dart';
import 'package:meta/meta.dart';

class FMPurchaseMaterial {
  final int num;
  final String name;
  final String amount;
  final String unit;
  final String price;
  final String marketUrl;
  final Field field;

  FMPurchaseMaterial({
    @required this.num,
    @required this.name,
    @required this.amount,
    @required this.unit,
    @required this.price,
    @required this.marketUrl,
    @required this.field,
  });

  factory FMPurchaseMaterial.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return FMPurchaseMaterial.fromMap(temp);
  }

  factory FMPurchaseMaterial.fromMap(Map<String, dynamic> material) {
    return FMPurchaseMaterial(
      num: material['num'],
      name: material['name'],
      amount: material['amount'],
      unit: material['unit'],
      price: material['price'],
      marketUrl: material['marketUrl'],
      field: material['field'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'num': this.num,
      'name': this.name,
      'amount': this.amount,
      'unit': this.unit,
      'price': this.price,
      'marketUrl': this.marketUrl,
      'field': this.field,
    };
  }
}