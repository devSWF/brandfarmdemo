import 'package:meta/meta.dart';

class Watering {
  ///관수정보
  final double wateringArea;

  ///관수 면적
  final String wateringAreaUnit;

  ///관수 면적 단위
  final double wateringAmount;

  ///총 관수량
  final String wateringAmountUnit;

  ///관수량 단위
  final bool wateringValid;
  final int index;

  Watering(
      {@required this.wateringArea,
      @required this.wateringAreaUnit,
      @required this.wateringAmount,
      @required this.wateringAmountUnit,
      @required this.wateringValid,
      @required this.index});

  factory Watering.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Watering.fromMap(temp);
  }

  factory Watering.fromMap(Map<String, dynamic> watering) {
    return Watering(
      wateringArea: watering['wateringArea'].toDouble(),
      wateringAreaUnit: watering['wateringAreaUnit'],
      wateringAmount: watering['wateringAmount'].toDouble(),
      wateringAmountUnit: watering['wateringAmountUnit'],
      wateringValid: watering['wateringValid'],
      index: watering['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wateringArea': this.wateringArea,
      'wateringAreaUnit': this.wateringAreaUnit,
      'wateringAmount': this.wateringAmount,
      'wateringAmountUnit': this.wateringAmountUnit,
      'wateringValid': this.wateringValid,
      'index': this.index,
    };
  }
}
