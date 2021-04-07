import 'dart:io';

import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/farming_model.dart';
import 'package:BrandFarm/models/journal/fertilize_model.dart';
import 'package:BrandFarm/models/journal/gallery_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/journal/pest_model.dart';
import 'package:BrandFarm/models/journal/pesticide_model.dart';
import 'package:BrandFarm/models/journal/planting_model.dart';
import 'package:BrandFarm/models/journal/seeding_model.dart';
import 'package:BrandFarm/models/journal/shipment_model.dart';
import 'package:BrandFarm/models/journal/watering_model.dart';
import 'package:BrandFarm/models/journal/weeding_model.dart';
import 'package:BrandFarm/models/journal/widget_model.dart';
import 'package:BrandFarm/models/journal/workforce_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class JournalCreateState {
  final Timestamp selectedDate;
  final String title;
  final int category;
  final bool checkData;
  final String jid;
  final String content;
  final List<String> tag;
  final List<String> originalTag;

  final List<Widgets> widgets;
  final List<String> widgetList;
  final List<Map<String, dynamic>> categories;
  final bool selectDatePressed;
  final bool changeCategoryPressed;
  final bool isNewWrite;
  final List<DateTime> wroteDate;
  final bool pastBtn;
  final bool writeComplete;
  final bool buttonSelected;
  final bool isDeleted;
  final bool isSuggestion;

  final List<Journal> journal;
  final bool isEditDate;
  final bool isLoading;

  ///Edit Journal
  final Journal existJournal;
  final Journal bufferJournal;

  ///사진정보
  final List<File> imageList;
  final List<Asset> assetList;
  final List<ImagePicture> existImageList;
  final List<ImagePicture> removedImageList;

  ///출하정보
  final String shipmentPlant;
  final String shipmentPath;
  final double shipmentUnit; //text field
  final String shipmentUnitSelect;
  final String shipmentAmount;
  final String shipmentGrade;
  final int shipmentPrice;
  final bool shipmentValid;
  final bool shipmentExpansion;
  final Shipment shipment;
  final List<Shipment> shipmentList;

  ///비료정보
  final String fertilizerMethod;
  final double fertilizerArea;
  final String fertilizerAreaUnit;
  final String fertilizerMaterialName;
  final double fertilizerMaterialUse;
  final String fertilizerMaterialUnit;
  final double fertilizerWater;
  final String fertilizerWaterUnit;
  final bool fertilizerValid;
  final bool fertilizerExpansion;
  final Fertilize fertilizer;
  final List<Fertilize> fertilizerList;

  ///농약정보
  final String pesticideMethod;
  final double pesticideArea;
  final String pesticideAreaUnit;
  final String pesticideMaterialName;
  final double pesticideMaterialUse;
  final String pesticideMaterialUnit;
  final double pesticideWater;
  final String pesticideWaterUnit;
  final bool pesticideValid;
  final bool pesticideExpansion;
  final Pesticide pesticide;
  final List<Pesticide> pesticideList;

  ///병,해충 정보
  final String pestKind;
  final double spreadDegree;
  final String spreadDegreeUnit;
  final bool pestValid;
  final bool pestExpansion;
  final Pest pest;
  final List<Pest> pestList;

  ///정식 정보
  final double plantingArea;
  final String plantingAreaUnit;
  final String plantingCount;
  final int plantingPrice;
  final bool plantingValid;
  final bool plantingExpansion;
  final Planting planting;
  final List<Planting> plantingList;

  ///파종정보
  final double seedingArea;
  final String seedingAreaUnit;
  final double seedingAmount;
  final String seedingAmountUnit;
  final bool seedingValid;
  final bool seedingExpansion;
  final Seeding seeding;
  final List<Seeding> seedingList;

  ///제초정보
  final double weedingProgress;
  final String weedingUnit;
  final bool weedingValid;
  final bool weedingExpansion;
  final Weeding weeding;
  final List<Weeding> weedingList;

  ///관수정보
  final double wateringArea;
  final String wateringAreaUnit;
  final double wateringAmount;
  final String wateringAmountUnit;
  final bool wateringValid;
  final bool wateringExpansion;
  final Watering watering;
  final List<Watering> wateringList;

  ///인력투입 정보
  final int workforceNum;
  final int workforcePrice;
  final bool workforceValid;
  final bool workforceExpansion;
  final Workforce workforce;
  final List<Workforce> workforceList;

  ///경운정보
  final double farmingArea;
  final String farmingAreaUnit;
  final String farmingMethod;
  final String farmingMethodUnit;
  final bool farmingValid;
  final bool farmingExpansion;
  final Farming farming;
  final List<Farming> farmingList;

  JournalCreateState({
    @required this.selectedDate,
    @required this.title,
    @required this.category,
    @required this.checkData,
    @required this.jid,
    @required this.content,
    @required this.tag,
    @required this.originalTag,
    // @required this.date,
    @required this.widgets,
    @required this.widgetList,
    @required this.selectDatePressed,
    @required this.changeCategoryPressed,
    @required this.pastBtn,
    @required this.writeComplete,
    @required this.categories,
    @required this.isNewWrite,
    @required this.wroteDate,
    @required this.buttonSelected,
    @required this.isDeleted,
    @required this.isSuggestion,
    @required this.journal,
    @required this.isEditDate,
    @required this.isLoading,

    ///Edit Journal
    @required this.existJournal,
    @required this.bufferJournal,

    ///사진정보
    @required this.imageList,
    @required this.assetList,
    @required this.existImageList,
    @required this.removedImageList,

    ///출하정보
    @required this.shipmentPlant,
    @required this.shipmentPath,
    @required this.shipmentUnit,
    @required this.shipmentUnitSelect,
    @required this.shipmentAmount,
    @required this.shipmentGrade,
    @required this.shipmentPrice,
    @required this.shipmentValid,
    @required this.shipmentExpansion,
    @required this.shipment,
    @required this.shipmentList,

    ///비료정보
    @required this.fertilizerMethod,
    @required this.fertilizerArea,
    @required this.fertilizerAreaUnit,
    @required this.fertilizerMaterialName,
    @required this.fertilizerMaterialUse,
    @required this.fertilizerMaterialUnit,
    @required this.fertilizerWater,
    @required this.fertilizerWaterUnit,
    @required this.fertilizerValid,
    @required this.fertilizerExpansion,
    @required this.fertilizer,
    @required this.fertilizerList,

    ///농약정보
    @required this.pesticideMethod,
    @required this.pesticideArea,
    @required this.pesticideAreaUnit,
    @required this.pesticideMaterialName,
    @required this.pesticideMaterialUse,
    @required this.pesticideMaterialUnit,
    @required this.pesticideWater,
    @required this.pesticideWaterUnit,
    @required this.pesticideValid,
    @required this.pesticideExpansion,
    @required this.pesticide,
    @required this.pesticideList,

    ///병,해충 정보
    @required this.pestKind,
    @required this.spreadDegree,
    @required this.spreadDegreeUnit,
    @required this.pestValid,
    @required this.pestExpansion,
    @required this.pest,
    @required this.pestList,

    ///정식 정보
    @required this.plantingArea,
    @required this.plantingAreaUnit,
    @required this.plantingCount,
    @required this.plantingPrice,
    @required this.plantingValid,
    @required this.plantingExpansion,
    @required this.planting,
    @required this.plantingList,

    ///파종정보
    @required this.seedingArea,
    @required this.seedingAreaUnit,
    @required this.seedingAmount,
    @required this.seedingAmountUnit,
    @required this.seedingValid,
    @required this.seedingExpansion,
    @required this.seeding,
    @required this.seedingList,

    ///제초정보
    @required this.weedingProgress,
    @required this.weedingUnit,
    @required this.weedingValid,
    @required this.weedingExpansion,
    @required this.weeding,
    @required this.weedingList,

    ///관수정보
    @required this.wateringArea,
    @required this.wateringAreaUnit,
    @required this.wateringAmount,
    @required this.wateringAmountUnit,
    @required this.wateringValid,
    @required this.wateringExpansion,
    @required this.watering,
    @required this.wateringList,

    ///인력투입정보
    @required this.workforceNum,
    @required this.workforcePrice,
    @required this.workforceValid,
    @required this.workforceExpansion,
    @required this.workforce,
    @required this.workforceList,

    ///경운정보
    @required this.farmingArea,
    @required this.farmingAreaUnit,
    @required this.farmingMethod,
    @required this.farmingMethodUnit,
    @required this.farmingValid,
    @required this.farmingExpansion,
    @required this.farming,
    @required this.farmingList,
  });

  factory JournalCreateState.empty() {
    String month;
    String day;
    if (DateTime.now().month < 10) {
      month = '0${DateTime.now().month}';
    } else {
      month = '${DateTime.now().month}';
    }
    if (DateTime.now().day < 10) {
      day = '0${DateTime.now().day}';
    } else {
      day = '${DateTime.now().day}';
    }
    return JournalCreateState(
      selectedDate: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.parse('${DateTime.now().year}${month}${day}')
              .millisecondsSinceEpoch),
      title: '',
      category: -1,

      checkData: false,
      jid: "",
      content: "",
      tag: [],
      originalTag: [],
      widgets: [],
      widgetList: [],
      selectDatePressed: false,
      changeCategoryPressed: false,
      pastBtn: false,
      writeComplete: false,
      categories: [],
      isNewWrite: true,
      wroteDate: [],
      buttonSelected: false,
      isDeleted: false,
      isSuggestion: false,

      journal: [],
      isEditDate: false,
      isLoading: false,

      ///Edit Journal
      existJournal: Journal.empty(),
      bufferJournal: Journal.empty(),

      ///사진정보
      imageList: [],
      assetList: [],
      existImageList: [],
      removedImageList: [],

      ///출하정보
      shipmentPlant: "",
      shipmentPath: "",
      shipmentUnit: 0,
      shipmentUnitSelect: "Kg",
      shipmentAmount: "",
      shipmentGrade: "특",
      shipmentPrice: 0,
      shipmentValid: false,
      shipmentExpansion: false,
      shipment: null,
      shipmentList: [],

      ///비료정보
      fertilizerMethod: "엽면살포",
      fertilizerArea: 0,
      fertilizerAreaUnit: "%",
      fertilizerMaterialName: "",
      fertilizerMaterialUse: 0,
      fertilizerMaterialUnit: "g(ml)",
      fertilizerWater: 0,
      fertilizerWaterUnit: "리터",
      fertilizerValid: false,
      fertilizerExpansion: false,
      fertilizer: null,
      fertilizerList: [],

      ///농약정보
      pesticideMethod: "엽면살포",
      pesticideArea: 0,
      pesticideAreaUnit: "%",
      pesticideMaterialName: "",
      pesticideMaterialUse: 0,
      pesticideMaterialUnit: "g(ml)",
      pesticideWater: 0,
      pesticideWaterUnit: "리터",
      pesticideValid: false,
      pesticideExpansion: false,
      pesticide: null,
      pesticideList: [],

      ///병,해충 정보
      pestKind: "",
      spreadDegree: 0,
      spreadDegreeUnit: "%",
      pestValid: false,
      pestExpansion: false,
      pest: null,
      pestList: [],

      ///정식 정보
      plantingArea: 0,
      plantingAreaUnit: "%",
      plantingCount: "",
      plantingPrice: 0,
      plantingValid: false,
      plantingExpansion: false,
      planting: null,
      plantingList: [],

      ///파종정보
      seedingArea: 0,
      seedingAreaUnit: "%",
      seedingAmount: 0,
      seedingAmountUnit: "kg",
      seedingValid: false,
      seedingExpansion: false,
      seeding: null,
      seedingList: [],

      ///제초정보
      weedingProgress: 0,
      weedingUnit: "%",
      weedingValid: false,
      weedingExpansion: false,
      weeding: null,
      weedingList: [],

      ///관수정보
      wateringArea: 0,
      wateringAreaUnit: "%",
      wateringAmount: 0,
      wateringAmountUnit: "리터",
      wateringValid: false,
      wateringExpansion: false,
      watering: null,
      wateringList: [],

      ///인력투입 정보
      workforceNum: 0,
      workforcePrice: 0,
      workforceValid: false,
      workforceExpansion: false,
      workforce: null,
      workforceList: [],

      ///관수정보
      farmingArea: 0,
      farmingAreaUnit: "%",
      farmingMethod: "",
      farmingMethodUnit: "로터리",
      farmingValid: false,
      farmingExpansion: false,
      farming: null,
      farmingList: [],
    );
  }

  JournalCreateState update({
    Timestamp selectedDate,
    bool checkData,
    int category,
    String jid,
    String title,
    String content,
    List<String> tag,
    List<String> originalTag,
    DateTime date,
    List<Widgets> widgets,
    List<String> widgetList,
    List<Map<String, dynamic>> categories,
    bool selectDatePressed,
    bool changeCategoryPressed,
    bool pastBtn,
    bool writeComplete,
    bool isNewWrite,
    bool buttonSelected,
    bool isDeleted,
    bool isSuggestion,
    List<DateTime> wroteDate,
    List<Journal> journal,
    bool isEditDate,
    List<GalleryModel> pictures,
    DateTime picked,
    bool isLoading,

    ///Edit Journal
    Journal existJournal,
    Journal bufferJournal,

    ///사진정보
    List<File> imageList,
    List<Asset> assetList,
    List<ImagePicture> existImageList,
    List<ImagePicture> removedImageList,

    ///출하정보
    String shipmentPlant,
    String shipmentPath,
    double shipmentUnit, //text field
    String shipmentUnitSelect,
    String shipmentAmount,
    String shipmentGrade,
    int shipmentPrice,
    bool shipmentValid,
    bool shipmentExpansion,
    Shipment shipment,
    List<Shipment> shipmentList,

    ///비료정보
    String fertilizerMethod,
    double fertilizerArea,
    String fertilizerAreaUnit,
    String fertilizerMaterialName,
    double fertilizerMaterialUse,
    String fertilizerMaterialUnit,
    double fertilizerWater,
    String fertilizerWaterUnit,
    bool fertilizerValid,
    bool fertilizerExpansion,
    Fertilize fertilizer,
    List<Fertilize> fertilizerList,

    ///농약정보
    String pesticideMethod,
    double pesticideArea,
    String pesticideAreaUnit,
    String pesticideMaterialName,
    double pesticideMaterialUse,
    String pesticideMaterialUnit,
    double pesticideWater,
    String pesticideWaterUnit,
    bool pesticideValid,
    bool pesticideExpansion,
    Pesticide pesticide,
    List<Pesticide> pesticideList,

    ///병,해충정보
    String pestKind,
    double spreadDegree,
    String spreadDegreeUnit,
    bool pestValid,
    bool pestExpansion,
    Pest pest,
    List<Pest> pestList,

    ///정식 정보
    double plantingArea,
    String plantingAreaUnit,
    String plantingCount,
    int plantingPrice,
    bool plantingValid,
    bool plantingExpansion,
    Planting planting,
    List<Planting> plantingList,

    ///파종정보
    double seedingArea,
    String seedingAreaUnit,
    double seedingAmount,
    String seedingAmountUnit,
    bool seedingValid,
    bool seedingExpansion,
    Seeding seeding,
    List<Seeding> seedingList,

    ///제초정보
    double weedingProgress,
    String weedingUnit,
    bool weedingValid,
    bool weedingExpansion,
    Weeding weeding,
    List<Weeding> weedingList,

    ///관수정보
    double wateringArea,
    String wateringAreaUnit,
    double wateringAmount,
    String wateringAmountUnit,
    bool wateringValid,
    bool wateringExpansion,
    Watering watering,
    List<Watering> wateringList,

    ///인력투입정보
    int workforceNum,
    int workforcePrice,
    bool workforceValid,
    bool workforceExpansion,
    Workforce workforce,
    List<Workforce> workforceList,

    ///farming정보
    double farmingArea,
    String farmingAreaUnit,
    String farmingMethod,
    String farmingMethodUnit,
    bool farmingValid,
    bool farmingExpansion,
    Farming farming,
    List<Farming> farmingList,
  }) {
    return copyWith(
      selectedDate: selectedDate,
      checkData: checkData,
      category: category,
      jid: jid,
      title: title,
      content: content,
      tag: tag,
      originalTag: originalTag,
      date: date,
      widgets: widgets,
      widgetList: widgetList,
      categories: categories,
      isNewWrite: isNewWrite,
      wroteDate: wroteDate,
      selectDatePressed: selectDatePressed,
      changeCategoryPressed: changeCategoryPressed,
      pastBtn: pastBtn,
      writeComplete: writeComplete,
      buttonSelected: buttonSelected,
      isDeleted: isDeleted,
      isSuggestion: isSuggestion,
      journal: journal,
      isEditDate: isEditDate,
      pictures: pictures,
      picked: picked,
      isLoading: isLoading,

      ///Edit Journal
      existJournal: existJournal,
      bufferJournal: bufferJournal,

      ///사진정보
      imageList: imageList,
      assetList: assetList,
      existImageList: existImageList,
      removedImageList: removedImageList,

      ///출하정보
      shipmentPlant: shipmentPlant,
      shipmentPath: shipmentPath,
      shipmentUnit: shipmentUnit,
      shipmentUnitSelect: shipmentUnitSelect,
      shipmentAmount: shipmentAmount,
      shipmentGrade: shipmentGrade,
      shipmentPrice: shipmentPrice,
      shipmentValid: shipmentValid,
      shipmentExpansion: shipmentExpansion,
      shipment: shipment,
      shipmentList: shipmentList,

      ///비료정보
      fertilizerMethod: fertilizerMethod,
      fertilizerArea: fertilizerArea,
      fertilizerAreaUnit: fertilizerAreaUnit,
      fertilizerMaterialName: fertilizerMaterialName,
      fertilizerMaterialUse: fertilizerMaterialUse,
      fertilizerMaterialUnit: fertilizerMaterialUnit,
      fertilizerWater: fertilizerWater,
      fertilizerWaterUnit: fertilizerWaterUnit,
      fertilizerValid: farmingValid,
      fertilizerExpansion: fertilizerExpansion,
      fertilizer: fertilizer,
      fertilizerList: fertilizerList,

      ///농약정보
      pesticideMethod: pesticideMethod,
      pesticideArea: pesticideArea,
      pesticideAreaUnit: pesticideAreaUnit,
      pesticideMaterialName: pesticideMaterialName,
      pesticideMaterialUse: pesticideMaterialUse,
      pesticideMaterialUnit: pesticideMaterialUnit,
      pesticideWater: pesticideWater,
      pesticideWaterUnit: pesticideWaterUnit,
      pesticideValid: pesticideValid,
      pesticideExpansion: pesticideExpansion,
      pesticideList: pesticideList,
      pesticide: pesticide,

      ///병,해충정보
      pestKind: pestKind,
      spreadDegree: spreadDegree,
      spreadDegreeUnit: spreadDegreeUnit,
      pestValid: pestValid,
      pestExpansion: pestExpansion,
      pest: pest,
      pestList: pestList,

      ///정식 정보
      plantingArea: plantingArea,
      plantingAreaUnit: plantingAreaUnit,
      plantingCount: plantingCount,
      plantingPrice: plantingPrice,
      plantingValid: plantingValid,
      plantingExpansion: plantingExpansion,
      planting: planting,
      plantingList: plantingList,

      ///파종정보
      seedingArea: seedingArea,
      seedingAreaUnit: seedingAreaUnit,
      seedingAmount: seedingAmount,
      seedingAmountUnit: seedingAmountUnit,
      seedingValid: seedingValid,
      seedingExpansion: seedingExpansion,
      seeding: seeding,
      seedingList: seedingList,

      ///제초정보
      weedingProgress: weedingProgress,
      weedingUnit: weedingUnit,
      weedingValid: weedingValid,
      weedingExpansion: weedingExpansion,
      weeding: weeding,
      weedingList: weedingList,

      ///관수정보

      wateringAmount: wateringAmount,
      wateringAmountUnit: wateringAmountUnit,
      wateringArea: wateringArea,
      wateringAreaUnit: wateringAreaUnit,
      wateringExpansion: wateringExpansion,
      wateringValid: wateringValid,
      wateringList: wateringList,

      ///인력투입정보
      workforceNum: workforceNum,
      workforcePrice: workforcePrice,
      workforceValid: workforceValid,
      workforceExpansion: wateringExpansion,
      workforce: workforce,
      workforceList: workforceList,

      ///경운정보
      farmingArea: farmingArea,
      farmingAreaUnit: farmingAreaUnit,
      farmingMethod: farmingMethod,
      farmingMethodUnit: farmingMethodUnit,
      farmingValid: farmingValid,
      farmingExpansion: farmingExpansion,
      farming: farming,
      farmingList: farmingList,
    );
  }

  JournalCreateState copyWith({
    Timestamp selectedDate,
    bool checkData,
    int category,
    String jid,
    String title,
    String content,
    List<String> tag,
    List<String> originalTag,
    DateTime date,
    List<Widgets> widgets,
    List<String> widgetList,
    List<Map<String, dynamic>> categories,
    bool selectDatePressed,
    bool changeCategoryPressed,
    bool pastBtn,
    bool writeComplete,
    bool isNewWrite,
    bool buttonSelected,
    bool isDeleted,
    bool isSuggestion,
    List<DateTime> wroteDate,
    List<Journal> journal,
    bool isEditDate,
    List<GalleryModel> pictures,
    DateTime picked,
    bool isLoading,

    ///Edit Journal
    Journal existJournal,
    Journal bufferJournal,

    ///사진정보
    List<File> imageList,
    List<Asset> assetList,
    List<ImagePicture> existImageList,
    List<ImagePicture> removedImageList,

    ///출하정보
    String shipmentPlant,
    String shipmentPath,
    double shipmentUnit, //text field
    String shipmentUnitSelect,
    String shipmentAmount,
    String shipmentGrade,
    int shipmentPrice,
    bool shipmentValid,
    bool shipmentExpansion,
    Shipment shipment,
    List<Shipment> shipmentList,

    ///비료정보
    String fertilizerMethod,
    double fertilizerArea,
    String fertilizerAreaUnit,
    String fertilizerMaterialName,
    double fertilizerMaterialUse,
    String fertilizerMaterialUnit,
    double fertilizerWater,
    String fertilizerWaterUnit,
    bool fertilizerValid,
    bool fertilizerExpansion,
    Fertilize fertilizer,
    List<Fertilize> fertilizerList,

    ///농약정보
    String pesticideMethod,
    double pesticideArea,
    String pesticideAreaUnit,
    String pesticideMaterialName,
    double pesticideMaterialUse,
    String pesticideMaterialUnit,
    double pesticideWater,
    String pesticideWaterUnit,
    bool pesticideValid,
    bool pesticideExpansion,
    Pesticide pesticide,
    List<Pesticide> pesticideList,

    ///병,해충정보
    String pestKind,
    double spreadDegree,
    String spreadDegreeUnit,
    bool pestValid,
    bool pestExpansion,
    Pest pest,
    List<Pest> pestList,

    ///정식 정보
    double plantingArea,
    String plantingAreaUnit,
    String plantingCount,
    int plantingPrice,
    bool plantingValid,
    bool plantingExpansion,
    Planting planting,
    List<Planting> plantingList,

    ///파종정보
    double seedingArea,
    String seedingAreaUnit,
    double seedingAmount,
    String seedingAmountUnit,
    bool seedingValid,
    bool seedingExpansion,
    Seeding seeding,
    List<Seeding> seedingList,

    ///제초정보
    double weedingProgress,
    String weedingUnit,
    bool weedingValid,
    bool weedingExpansion,
    Weeding weeding,
    List<Weeding> weedingList,

    ///관수정보
    double wateringArea,
    String wateringAreaUnit,
    double wateringAmount,
    String wateringAmountUnit,
    bool wateringValid,
    bool wateringExpansion,
    Watering watering,
    List<Watering> wateringList,

    ///인력투입정보
    int workforceNum,
    int workforcePrice,
    bool workforceValid,
    bool workforceExpansion,
    Workforce workforce,
    List<Workforce> workforceList,

    ///farming정보
    double farmingArea,
    String farmingAreaUnit,
    String farmingMethod,
    String farmingMethodUnit,
    bool farmingValid,
    bool farmingExpansion,
    Farming farming,
    List<Farming> farmingList,
  }) {
    return JournalCreateState(
      selectedDate: selectedDate ?? this.selectedDate,
      checkData: checkData ?? this.checkData,
      category: category ?? this.category,
      jid: jid ?? this.jid,
      title: title ?? this.title,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      originalTag: originalTag ?? this.originalTag,
      // date: date ?? this.date,
      widgets: widgets ?? this.widgets,
      widgetList: widgetList ?? this.widgetList,
      categories: categories ?? this.categories,
      selectDatePressed: selectDatePressed ?? false,
      changeCategoryPressed: changeCategoryPressed ?? false,
      buttonSelected: buttonSelected ?? false,
      isDeleted: isDeleted ?? false,
      isSuggestion: isSuggestion ?? false,
      isEditDate: isEditDate ?? this.isEditDate,
      // picked: picked ?? this.picked,

      pastBtn: pastBtn ?? this.pastBtn,
      writeComplete: writeComplete ?? false,
      isNewWrite: isNewWrite ?? this.isNewWrite,
      wroteDate: wroteDate ?? this.wroteDate,

      journal: journal ?? this.journal,
      isLoading: isLoading ?? this.isLoading,

      ///Edit Journal
      existJournal: existJournal ?? this.existJournal,
      bufferJournal: bufferJournal ?? this.bufferJournal,

      ///사진정보
      imageList: imageList ?? this.imageList,
      assetList: assetList ?? this.assetList,
      existImageList: existImageList ?? this.existImageList,
      removedImageList: removedImageList ?? this.removedImageList,

      ///출하정보
      shipmentPlant: shipmentPlant ?? this.shipmentPlant,
      shipmentPath: shipmentPath ?? this.shipmentPath,
      shipmentUnit: shipmentUnit ?? this.shipmentUnit,
      shipmentUnitSelect: shipmentUnitSelect ?? this.shipmentUnitSelect,
      shipmentAmount: shipmentAmount ?? this.shipmentAmount,
      shipmentGrade: shipmentGrade ?? this.shipmentGrade,
      shipmentPrice: shipmentPrice ?? this.shipmentPrice,
      shipmentValid: shipmentValid ?? this.shipmentValid,
      shipmentExpansion: shipmentExpansion ?? this.shipmentExpansion,
      shipment: shipment ?? this.shipment,
      shipmentList: shipmentList ?? this.shipmentList,

      ///비료정보
      fertilizerMethod: fertilizerMethod ?? this.fertilizerMethod,
      fertilizerArea: fertilizerArea ?? this.fertilizerArea,
      fertilizerAreaUnit: fertilizerAreaUnit ?? this.fertilizerAreaUnit,
      fertilizerMaterialName:
          fertilizerMaterialName ?? this.fertilizerMaterialName,
      fertilizerMaterialUse:
          fertilizerMaterialUse ?? this.fertilizerMaterialUse,
      fertilizerMaterialUnit:
          fertilizerMaterialUnit ?? this.fertilizerMaterialUnit,
      fertilizerWater: fertilizerWater ?? this.fertilizerWater,
      fertilizerWaterUnit: fertilizerWaterUnit ?? this.fertilizerWaterUnit,
      fertilizerValid: fertilizerValid ?? this.fertilizerValid,
      fertilizerExpansion: fertilizerExpansion ?? this.fertilizerExpansion,
      fertilizer: fertilizer ?? this.fertilizer,
      fertilizerList: fertilizerList ?? this.fertilizerList,

      ///농약정보
      pesticideMethod: pesticideMethod ?? this.pesticideMethod,
      pesticideArea: pesticideArea ?? this.pesticideArea,
      pesticideAreaUnit: pesticideAreaUnit ?? this.pesticideAreaUnit,
      pesticideMaterialName:
          pesticideMaterialName ?? this.pesticideMaterialName,
      pesticideMaterialUse: pesticideMaterialUse ?? this.pesticideMaterialUse,
      pesticideMaterialUnit:
          pesticideMaterialUnit ?? this.pesticideMaterialUnit,
      pesticideWater: pesticideWater ?? this.pesticideWater,
      pesticideWaterUnit: pesticideWaterUnit ?? this.pesticideWaterUnit,
      pesticideValid: pesticideValid ?? this.pesticideValid,
      pesticideExpansion: pesticideExpansion ?? this.pesticideExpansion,
      pesticide: pesticide ?? this.pesticide,
      pesticideList: pesticideList ?? this.pesticideList,

      ///병,해충정보
      pestKind: pestKind ?? this.pestKind,
      spreadDegree: spreadDegree ?? this.spreadDegree,
      spreadDegreeUnit: spreadDegreeUnit ?? this.spreadDegreeUnit,
      pestValid: pestValid ?? this.pestValid,
      pestExpansion: pestExpansion ?? this.pestExpansion,
      pest: pest ?? this.pest,
      pestList: pestList ?? this.pestList,

      ///정식 정보
      plantingArea: plantingArea ?? this.plantingArea,
      plantingAreaUnit: plantingAreaUnit ?? this.plantingAreaUnit,
      plantingCount: plantingCount ?? this.plantingCount,
      plantingPrice: plantingPrice ?? this.plantingPrice,
      plantingValid: plantingValid ?? this.plantingValid,
      plantingExpansion: plantingExpansion ?? this.plantingExpansion,
      planting: planting ?? this.planting,
      plantingList: plantingList ?? this.plantingList,

      ///파종정보
      seedingArea: seedingArea ?? this.seedingArea,
      seedingAreaUnit: seedingAreaUnit ?? this.seedingAreaUnit,
      seedingAmount: seedingAmount ?? this.seedingAmount,
      seedingAmountUnit: seedingAmountUnit ?? this.seedingAmountUnit,
      seedingValid: seedingValid ?? this.seedingValid,
      seedingExpansion: seedingExpansion ?? this.seedingExpansion,
      seeding: seeding ?? this.seeding,
      seedingList: seedingList ?? this.seedingList,

      ///제초정보
      weedingProgress: weedingProgress ?? this.weedingProgress,
      weedingUnit: weedingUnit ?? this.weedingUnit,
      weedingValid: weedingValid ?? this.weedingValid,
      weedingExpansion: weedingExpansion ?? this.weedingExpansion,
      weeding: weeding ?? this.weeding,
      weedingList: weedingList ?? this.weedingList,

      ///관수정보
      wateringArea: wateringArea ?? this.wateringArea,
      wateringAreaUnit: wateringAreaUnit ?? this.wateringAreaUnit,
      wateringAmount: wateringAmount ?? this.wateringAmount,
      wateringAmountUnit: wateringAmountUnit ?? this.wateringAmountUnit,
      wateringValid: wateringValid ?? this.wateringValid,
      wateringExpansion: wateringExpansion ?? this.wateringExpansion,
      watering: watering ?? this.watering,
      wateringList: wateringList ?? this.wateringList,

      ///인력투입정보
      workforceNum: workforceNum ?? this.workforceNum,
      workforcePrice: workforcePrice ?? this.workforcePrice,
      workforceValid: workforceValid ?? this.workforceValid,
      workforceExpansion: wateringExpansion ?? this.wateringExpansion,
      workforce: workforce ?? this.workforce,
      workforceList: workforceList ?? this.workforceList,

      ///경운정보
      farmingArea: farmingArea ?? this.farmingArea,
      farmingAreaUnit: farmingAreaUnit ?? this.farmingAreaUnit,
      farmingMethod: farmingMethod ?? this.farmingMethod,
      farmingMethodUnit: farmingMethodUnit ?? this.farmingMethodUnit,
      farmingValid: farmingValid ?? this.farmingValid,
      farmingExpansion: farmingExpansion ?? this.farmingExpansion,
      farming: farming ?? this.farming,
      farmingList: farmingList ?? this.farmingList,
    );
  }

  @override
  String toString() {
    return '''JournalCreateState{
      jid : $jid,
      title : $title,
      wroteDate: $wroteDate,
      content : $content,
      journal: $journal,
      selectDatePressed: $selectDatePressed,
      isEditDate: $isEditDate,
      category: $category,
    }''';
  }
}
