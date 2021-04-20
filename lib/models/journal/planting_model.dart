import 'package:meta/meta.dart';

class Planting {
  ///정식 정보
  final double plantingArea;

  ///면적
  final String plantingAreaUnit;

  ///면적 단위
  final String plantingCount;

  ///주수
  final int plantingPrice;

  ///주당가격
  final bool plantingValid;
  final int index;

  Planting({
    @required this.plantingArea,
    @required this.plantingAreaUnit,
    @required this.plantingCount,
    @required this.plantingPrice,
    @required this.plantingValid,
    @required this.index,
  });

  factory Planting.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Planting.fromMap(temp);
  }

  factory Planting.fromMap(Map<String, dynamic> planting) {
    return Planting(
      plantingArea: planting['plantingArea'].toDouble(),
      plantingAreaUnit: planting['plantingAreaUnit'],
      plantingCount: planting['plantingCount'],
      plantingPrice: planting['plantingPrice'],
      plantingValid: planting['plantingValid'],
      index: planting['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plantingArea': this.plantingArea,
      'plantingAreaUnit': this.plantingAreaUnit,
      'plantingCount': this.plantingCount,
      'plantingPrice': this.plantingPrice,
      'plantingValid': this.plantingValid,
      'index': this.index,
    };
  }
}
