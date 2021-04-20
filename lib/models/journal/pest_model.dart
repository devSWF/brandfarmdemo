import 'package:meta/meta.dart';

class Pest {
  ///병, 해충정보
  final String pestKind;

  ///종류
  final double spreadDegree;

  ///확산정도
  final String spreadDegreeUnit;

  ///확산정도 단위
  final bool pestValid;
  final int index;

  Pest({
    @required this.pestKind,
    @required this.spreadDegree,
    @required this.spreadDegreeUnit,
    @required this.pestValid,
    @required this.index,
  });

  factory Pest.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Pest.fromMap(temp);
  }

  factory Pest.fromMap(Map<String, dynamic> pest) {
    return Pest(
      pestKind: pest['pestKind'],
      spreadDegree: pest['spreadDegree'].toDouble(),
      spreadDegreeUnit: pest['spreadDegreeUnit'],
      pestValid: pest['pestValid'],
      index: pest['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pestKind': this.pestKind,
      'spreadDegree': this.spreadDegree,
      'spreadDegreeUnit': this.spreadDegreeUnit,
      'pestValid': this.pestValid,
      'index': this.index,
    };
  }
}
