import 'package:meta/meta.dart';

class Pesticide {
  ///농약정보
  final String pesticideMethod;
  final double pesticideArea;
  final String pesticideAreaUnit;
  final String pesticideMaterialName;
  final double pesticideMaterialUse;
  final String pesticideMaterialUnit;
  final double pesticideWater;
  final String pesticideWaterUnit;
  final int index;

  Pesticide(
      {@required this.pesticideMethod,
      @required this.pesticideArea,
      @required this.pesticideAreaUnit,
      @required this.pesticideMaterialName,
      @required this.pesticideMaterialUse,
      @required this.pesticideMaterialUnit,
      @required this.pesticideWater,
      @required this.pesticideWaterUnit,
      @required this.index});

  factory Pesticide.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Pesticide.fromMap(temp);
  }

  factory Pesticide.fromMap(Map<String, dynamic> pesticide) {
    return Pesticide(
      pesticideMethod: pesticide['pesticideMethod'],
      pesticideArea: pesticide['pesticideArea'].toDouble(),
      pesticideAreaUnit: pesticide['pesticideAreaUnit'],
      pesticideMaterialName: pesticide['pesticideMaterialName'],
      pesticideMaterialUse: pesticide['pesticideMaterialUse'].toDouble(),
      pesticideMaterialUnit: pesticide['pesticideMaterialUnit'],
      pesticideWater: pesticide['pesticideWater'].toDouble(),
      pesticideWaterUnit: pesticide['pesticideWaterUnit'],
      index: pesticide['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pesticideMethod': this.pesticideMethod,
      'pesticideArea': this.pesticideArea,
      'pesticideAreaUnit': this.pesticideAreaUnit,
      'pesticideMaterialName': this.pesticideMaterialName,
      'pesticideMaterialUse': this.pesticideMaterialUse,
      'pesticideMaterialUnit': this.pesticideMaterialUnit,
      'pesticideWater': this.pesticideWater,
      'pesticideWaterUnit': this.pesticideWaterUnit,
      'index': this.index,
    };
  }
}
