import 'package:meta/meta.dart';

class Farming {
  ///경운정보
  final double farmingArea;

  ///면적
  final String farmingAreaUnit;

  ///면적 단위
  final String farmingMethod;

  ///경운방법
  final String farmingMethodUnit;

  ///경운방법 단위
  final bool farmingValid;
  final int index;

  Farming(
      {@required this.farmingArea,
      @required this.farmingAreaUnit,
      @required this.farmingMethod,
      @required this.farmingMethodUnit,
      @required this.farmingValid,
      @required this.index});

  factory Farming.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Farming.fromMap(temp);
  }

  factory Farming.fromMap(Map<String, dynamic> farming) {
    return Farming(
      farmingArea: farming['farmingArea'].toDouble(),
      farmingAreaUnit: farming['farmingAreaUnit'],
      farmingMethod: farming['farmingMethod'],
      farmingMethodUnit: farming['farmingMethodUnit'],
      farmingValid: farming['farmingValid'],
      index: farming['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmingArea': this.farmingArea,
      'farmingAreaUnit': this.farmingAreaUnit,
      'farmingMethod': this.farmingMethod,
      'farmingMethodUnit': this.farmingMethodUnit,
      'farmingValid': this.farmingValid,
      'index': this.index,
    };
  }
}
