import 'dart:io';

import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/journal/widget_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class JournalCreateEvent extends Equatable {
  const JournalCreateEvent();

  @override
  List<Object> get props => [];
}

class DataCheck extends JournalCreateEvent {
  final bool check;

  DataCheck({@required this.check});

  @override
  String toString() => 'DataCheck {DataCheck}';
}

class DateSelected extends JournalCreateEvent {
  final Timestamp selectedDate;

  const DateSelected({@required this.selectedDate});

  @override
  String toString() => 'DateSelected{ SelectedDate: $selectedDate}';
}

class TitleChanged extends JournalCreateEvent {
  final String title;

  const TitleChanged({@required this.title});

  @override
  String toString() {
    return 'TitleChanged{ title: ${title}}';
  }
}

class ContentChanged extends JournalCreateEvent {
  final String content;

  const ContentChanged({@required this.content});

  @override
  String toString() {
    return 'ContentChanged{ content: ${content}}';
  }
}

class CategoryChanged extends JournalCreateEvent {
  final int category;

  const CategoryChanged({@required this.category});

  @override
  String toString() {
    return 'CategoryChanged{ category: ${category}}';
  }
}

///사진정보
class AddImageFile extends JournalCreateEvent {
  final File imgFile;
  final int index;
  final int from;

  AddImageFile({@required this.imgFile, int index, int from})
      : this.index = index ?? 0,
        this.from = from ?? 0;

  @override
  String toString() => 'imgFileChanged { imgFile :${imgFile.path} }';
}

class DeleteImageFile extends JournalCreateEvent {
  final File removedFile;

  DeleteImageFile({@required this.removedFile});

  @override
  String toString() => 'DeleteImageFile { imgFile :${removedFile} }';
}

class AssetImageList extends JournalCreateEvent {
  final List<Asset> assetImage;

  AssetImageList({@required this.assetImage});

  @override
  String toString() =>
      'AssetImageList { AssetImageList :AssetImageListChanged }';
}

///Update Journal


class DeleteExistingImage extends JournalCreateEvent {
  final int index;

  const DeleteExistingImage({
    @required this.index,
  });

  @override
  String toString() {
    return '''DeleteExistingImage {
      index, ${index},
    }''';
  }
}

class ModifyLoading extends JournalCreateEvent{}

class ModifyLoaded extends JournalCreateEvent{}

///출하정보
class ShipmentPlantChanged extends JournalCreateEvent {
  final String plant;

  ShipmentPlantChanged({@required this.plant});

  @override
  String toString() => 'ShipmentPlantChanged { plant :$plant }';
}

class ShipmentPathChanged extends JournalCreateEvent {
  final String path;

  ShipmentPathChanged({@required this.path});

  @override
  String toString() => 'ShipmentPathChanged { path :$path }';
}

class ShipmentUnitChanged extends JournalCreateEvent {
  final double unit;

  ShipmentUnitChanged({@required this.unit});

  @override
  String toString() => 'ShipmentUnitChanged { unit :$unit }';
}

class ShipmentUnitSelectChanged extends JournalCreateEvent {
  final String unitSelect;

  ShipmentUnitSelectChanged({@required this.unitSelect});

  @override
  String toString() => 'ShipmentUnitSelectChanged { unitSelect :$unitSelect }';
}

class ShipmentAmountChanged extends JournalCreateEvent {
  final String amount;

  ShipmentAmountChanged({@required this.amount});

  @override
  String toString() => 'ShipmentAmountChanged { amount :$amount }';
}

class ShipmentGradeChanged extends JournalCreateEvent {
  final String grade;

  ShipmentGradeChanged({@required this.grade});

  @override
  String toString() => 'ShipmentGradeChanged { grade :$grade }';
}

class ShipmentPriceChanged extends JournalCreateEvent {
  final int price;

  ShipmentPriceChanged({@required this.price});

  @override
  String toString() => 'ShipmentPriceChanged { price :$price }';
}

class ShipmentComplete extends JournalCreateEvent {
  final String shipmentPlant;
  final String shipmentPath;
  final double shipmentUnit; //text field
  final String shipmentUnitSelect;
  final String shipmentAmount;
  final String shipmentGrade;
  final int shipmentPrice;

  ShipmentComplete({
    @required this.shipmentPlant,
    @required this.shipmentPath,
    @required this.shipmentUnit,
    @required this.shipmentUnitSelect,
    @required this.shipmentAmount,
    @required this.shipmentGrade,
    @required this.shipmentPrice,
  });

  @override
  String toString() => 'ShipmentComplete Pressed';
}

class ShipmentEdit extends JournalCreateEvent {
  final String shipmentPlant;
  final String shipmentPath;
  final double shipmentUnit; //text field
  final String shipmentUnitSelect;
  final String shipmentAmount;
  final String shipmentGrade;
  final int shipmentPrice;
  final int currentIndex;

  //TODO: listIndex 안 쓰면 지우고 사용되는 곳 정리하기
  final int listIndex;

  ShipmentEdit({
    @required this.shipmentPlant,
    @required this.shipmentPath,
    @required this.shipmentUnit,
    @required this.shipmentUnitSelect,
    @required this.shipmentAmount,
    @required this.shipmentGrade,
    @required this.shipmentPrice,
    @required this.currentIndex,
    @required this.listIndex,
  });

  @override
  String toString() => 'ShipmentEdit Pressed';
}

class ShipmentDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  ShipmentDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Shipment $index is deleted"; // TODO: implement toString
}

///비료정보
class FertilizerMethod extends JournalCreateEvent {
  final String method;

  FertilizerMethod({@required this.method});

  @override
  String toString() => 'FertilizerMethod { method :$method }';
}

class FertilizerAreaChanged extends JournalCreateEvent {
  final double area;

  FertilizerAreaChanged({@required this.area});

  @override
  String toString() => 'FertilizerAreaChanged { area :$area }';
}

class FertilizerAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  FertilizerAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'FertilizerAreaUnitChanged { areaUnit :$areaUnit }';
}

class FertilizerMaterialChanged extends JournalCreateEvent {
  final String material;

  FertilizerMaterialChanged({@required this.material});

  @override
  String toString() => 'FertilizerMaterialChanged { material :$material }';
}

class FertilizerMaterialUseChanged extends JournalCreateEvent {
  final double materialUse;

  FertilizerMaterialUseChanged({@required this.materialUse});

  @override
  String toString() =>
      'FertilizerMaterialUseChanged { materialUse :$materialUse }';
}

class FertilizerMaterialUnitChanged extends JournalCreateEvent {
  final String materialUnit;

  FertilizerMaterialUnitChanged({@required this.materialUnit});

  @override
  String toString() =>
      'FertilizerMaterialUnitChanged { materialUnit :$materialUnit }';
}

class FertilizerWaterUseChanged extends JournalCreateEvent {
  final double waterUse;

  FertilizerWaterUseChanged({@required this.waterUse});

  @override
  String toString() => 'FertilizerWaterUseChanged { waterUse :$waterUse }';
}

class FertilizerWaterUnitChanged extends JournalCreateEvent {
  final String waterUnit;

  FertilizerWaterUnitChanged({@required this.waterUnit});

  @override
  String toString() => 'FertilizerWaterUnitChanged { price :$waterUnit }';
}

class FertilizerComplete extends JournalCreateEvent {
  final String fertilizerMethod;
  final double fertilizerArea;
  final String fertilizerAreaUnit;
  final String fertilizerMaterialName;
  final double fertilizerMaterialUse;
  final String fertilizerMaterialUnit;
  final double fertilizerWater;
  final String fertilizerWaterUnit;

  FertilizerComplete({
    @required this.fertilizerMethod,
    @required this.fertilizerArea,
    @required this.fertilizerAreaUnit,
    @required this.fertilizerMaterialName,
    @required this.fertilizerMaterialUse,
    @required this.fertilizerMaterialUnit,
    @required this.fertilizerWater,
    @required this.fertilizerWaterUnit,
  });

  @override
  String toString() => 'FertilizerComplete Pressed';
}

class FertilizerEdit extends JournalCreateEvent {
  final String fertilizerMethod;
  final double fertilizerArea;
  final String fertilizerAreaUnit;
  final String fertilizerMaterialName;
  final double fertilizerMaterialUse;
  final String fertilizerMaterialUnit;
  final double fertilizerWater;
  final String fertilizerWaterUnit;
  final int currentIndex;

  FertilizerEdit({
    @required this.fertilizerMethod,
    @required this.fertilizerArea,
    @required this.fertilizerAreaUnit,
    @required this.fertilizerMaterialName,
    @required this.fertilizerMaterialUse,
    @required this.fertilizerMaterialUnit,
    @required this.fertilizerWater,
    @required this.fertilizerWaterUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'FertilizerEdit Pressed';
}

class FertilizerDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  FertilizerDelete({@required this.index, @required this.listIndex});

  @override
  String toString() =>
      "Fertilizer $index is deleted"; // TODO: implement toString
}

///농약정보
class PesticideMethod extends JournalCreateEvent {
  final String method;

  PesticideMethod({@required this.method});

  @override
  String toString() => 'PesticideMethod { method :$method }';
}

class PesticideAreaChanged extends JournalCreateEvent {
  final double area;

  PesticideAreaChanged({@required this.area});

  @override
  String toString() => 'PesticideAreaChanged { area :$area }';
}

class PesticideAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  PesticideAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'PesticideAreaUnitChanged { areaUnit :$areaUnit }';
}

class PesticideMaterialChanged extends JournalCreateEvent {
  final String material;

  PesticideMaterialChanged({@required this.material});

  @override
  String toString() => 'PesticideMaterialChanged { material :$material }';
}

class PesticideMaterialUseChanged extends JournalCreateEvent {
  final double materialUse;

  PesticideMaterialUseChanged({@required this.materialUse});

  @override
  String toString() =>
      'PesticideMaterialUseChanged { materialUse :$materialUse }';
}

class PesticideMaterialUnitChanged extends JournalCreateEvent {
  final String materialUnit;

  PesticideMaterialUnitChanged({@required this.materialUnit});

  @override
  String toString() =>
      'PesticideMaterialUnitChanged { materialUnit :$materialUnit }';
}

class PesticideWaterUseChanged extends JournalCreateEvent {
  final double waterUse;

  PesticideWaterUseChanged({@required this.waterUse});

  @override
  String toString() => 'PesticideWaterUseChanged { waterUse :$waterUse }';
}

class PesticideWaterUnitChanged extends JournalCreateEvent {
  final String waterUnit;

  PesticideWaterUnitChanged({@required this.waterUnit});

  @override
  String toString() => 'PesticideWaterUnitChanged { waterUnit :$waterUnit }';
}

class PesticideExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'PesticideExpansionChanged { PesticideExpansionChanged :PesticideExpansionChanged }';
}

class PesticideComplete extends JournalCreateEvent {
  final String pesticideMethod;
  final double pesticideArea;
  final String pesticideAreaUnit;
  final String pesticideMaterialName;
  final double pesticideMaterialUse;
  final String pesticideMaterialUnit;
  final double pesticideWater;
  final String pesticideWaterUnit;

  PesticideComplete({
    @required this.pesticideMethod,
    @required this.pesticideArea,
    @required this.pesticideAreaUnit,
    @required this.pesticideMaterialName,
    @required this.pesticideMaterialUse,
    @required this.pesticideMaterialUnit,
    @required this.pesticideWater,
    @required this.pesticideWaterUnit,
  });

  @override
  String toString() => 'PesticideComplete Pressed';
}

class PesticideEdit extends JournalCreateEvent {
  final String pesticideMethod;
  final double pesticideArea;
  final String pesticideAreaUnit;
  final String pesticideMaterialName;
  final double pesticideMaterialUse;
  final String pesticideMaterialUnit;
  final double pesticideWater;
  final String pesticideWaterUnit;
  final int currentIndex;

  PesticideEdit({
    @required this.pesticideMethod,
    @required this.pesticideArea,
    @required this.pesticideAreaUnit,
    @required this.pesticideMaterialName,
    @required this.pesticideMaterialUse,
    @required this.pesticideMaterialUnit,
    @required this.pesticideWater,
    @required this.pesticideWaterUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'PesticideEdit Pressed';
}

class PesticideDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  PesticideDelete({@required this.index, @required this.listIndex});

  @override
  String toString() =>
      "Pesticide $index is deleted"; // TODO: implement toString
}

///병,해충 정보
class PestKindChanged extends JournalCreateEvent {
  final String kind;

  PestKindChanged({@required this.kind});

  @override
  String toString() => 'PestKindChanged { kind :$kind }';
}

class SpreadDegreeChanged extends JournalCreateEvent {
  final double degree;

  SpreadDegreeChanged({@required this.degree});

  @override
  String toString() => 'SpreadDegreeChanged { degree :$degree }';
}

class SpreadDegreeUnitChanged extends JournalCreateEvent {
  final String degreeUnit;

  SpreadDegreeUnitChanged({@required this.degreeUnit});

  @override
  String toString() => 'SpreadDegreeUnitChanged { waterUnit :$degreeUnit }';
}

class PestExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'PestExpansionChanged { PestExpansionChanged :PestExpansionChanged }';
}

class PestComplete extends JournalCreateEvent {
  final String pestKind;
  final double spreadDegree;
  final String spreadDegreeUnit;

  PestComplete({
    @required this.pestKind,
    @required this.spreadDegree,
    @required this.spreadDegreeUnit,
  });

  @override
  String toString() => 'PestComplete Pressed';
}

class PestEdit extends JournalCreateEvent {
  final String pestKind;
  final double spreadDegree;
  final String spreadDegreeUnit;
  final int currentIndex;

  PestEdit({
    @required this.pestKind,
    @required this.spreadDegree,
    @required this.spreadDegreeUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'PestEdit Pressed';
}

class PestDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  PestDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Pest $index is deleted"; // TODO: implement toString
}

///정식정보
class PlantingAreaChanged extends JournalCreateEvent {
  final double area;

  PlantingAreaChanged({@required this.area});

  @override
  String toString() => 'PlantingAreaChanged { area :$area }';
}

class PlantingAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  PlantingAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'PlantingAreaUnitChanged { areaUnit :$areaUnit }';
}

class PlantingCountChanged extends JournalCreateEvent {
  final String count;

  PlantingCountChanged({@required this.count});

  @override
  String toString() => 'PlantingCountChanged { count :$count }';
}

class PlantingPriceChanged extends JournalCreateEvent {
  final int price;

  PlantingPriceChanged({@required this.price});

  @override
  String toString() => 'PlantingPriceChanged { price :$price }';
}

class PlantingExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'PlantingExpansionChanged { PlantingExpansionChanged :PlantingExpansionChanged }';
}

class PlantingComplete extends JournalCreateEvent {
  final double plantingArea;
  final String plantingAreaUnit;
  final String plantingCount;
  final int plantingPrice;

  PlantingComplete({
    @required this.plantingArea,
    @required this.plantingAreaUnit,
    @required this.plantingCount,
    @required this.plantingPrice,
  });

  @override
  String toString() => 'PlantingComplete Pressed';
}

class PlantingEdit extends JournalCreateEvent {
  final double plantingArea;
  final String plantingAreaUnit;
  final String plantingCount;
  final int plantingPrice;
  final int currentIndex;

  PlantingEdit({
    @required this.plantingArea,
    @required this.plantingAreaUnit,
    @required this.plantingCount,
    @required this.plantingPrice,
    @required this.currentIndex,
  });

  @override
  String toString() => 'PlantingEdit Pressed';
}

class PlantingDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  PlantingDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Planting $index is deleted"; // TODO: implement toString
}

///파종정식
class SeedingAreaChanged extends JournalCreateEvent {
  final double area;

  SeedingAreaChanged({@required this.area});

  @override
  String toString() => 'SeedingAreaChanged { area :$area }';
}

class SeedingAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  SeedingAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'SeedingAreaUnitChanged { areaUnit :$areaUnit }';
}

class SeedingAmountChanged extends JournalCreateEvent {
  final double amount;

  SeedingAmountChanged({@required this.amount});

  @override
  String toString() => 'SeedingAmountChanged { count :$amount }';
}

class SeedingAmountUnitChanged extends JournalCreateEvent {
  final String amountUnit;

  SeedingAmountUnitChanged({@required this.amountUnit});

  @override
  String toString() => 'SeedingAmountUnitChanged { amountUnit :$amountUnit }';
}

class SeedingExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'SeedingExpansionChanged { SeedingExpansionChanged :SeedingExpansionChanged }';
}

class SeedingComplete extends JournalCreateEvent {
  final double seedingArea;
  final String seedingAreaUnit;
  final double seedingAmount;
  final String seedingAmountUnit;

  SeedingComplete({
    @required this.seedingArea,
    @required this.seedingAreaUnit,
    @required this.seedingAmount,
    @required this.seedingAmountUnit,
  });

  @override
  String toString() => 'SeedingComplete Pressed';
}

class SeedingEdit extends JournalCreateEvent {
  final double seedingArea;
  final String seedingAreaUnit;
  final double seedingAmount;
  final String seedingAmountUnit;
  final int currentIndex;

  SeedingEdit({
    @required this.seedingArea,
    @required this.seedingAreaUnit,
    @required this.seedingAmount,
    @required this.seedingAmountUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'SeedingEdit Pressed';
}

class SeedingDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  SeedingDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Seeding $index is deleted"; // TODO: implement toString
}

///제초정보
class WeedingProgressChanged extends JournalCreateEvent {
  final double progress;

  WeedingProgressChanged({@required this.progress});

  @override
  String toString() => 'WeedingProgressChanged { progress :$progress }';
}

class WeedingUnitChanged extends JournalCreateEvent {
  final String weedingUnit;

  WeedingUnitChanged({@required this.weedingUnit});

  @override
  String toString() => 'WeedingUnitChanged { weedingUnit :$weedingUnit }';
}

class WeedingExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'WeedingExpansionChanged { WeedingExpansionChanged :WeedingExpansionChanged }';
}

class WeedingComplete extends JournalCreateEvent {
  final double weedingProgress;
  final String weedingUnit;

  WeedingComplete({@required this.weedingProgress, @required this.weedingUnit});

  @override
  String toString() => 'WeedingComplete Pressed';
}

class WeedingEdit extends JournalCreateEvent {
  final double weedingProgress;
  final String weedingUnit;
  final int currentIndex;

  WeedingEdit(
      {@required this.weedingProgress,
      @required this.weedingUnit,
      @required this.currentIndex});

  @override
  String toString() => 'WeedingEdit Pressed';
}

class WeedingDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  WeedingDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Weeding $index is deleted"; // TODO: implement toString
}

///관수정보
class WateringAreaChanged extends JournalCreateEvent {
  final double area;

  WateringAreaChanged({@required this.area});

  @override
  String toString() => 'WateringAreaChanged { area :$area }';
}

class WateringAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  WateringAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'WateringAreaUnitChanged { areaUnit :$areaUnit }';
}

class WateringAmountChanged extends JournalCreateEvent {
  final double amount;

  WateringAmountChanged({@required this.amount});

  @override
  String toString() => 'WateringAmountChanged { count :$amount }';
}

class WateringAmountUnitChanged extends JournalCreateEvent {
  final String amountUnit;

  WateringAmountUnitChanged({@required this.amountUnit});

  @override
  String toString() => 'WateringAmountUnitChanged { amountUnit :$amountUnit }';
}

class WateringExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'WateringExpansionChanged { WateringExpansionChanged :WateringExpansionChanged }';
}

class WateringComplete extends JournalCreateEvent {
  final double wateringArea;
  final String wateringAreaUnit;
  final double wateringAmount;
  final String wateringAmountUnit;

  WateringComplete({
    @required this.wateringArea,
    @required this.wateringAmountUnit,
    @required this.wateringAmount,
    @required this.wateringAreaUnit,
  });

  @override
  String toString() => 'WateringComplete Pressed';
}

class WateringEdit extends JournalCreateEvent {
  final double wateringArea;
  final String wateringAreaUnit;
  final double wateringAmount;
  final String wateringAmountUnit;
  final int currentIndex;

  WateringEdit({
    @required this.wateringArea,
    @required this.wateringAmountUnit,
    @required this.wateringAmount,
    @required this.wateringAreaUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'WateringEdit Pressed';
}

class WateringDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  WateringDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Watering $index is deleted"; // TODO: implement toString
}

///인력투입정보
class WorkforceNumChanged extends JournalCreateEvent {
  final int workforceNum;

  WorkforceNumChanged({@required this.workforceNum});

  @override
  String toString() => 'WorkforceNumChanged {WorkforceNum : $workforceNum}';
}

class WorkforcePriceChanged extends JournalCreateEvent {
  final int workforcePrice;

  WorkforcePriceChanged({@required this.workforcePrice});

  @override
  String toString() =>
      'WorkforcePriceChanged {workforcePrice : $workforcePrice}';
}

class WorkforceExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'WorkforceExpansionChanged { WorkforceExpansionChanged :WorkforceExpansionChanged }';
}

class WorkforceComplete extends JournalCreateEvent {
  final int workforceNum;
  final int workforcePrice;

  WorkforceComplete({
    @required this.workforceNum,
    @required this.workforcePrice,
  });

  @override
  String toString() => 'WorkforceComplete Pressed';
}

class WorkforceEdit extends JournalCreateEvent {
  final int workforceNum;
  final int workforcePrice;
  final int currentIndex;

  WorkforceEdit({
    @required this.workforceNum,
    @required this.workforcePrice,
    @required this.currentIndex,
  });

  @override
  String toString() => 'WorkforceEdit Pressed';
}

class WorkforceDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  WorkforceDelete({@required this.index, @required this.listIndex});

  @override
  String toString() =>
      "Workforce $index is deleted"; // TODO: implement toString
}

///경운정보
class FarmingAreaChanged extends JournalCreateEvent {
  final double area;

  FarmingAreaChanged({@required this.area});

  @override
  String toString() => 'FarmingAreaChanged { area :$area }';
}

class FarmingAreaUnitChanged extends JournalCreateEvent {
  final String areaUnit;

  FarmingAreaUnitChanged({@required this.areaUnit});

  @override
  String toString() => 'FarmingAreaUnitChanged { areaUnit :$areaUnit }';
}

class FarmingMethodChanged extends JournalCreateEvent {
  final String method;

  FarmingMethodChanged({@required this.method});

  @override
  String toString() => 'FarmingMethodChanged { method :$method }';
}

class FarmingMethodUnitChanged extends JournalCreateEvent {
  final String methodUnit;

  FarmingMethodUnitChanged({@required this.methodUnit});

  @override
  String toString() => 'WateringAmountUnitChanged { amountUnit :$methodUnit }';
}

class FarmingExpansionChanged extends JournalCreateEvent {
  @override
  String toString() =>
      'FarmingExpansionChanged { FarmingExpansionChanged :FarmingExpansionChanged }';
}

class FarmingComplete extends JournalCreateEvent {
  final double farmingArea;
  final String farmingAreaUnit;
  final String farmingMethod;
  final String farmingMethodUnit;

  FarmingComplete({
    @required this.farmingArea,
    @required this.farmingAreaUnit,
    @required this.farmingMethod,
    @required this.farmingMethodUnit,
  });

  @override
  String toString() => 'FarmingComplete Pressed';
}

class FarmingEdit extends JournalCreateEvent {
  final double farmingArea;
  final String farmingAreaUnit;
  final String farmingMethod;
  final String farmingMethodUnit;
  final int currentIndex;

  FarmingEdit({
    @required this.farmingArea,
    @required this.farmingAreaUnit,
    @required this.farmingMethod,
    @required this.farmingMethodUnit,
    @required this.currentIndex,
  });

  @override
  String toString() => 'FarmingEdit Pressed';
}

class FarmingDelete extends JournalCreateEvent {
  final int index;
  final int listIndex;

  FarmingDelete({@required this.index, @required this.listIndex});

  @override
  String toString() => "Farming $index is deleted"; // TODO: implement toString
}

///completbtn
class UpdateJournal extends JournalCreateEvent {
  UpdateJournal() : super();

  @override
  String toString() =>
      'UpdateJournal { WriteCompleteChanged :WriteCompleteChanged }';
}

class NewWriteCompleteChanged extends JournalCreateEvent {
  NewWriteCompleteChanged() : super();

  @override
  String toString() =>
      'WriteCompleteChanged { NewWriteCompleteChanged :NewWriteCompleteChanged }';
}

class PastBtnChanged extends JournalCreateEvent {
  @override
  String toString() => 'PastBtnChanged { PastBtnChanged :PastBtnChanged }';
}

class SelectDateTimePressed extends JournalCreateEvent {
  @override
  String toString() => 'SelectDateTimePressed';
}

class ChangeCategoryPressed extends JournalCreateEvent {
  @override
  String toString() => 'AddCategoryBtnPressed';
}

class JournalInitialized extends JournalCreateEvent {
  final Journal existJournal;
  final List<ImagePicture> existImage;

  JournalInitialized(
      {this.existJournal,
      this.existImage});

  @override
  String toString() => 'JournalInitialized';
}

//GetInitWroteDate
class GetInitWroteDate extends JournalCreateEvent {
  @override
  String toString() => "GetInitWroteDate";
}


class WidgetListLoaded extends JournalCreateEvent {
  final List<Widgets> widgets;

  WidgetListLoaded({@required this.widgets});

  @override
  String toString() => "WidgetList loaded";
}

class DeleteJournalGrpPressed extends JournalCreateEvent {
  @override
  String toString() => "DeleteJournalGrpPressed";
}

//==================================
class EditJournalFid extends JournalCreateEvent {
  final String year;
  final String month;
  final String day;

  EditJournalFid(
      {@required this.year, @required this.month, @required this.day});

  @override
  String toString() => "EditJournalFid";
}

class IsEditChanged extends JournalCreateEvent {
  final bool isEdit;

  IsEditChanged({@required this.isEdit});

  @override
  String toString() => "IsEditChanged";
}

class UnSelectDateTimePressed extends JournalCreateEvent {
  final DateTime picked;

  UnSelectDateTimePressed({@required this.picked});

  @override
  String toString() => "UnSelectDateTimePressed";
}
