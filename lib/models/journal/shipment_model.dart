import 'package:meta/meta.dart';

class Shipment {
  ///출하정보
  final String shipmentPlant;
  final String shipmentPath;
  final double shipmentUnit;

  ///text field
  final String shipmentUnitSelect;
  final String shipmentAmount;
  final String shipmentGrade;
  final int shipmentPrice;
  final int index;

  Shipment({
    @required this.shipmentPlant,
    @required this.shipmentPath,
    @required this.shipmentUnit,
    @required this.shipmentUnitSelect,
    @required this.shipmentAmount,
    @required this.shipmentGrade,
    @required this.shipmentPrice,
    @required this.index,
  });

  factory Shipment.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Shipment.fromMap(temp);
  }

  factory Shipment.fromMap(Map<String, dynamic> shipment) {
    return Shipment(
      shipmentPlant: shipment['shipmentPlant'],
      shipmentPath: shipment['shipmentPath'],
      shipmentUnit: shipment['shipmentUnit'].toDouble(),
      shipmentUnitSelect: shipment['shipmentUnitSelect'],
      shipmentAmount: shipment['shipmentAmount'],
      shipmentGrade: shipment['shipmentGrade'],
      shipmentPrice: shipment['shipmentPrice'],
      index: shipment['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shipmentPlant': this.shipmentPlant,
      'shipmentPath': this.shipmentPath,
      'shipmentUnit': this.shipmentUnit,
      'shipmentUnitSelect': this.shipmentUnitSelect,
      'shipmentAmount': this.shipmentAmount,
      'shipmentGrade': this.shipmentGrade,
      'shipmentPrice': this.shipmentPrice,
      'index': this.index,
    };
  }
}
