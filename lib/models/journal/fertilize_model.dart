import 'package:meta/meta.dart';

class Fertilize {
  ///비료정보
  final String fertilizerMethod;

  ///살포방식
  final double fertilizerArea;

  ///면적
  final String fertilizerAreaUnit;

  ///면적 단위
  final String fertilizerMaterialName;

  ///자재이름
  final double fertilizerMaterialUse;

  ///자재 사용량
  final String fertilizerMaterialUnit;

  ///자재 사용량 단위
  final double fertilizerWater;

  ///물 샤용량
  final String fertilizerWaterUnit;

  ///물
  final int index;

  /// 사용량 단위

  Fertilize(
      {@required this.fertilizerMethod,
      @required this.fertilizerArea,
      @required this.fertilizerAreaUnit,
      @required this.fertilizerMaterialName,
      @required this.fertilizerMaterialUse,
      @required this.fertilizerMaterialUnit,
      @required this.fertilizerWater,
      @required this.fertilizerWaterUnit,
      @required this.index});

  factory Fertilize.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Fertilize.fromMap(temp);
  }

  factory Fertilize.fromMap(Map<String, dynamic> fertilize) {
    return Fertilize(
      fertilizerMethod: fertilize['fertilizerMethod'],
      fertilizerArea: fertilize['fertilizerArea'].toDouble(),
      fertilizerAreaUnit: fertilize['fertilizerAreaUnit'],
      fertilizerMaterialName: fertilize['fertilizerMaterialName'],
      fertilizerMaterialUse: fertilize['fertilizerMaterialUse'].toDouble(),
      fertilizerMaterialUnit: fertilize['fertilizerMaterialUnit'],
      fertilizerWater: fertilize['fertilizerWater'].toDouble(),
      fertilizerWaterUnit: fertilize['fertilizerWaterUnit'],
      index: fertilize['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fertilizerMethod': this.fertilizerMethod,
      'fertilizerArea': this.fertilizerArea,
      'fertilizerAreaUnit': this.fertilizerAreaUnit,
      'fertilizerMaterialName': this.fertilizerMaterialName,
      'fertilizerMaterialUse': this.fertilizerMaterialUse,
      'fertilizerMaterialUnit': this.fertilizerMaterialUnit,
      'fertilizerWater': this.fertilizerWater,
      'fertilizerWaterUnit': this.fertilizerWaterUnit,
      'index': this.index,
    };
  }
}
