import 'package:meta/meta.dart';

class Seeding {
  ///파종 정보
  final double seedingArea;

  ///파종 면적
  final String seedingAreaUnit;

  ///파종 면적 단위
  final double seedingAmount;

  ///파종량
  final String seedingAmountUnit;

  ///파종량 단위
  final bool seedingValid;
  final int index;

  Seeding({
    @required this.seedingArea,
    @required this.seedingAreaUnit,
    @required this.seedingAmount,
    @required this.seedingAmountUnit,
    @required this.seedingValid,
    @required this.index,
  });

  factory Seeding.fromDs(dynamic ds) {
    Map<String, dynamic> temp = Map<String, dynamic>.from(ds);
    return Seeding.fromMap(temp);
  }

  factory Seeding.fromMap(Map<String, dynamic> seeding) {
    return Seeding(
      seedingArea: seeding['seedingArea'].toDouble(),
      seedingAreaUnit: seeding['seedingAreaUnit'],
      seedingAmount: seeding['seedingAmount'].toDouble(),
      seedingAmountUnit: seeding['seedingAmountUnit'],
      seedingValid: seeding['seedingValid'],
      index: seeding['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seedingArea': this.seedingArea,
      'seedingAreaUnit': this.seedingAreaUnit,
      'seedingAmount': this.seedingAmount,
      'seedingAmountUnit': this.seedingAmountUnit,
      'seedingValid': this.seedingValid,
      'index': this.index,
    };
  }
}
