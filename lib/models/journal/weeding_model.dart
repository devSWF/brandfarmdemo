import 'package:meta/meta.dart';

class Weeding {
  ///제초정보
  final double weedingProgress;

  ///제초 작업 진행률
  final String weedingUnit;

  ///제초 작업 진행률 단위
  final bool weedingValid;
  final int index;

  Weeding({
    @required this.weedingProgress,
    @required this.weedingUnit,
    @required this.weedingValid,
    @required this.index,
  });

  factory Weeding.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Weeding.fromMap(temp);
  }

  factory Weeding.fromMap(Map<String, dynamic> weeding) {
    return Weeding(
      weedingProgress: weeding['weedingProgress'].toDouble(),
      weedingUnit: weeding['weedingUnit'],
      weedingValid: weeding['weedingValid'],
      index: weeding['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weedingProgress': this.weedingProgress,
      'weedingUnit': this.weedingUnit,
      'weedingValid': this.weedingValid,
      'index': this.index,
    };
  }
}
