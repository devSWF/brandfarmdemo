import 'dart:io';

import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:BrandFarm/models/send_to_farm/send_to_farm_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/image/image_repository.dart';
import 'package:BrandFarm/repository/sub_home/sub_home_repository.dart';
import 'package:BrandFarm/repository/sub_journal/sub_journal_repository.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:BrandFarm/utils/journal.category.dart';
import 'package:BrandFarm/utils/resize_image.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class JournalCreateBloc extends Bloc<JournalCreateEvent, JournalCreateState> {
  JournalCreateBloc() : super(JournalCreateState.empty());

  @override
  Stream<JournalCreateState> mapEventToState(JournalCreateEvent event) async* {
    if (event is DateSelected) {
      yield* _mapDateSelectedToState(event.selectedDate);
    } else if (event is DataCheck) {
      yield* _mapDataCheckToState(event.check);
    } else if (event is TitleChanged) {
      yield* _mapTitleChangedToState(event.title);
    } else if (event is ContentChanged) {
      yield* _mapContentChangedToState(event.content);
    } else if (event is CategoryChanged) {
      yield* _mapCategoryChangedToState(event.category);
    } else if (event is AddImageFile) {
      yield* _mapAddImageFileToState(
          imageFile: event.imgFile, index: event.index, from: event.from);
    } else if (event is ContentChanged) {
      yield* _mapContentChangedToState(event.content);
    } else if (event is PastBtnChanged) {
      yield* _mapPastBtnChangedToState();
    } else if (event is SelectDateTimePressed) {
      yield* _mapSelectDateTimePressedToState();
    } else if (event is ChangeCategoryPressed) {
      yield* _mapChangeCategoryToState();
    } else if (event is JournalInitialized) {
      yield* _mapJournalInitToState(event.existJournal, event.existImage);
    } else if (event is WidgetListLoaded) {
      yield* _mapWidgetListLoadedToState(event.widgets);
    } else if (event is DeleteImageFile) {
      yield* _mapDeleteImageFileToState(removedFile: event.removedFile);
    } else if (event is DeleteJournalGrpPressed) {
      yield* _mapDeleteJournalGrpPressedToState();
    } else if (event is IsEditChanged) {
      yield* _mapIsEditChangedToState(event.isEdit);
    } else if (event is ModifyLoading) {
      yield* _mapModifyLoadingState();
    } else if (event is ModifyLoaded) {
      yield* _mapModifyLoadedToState();
    } else if (event is DeleteExistingImage) {
      yield* _mapDeleteExistingImageToState(event.index);
    }

    ///출하정보
    else if (event is ShipmentComplete) {
      yield* _mapShipmentCompleteToState(
          event.shipmentPlant,
          event.shipmentPath,
          event.shipmentUnit,
          event.shipmentUnitSelect,
          event.shipmentAmount,
          event.shipmentGrade,
          event.shipmentPrice);
    } else if (event is ShipmentEdit) {
      yield* _mapShipmentEditToState(
        event.shipmentPlant,
        event.shipmentPath,
        event.shipmentUnit,
        event.shipmentUnitSelect,
        event.shipmentAmount,
        event.shipmentGrade,
        event.shipmentPrice,
        event.currentIndex,
        //TODO: listIndex 안 쓰면 지우고 사용되는 곳 정리하기
        event.listIndex,
      );
    } else if (event is ShipmentPlantChanged) {
      yield* _mapShipmentPlantChangedToState(event.plant);
    } else if (event is ShipmentPathChanged) {
      yield* _mapShipmentPathChangedToState(event.path);
    } else if (event is ShipmentUnitChanged) {
      yield* _mapShipmentUnitChangedToState(event.unit);
    } else if (event is ShipmentUnitSelectChanged) {
      yield* _mapShipmentUnitSelectChangedToState(event.unitSelect);
    } else if (event is ShipmentAmountChanged) {
      yield* _mapShipmentAmountChangedToState(event.amount);
    } else if (event is ShipmentGradeChanged) {
      yield* _mapShipmentGradeChangedToState(event.grade);
    } else if (event is ShipmentPriceChanged) {
      yield* _mapShipmentPriceChangedToState(event.price);
    } else if (event is ShipmentDelete) {
      yield* _mapShipmentDeleteToState(event.index, event.listIndex);
    } else if (event is UnSelectDateTimePressed) {
      yield* _mapUnSelectDateTimePressedToState(event.picked);
    }

    ///비료정보
    else if (event is FertilizerComplete) {
      yield* _mapFertilizerCompleteToState(
          event.fertilizerMethod,
          event.fertilizerArea,
          event.fertilizerAreaUnit,
          event.fertilizerMaterialName,
          event.fertilizerMaterialUse,
          event.fertilizerMaterialUnit,
          event.fertilizerWater,
          event.fertilizerWaterUnit);
    } else if (event is FertilizerEdit) {
      yield* _mapFertilizerEditToState(
          event.fertilizerMethod,
          event.fertilizerArea,
          event.fertilizerAreaUnit,
          event.fertilizerMaterialName,
          event.fertilizerMaterialUse,
          event.fertilizerMaterialUnit,
          event.fertilizerWater,
          event.fertilizerWaterUnit,
          event.currentIndex);
    } else if (event is FertilizerMethod) {
      yield* _mapFertilizerMethodToState(event.method);
    } else if (event is FertilizerAreaChanged) {
      yield* _mapFertilizerAreaChangedToState(event.area);
    } else if (event is FertilizerAreaUnitChanged) {
      yield* _mapFertilizerAreaUnitChangedToState(event.areaUnit);
    } else if (event is FertilizerMaterialChanged) {
      yield* _mapFertilizerMaterialChangedToState(event.material);
    } else if (event is FertilizerMaterialUseChanged) {
      yield* _mapFertilizerMaterialUseChangedToState(event.materialUse);
    } else if (event is FertilizerMaterialUnitChanged) {
      yield* _mapFertilizerMaterialUnitChangedToState(event.materialUnit);
    } else if (event is FertilizerWaterUseChanged) {
      yield* _mapFertilizerWaterUseChangedToState(event.waterUse);
    } else if (event is FertilizerWaterUnitChanged) {
      yield* _mapFertilizerWaterUnitChangedToState(event.waterUnit);
    } else if (event is FertilizerDelete) {
      yield* _mapFertilizerDeleteToState(event.index, event.listIndex);
    }

    ///농약정보
    else if (event is PesticideComplete) {
      yield* _mapPesticideCompleteToState(
          event.pesticideMethod,
          event.pesticideArea,
          event.pesticideAreaUnit,
          event.pesticideMaterialName,
          event.pesticideMaterialUse,
          event.pesticideMaterialUnit,
          event.pesticideWater,
          event.pesticideMaterialUnit);
    } else if (event is PesticideEdit) {
      yield* _mapPesticideEditToState(
          event.pesticideMethod,
          event.pesticideArea,
          event.pesticideAreaUnit,
          event.pesticideMaterialName,
          event.pesticideMaterialUse,
          event.pesticideMaterialUnit,
          event.pesticideWater,
          event.pesticideMaterialUnit,
          event.currentIndex);
    } else if (event is PesticideMethod) {
      yield* _mapPesticideMethodToState(event.method);
    } else if (event is PesticideAreaChanged) {
      yield* _mapPesticideAreaChangedToState(event.area);
    } else if (event is PesticideAreaUnitChanged) {
      yield* _mapPesticideAreaUnitChangedToState(event.areaUnit);
    } else if (event is PesticideMaterialChanged) {
      yield* _mapPesticideMaterialChangedToState(event.material);
    } else if (event is PesticideMaterialUseChanged) {
      yield* _mapPesticideMaterialUseChangedToState(event.materialUse);
    } else if (event is PesticideMaterialUnitChanged) {
      yield* _mapPesticideMaterialUnitChangedToState(event.materialUnit);
    } else if (event is PesticideWaterUseChanged) {
      yield* _mapPesticideWaterUseChangedToState(event.waterUse);
    } else if (event is PesticideWaterUnitChanged) {
      yield* _mapPesticideWaterUnitChangedToState(event.waterUnit);
    } else if (event is PesticideExpansionChanged) {
      yield* _mapPesticideExpansionToState();
    } else if (event is PesticideDelete) {
      yield* _mapPesticideDeleteToState(event.index, event.listIndex);
    }

    ///병,해충정보
    else if (event is PestComplete) {
      yield* _mapPestCompleteToState(
          event.pestKind, event.spreadDegree, event.spreadDegreeUnit);
    } else if (event is PestEdit) {
      yield* _mapPestEditToState(event.pestKind, event.spreadDegree,
          event.spreadDegreeUnit, event.currentIndex);
    } else if (event is PestKindChanged) {
      yield* _mapPestKindChangedToState(event.kind);
    } else if (event is SpreadDegreeChanged) {
      yield* _mapSpreadDegreeChangedToState(event.degree);
    } else if (event is SpreadDegreeUnitChanged) {
      yield* _mapSpreadDegreeUnitChangedToState(event.degreeUnit);
    } else if (event is PestExpansionChanged) {
      yield* _mapPestExpansionToState();
    } else if (event is PestDelete) {
      yield* _mapPestDeleteToState(event.index, event.listIndex);
    }

    ///정식정보
    else if (event is PlantingComplete) {
      yield* _mapPlantingCompleteToState(event.plantingArea,
          event.plantingAreaUnit, event.plantingCount, event.plantingPrice);
    } else if (event is PlantingEdit) {
      yield* _mapPlantingEditToState(event.plantingArea, event.plantingAreaUnit,
          event.plantingCount, event.plantingPrice, event.currentIndex);
    } else if (event is PlantingAreaChanged) {
      yield* _mapPlantingAreaChangedToState(event.area);
    } else if (event is PlantingAreaUnitChanged) {
      yield* _mapPlantingAreaUnitChangedToState(event.areaUnit);
    } else if (event is PlantingCountChanged) {
      yield* _mapPlantingCountChangedToState(event.count);
    } else if (event is PlantingExpansionChanged) {
      yield* _mapPlantingExpansionToState();
    } else if (event is PlantingPriceChanged) {
      yield* _mapPlantingPriceChangedToState(event.price);
    } else if (event is PlantingDelete) {
      yield* _mapPlantingDeleteToState(event.index, event.listIndex);
    }

    ///파종정보
    else if (event is SeedingAreaChanged) {
      yield* _mapSeedingAreaChangedToState(event.area);
    } else if (event is SeedingAreaUnitChanged) {
      yield* _mapSeedingAreaUnitChangedToState(event.areaUnit);
    } else if (event is SeedingAmountChanged) {
      yield* _mapSeedingAmountChangedToState(event.amount);
    } else if (event is SeedingAmountUnitChanged) {
      yield* _mapSeedingAmountUnitToState(event.amountUnit);
    } else if (event is SeedingExpansionChanged) {
      yield* _mapSeedingExpansionToState();
    } else if (event is SeedingComplete) {
      yield* _mapSeedingCompleteToState(event.seedingArea,
          event.seedingAreaUnit, event.seedingAmount, event.seedingAmountUnit);
    } else if (event is SeedingEdit) {
      yield* _mapSeedingEditToState(event.seedingArea, event.seedingAreaUnit,
          event.seedingAmount, event.seedingAmountUnit, event.currentIndex);
    } else if (event is SeedingDelete) {
      yield* _mapSeedingDeleteToState(event.index, event.listIndex);
    }

    ///제초정보
    else if (event is WeedingComplete) {
      yield* _mapWeedingCompleteToState(
          event.weedingProgress, event.weedingUnit);
    } else if (event is WeedingEdit) {
      yield* _mapWeedingEditToState(
          event.weedingProgress, event.weedingUnit, event.currentIndex);
    } else if (event is WeedingProgressChanged) {
      yield* _mapWeedingProgressChangedToState(event.progress);
    } else if (event is WeedingUnitChanged) {
      yield* _mapWeedingUnitChangedToState(event.weedingUnit);
    } else if (event is WeedingExpansionChanged) {
      yield* _mapWeedingExpansionToState();
    } else if (event is WeedingDelete) {
      yield* _mapWeedingDeleteToState(event.index, event.listIndex);
    }

    ///관수정보
    else if (event is WateringComplete) {
      yield* _mapWateringCompleteToState(
          event.wateringArea,
          event.wateringAreaUnit,
          event.wateringAmount,
          event.wateringAmountUnit);
    } else if (event is WateringEdit) {
      yield* _mapWateringEditToState(event.wateringArea, event.wateringAreaUnit,
          event.wateringAmount, event.wateringAmountUnit, event.currentIndex);
    } else if (event is WateringAreaChanged) {
      yield* _mapWateringAreaChangedToState(event.area);
    } else if (event is WateringAreaUnitChanged) {
      yield* _mapWateringAreaUnitChangedToState(event.areaUnit);
    } else if (event is WateringAmountChanged) {
      yield* _mapWateringAmountChangedToState(event.amount);
    } else if (event is WateringAmountUnitChanged) {
      yield* _mapWateringAmountUnitToState(event.amountUnit);
    } else if (event is WateringExpansionChanged) {
      yield* _mapWateringExpansionToState();
    } else if (event is WateringDelete) {
      yield* _mapWateringDeleteToState(event.index, event.listIndex);
    }

    ///인력투입정보
    else if (event is WorkforceComplete) {
      yield* _mapWorkforceCompleteToState(
          event.workforceNum, event.workforcePrice);
    } else if (event is WorkforceEdit) {
      yield* _mapWorkforceEditToState(
          event.workforceNum, event.workforcePrice, event.currentIndex);
    } else if (event is WorkforceNumChanged) {
      yield* _mapWorkforceNumChangedToState(event.workforceNum);
    } else if (event is WorkforcePriceChanged) {
      yield* _mapWorkforcePriceChangedToState(event.workforcePrice);
    } else if (event is WorkforceExpansionChanged) {
      yield* _mapWorkforceExpansionToState();
    } else if (event is WorkforceDelete) {
      yield* _mapWorkforceDeleteToState(event.index, event.listIndex);
    }

    ///관수정보
    else if (event is FarmingComplete) {
      yield* _mapFarmingCompleteToState(event.farmingArea,
          event.farmingAreaUnit, event.farmingMethod, event.farmingMethodUnit);
    } else if (event is FarmingEdit) {
      yield* _mapFarmingEditToState(event.farmingArea, event.farmingAreaUnit,
          event.farmingMethod, event.farmingMethodUnit, event.currentIndex);
    } else if (event is FarmingAreaChanged) {
      yield* _mapFarmingAreaChangedToState(event.area);
    } else if (event is FarmingAreaUnitChanged) {
      yield* _mapFarmingAreaUnitChangedToState(event.areaUnit);
    } else if (event is FarmingMethodChanged) {
      yield* _mapFarmingMethodChangedToState(event.method);
    } else if (event is FarmingMethodUnitChanged) {
      yield* _mapFarmingMethodUnitToState(event.methodUnit);
    } else if (event is FarmingExpansionChanged) {
      yield* _mapFarmingExpansionToState();
    } else if (event is FarmingDelete) {
      yield* _mapFarmingDeleteToState(event.index, event.listIndex);
    }

    ///completeBtn
    else if (event is UpdateJournal) {
      yield* _mapUpdateJournalState();
    } else if (event is AssetImageList) {
      yield* _mapAssetImageListToState(event.assetImage);
    } else if (event is NewWriteCompleteChanged) {
      yield* _mapNewWriteCompleteChangedToState();
    }
  }

  Stream<JournalCreateState> _mapDataCheckToState(bool check) async* {
    yield state.update(checkData: check);
  }

  Stream<JournalCreateState> _mapDateSelectedToState(
      Timestamp selectedDate) async* {
    yield state.update(selectedDate: selectedDate);
  }

  Stream<JournalCreateState> _mapTitleChangedToState(String title) async* {
    yield state.update(title: title);
  }

  Stream<JournalCreateState> _mapContentChangedToState(String content) async* {
    yield state.update(content: content);
  }

  Stream<JournalCreateState> _mapCategoryChangedToState(int category) async* {
    yield state.update(category: category);
  }

  Stream<JournalCreateState> _mapIsEditChangedToState(bool isEdit) async* {
    yield state.update(isEditDate: isEdit);
  }

  Stream<JournalCreateState> _mapModifyLoadingState() async* {
    yield state.update(isModifyLoading: true);
  }

  Stream<JournalCreateState> _mapModifyLoadedToState() async* {
    yield state.update(isModifyLoading: false);
  }

//IsEditChanged
  ///사진정보
  Stream<JournalCreateState> _mapAddImageFileToState(
      {File imageFile, int index, int from}) async* {
    List<File> _img = state.imageList;

    if (!_img.contains(imageFile) && from == 0) {
      _img.removeAt(index);
      _img.insert(index, await resizeImage(imageFile));
    }
    if (from == 1) {
      _img.add(await resizeImage(imageFile));
    }

    yield state.update(
      imageList: _img,
    );
  }

  Stream<JournalCreateState> _mapDeleteImageFileToState(
      {File removedFile}) async* {
    List<File> _img = state.imageList;
    _img.remove(removedFile);

    yield state.update(
      imageList: _img,
    );
  }

  Stream<JournalCreateState> _mapAssetImageListToState(
      List<Asset> asset) async* {
    List<File> bufferList = state.imageList;
    for (int i = 0; i < asset.length; i++) {
      bufferList.insert(0, null);
    }
    yield state.update(assetList: asset, imageList: bufferList);
  }

  Stream<JournalCreateState> _mapUpdateJournalState() async* {
    Journal journal = Journal(
      fid: state.existJournal.fid,
      fieldCategory: state.existJournal.fieldCategory,
      jid: state.existJournal.jid,
      uid: state.existJournal.uid,
      date: state.selectedDate,
      title: state.title,
      content: state.content,
      widgets: state.widgets,
      widgetList: state.widgetList,
      comments: state.existJournal.comments,
      isReadByFM: state.existJournal.isReadByFM,
      isReadByOffice: state.existJournal.isReadByOffice,
      shipment: state.shipmentList.isEmpty ? null : state.shipmentList,
      fertilize: state.fertilizerList.isEmpty ? null : state.fertilizerList,
      pesticide: state.pesticideList.isEmpty ? null : state.pesticideList,
      pest: state.pestList.isEmpty ? null : state.pestList,
      planting: state.plantingList.isEmpty ? null : state.plantingList,
      seeding: state.seedingList.isEmpty ? null : state.seedingList,
      weeding: state.weedingList.isEmpty ? null : state.weedingList,
      watering: state.wateringList.isEmpty ? null : state.wateringList,
      workforce: state.workforceList.isEmpty ? null : state.workforceList,
      farming: state.farmingList.isEmpty ? null : state.farmingList,
      updatedDate: state.existJournal.updatedDate,
    );

    await SubJournalRepository().updateJournal(
      journal: journal,
    );

    if (state.removedImageList.isNotEmpty) {
      await Future.forEach(state.removedImageList, (pic) async {
        await ImageRepository().deleteFromStorage(pic: pic);
        await ImageRepository().deleteFromDatabase(pic: pic);
      });
    }

    ///사진추가 !!
    List<File> imageList = state.imageList;
    String pid = '';

    if (imageList.isNotEmpty) {
      await Future.forEach(imageList, (File file) async {
        pid = FirebaseFirestore.instance.collection('Picture').doc().id;
        ImagePicture _picture = ImagePicture(
          fid: '--',
          jid: state.existJournal.jid,
          uid: UserUtil.getUser().uid,
          issid: '--',
          pid: pid,
          url: (await ImageRepository().uploadJournalImageFile(file, pid)),
          dttm: Timestamp.now(),
        );

        await ImageRepository().uploadImage(
          picture: _picture,
        );
      });
    }

    yield state.update(
      writeComplete: true,
      bufferJournal: journal,
    );
  }

  Stream<JournalCreateState> _mapNewWriteCompleteChangedToState() async* {
    String jid = FirebaseFirestore.instance.collection('Journal').doc().id;

    Journal journal = Journal(
      fid: await FieldUtil.getField().fid,
      fieldCategory: await FieldUtil.getField().fieldCategory,
      jid: state.jid.isNotEmpty ? state.jid : jid,
      uid: UserUtil.getUser().uid,
      date: state.selectedDate,
      title: state.title,
      content: state.content,
      widgets: state.widgets,
      widgetList: state.widgetList,
      comments: 0,
      isReadByFM: false,
      isReadByOffice: false,
      shipment: state.shipmentList.isEmpty ? null : state.shipmentList,
      fertilize: state.fertilizerList.isEmpty ? null : state.fertilizerList,
      pesticide: state.pesticideList.isEmpty ? null : state.pesticideList,
      pest: state.pestList.isEmpty ? null : state.pestList,
      planting: state.plantingList.isEmpty ? null : state.plantingList,
      seeding: state.seedingList.isEmpty ? null : state.seedingList,
      weeding: state.weedingList.isEmpty ? null : state.weedingList,
      watering: state.wateringList.isEmpty ? null : state.wateringList,
      workforce: state.workforceList.isEmpty ? null : state.workforceList,
      farming: state.farmingList.isEmpty ? null : state.farmingList,
      updatedDate: Timestamp.now(),
    );

    await SubJournalRepository().uploadJournal(
      journal: journal,
    );

    ///사진추가 !!
    List<File> imageList = state.imageList;
    String pid = '';

    if (imageList.isNotEmpty) {
      await Future.forEach(imageList, (File file) async {
        pid = FirebaseFirestore.instance.collection('Picture').doc().id;
        ImagePicture _picture = ImagePicture(
          fid: '--',
          jid: jid,
          uid: UserUtil.getUser().uid,
          issid: '--',
          pid: pid,
          url: (await ImageRepository().uploadJournalImageFile(file, pid)),
          dttm: Timestamp.now(),
        );

        await ImageRepository().uploadImage(
          picture: _picture,
        );
      });
    }

    Farm farm = await SubHomeRepository()
        .getFarm(await FieldUtil.getField().fieldCategory);
    User user = await SubHomeRepository().getUser(farm.managerID);
    String docID =
        await FirebaseFirestore.instance.collection('SendToFarm').doc().id;
    SendToFarm _sendToFarm = SendToFarm(
      docID: docID,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      farmid: farm.farmID,
      title: '새로 등록된 성장일지를 확인하세요',
      content: '성장일지',
      postedDate: Timestamp.now(),
      jid: jid,
      issid: '',
      cmtid: '',
      scmtid: '',
      fcmToken: user.fcmToken,
    );
    SubHomeRepository().sendNotification(_sendToFarm);

    yield state.update(writeComplete: true);
  }

  DocumentReference getJournalRef(String date) {
    return FirebaseFirestore.instance
        .collection('Journal')
        .doc('$date&${UserUtil.getUser().uid}');
  }

  DocumentReference getJournalRecDateRef(String date) {
    return FirebaseFirestore.instance
        .collection('JournalRecodedDates')
        .doc('${date.substring(0, 7)}&${UserUtil.getUser().uid}');
  }

  Stream<JournalCreateState> _mapDeleteExistingImageToState(int index) async* {
    List<ImagePicture> bufferPictureList = state.existImageList;
    List<ImagePicture> removedPictureList = state.removedImageList;

    removedPictureList.add(bufferPictureList[index]);
    bufferPictureList.removeAt(index);
    yield state.update(
        existImageList: bufferPictureList,
        removedImageList: removedPictureList);
  }

  ///출하정보
  Stream<JournalCreateState> _mapShipmentCompleteToState(
      String shipmentPlant,
      String shipmentPath,
      double shipmentUnit,
      String shipmentUnitSelect,
      String shipmentAmount,
      String shipmentGrade,
      int shipmentPrice) async* {
    Shipment shipment = Shipment(
        shipmentPlant: shipmentPlant,
        shipmentPath: shipmentPath,
        shipmentUnit: shipmentUnit,
        shipmentUnitSelect: shipmentUnitSelect,
        shipmentAmount: shipmentAmount,
        shipmentGrade: shipmentGrade,
        shipmentPrice: shipmentPrice,
        index: state.shipmentList.length);

    List<Shipment> _list = state.shipmentList;
    _list.add(shipment);
    List<Widgets> widgets = state.widgets;

    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));

    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: shipment.index,
    ));

    yield state.update(
        shipmentList: _list,
        shipment: shipment,
        widgets: widgets,
        widgetList: widgetList);
  }

  Stream<JournalCreateState> _mapShipmentEditToState(
      String shipmentPlant,
      String shipmentPath,
      double shipmentUnit,
      String shipmentUnitSelect,
      String shipmentAmount,
      String shipmentGrade,
      int shipmentPrice,
      int currentIndex,
      //TODO: listIndex 안 쓰면 지우고 사용되는 곳 정리하기
      int listIndex) async* {
    Shipment shipment = Shipment(
        shipmentPlant: shipmentPlant,
        shipmentPath: shipmentPath,
        shipmentUnit: shipmentUnit,
        shipmentUnitSelect: shipmentUnitSelect,
        shipmentAmount: shipmentAmount,
        shipmentGrade: shipmentGrade,
        shipmentPrice: shipmentPrice,
        index: currentIndex);

    List<Shipment> _list = state.shipmentList;

    _list[currentIndex] = shipment;
    yield state.update(
      shipmentList: _list,
      shipment: shipment,
    );
  }

  Stream<JournalCreateState> _mapShipmentPlantChangedToState(
      String shipmentPlant) async* {
    yield state.update(
      shipmentPlant: shipmentPlant,
    );
  }

  Stream<JournalCreateState> _mapShipmentPathChangedToState(
      String path) async* {
    yield state.update(
      shipmentPath: path,
    );
  }

  Stream<JournalCreateState> _mapShipmentUnitChangedToState(
      double unit) async* {
    yield state.update(
      shipmentUnit: unit,
    );
  }

  Stream<JournalCreateState> _mapShipmentUnitSelectChangedToState(
      String unitSelect) async* {
    yield state.update(
      shipmentUnitSelect: unitSelect,
    );
  }

  Stream<JournalCreateState> _mapShipmentAmountChangedToState(
      String amount) async* {
    yield state.update(
      shipmentAmount: amount,
    );
  }

  Stream<JournalCreateState> _mapShipmentGradeChangedToState(
      String grade) async* {
    yield state.update(
      shipmentGrade: grade,
    );
  }

  Stream<JournalCreateState> _mapShipmentPriceChangedToState(int price) async* {
    yield state.update(
      shipmentPrice: price,
    );
  }

  Stream<JournalCreateState> _mapShipmentDeleteToState(
      int index, int listIndex) async* {
    List<Shipment> _list = state.shipmentList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "출하정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  ///비료정보
  Stream<JournalCreateState> _mapFertilizerCompleteToState(
    String fertilizerMethod,
    double fertilizerArea,
    String fertilizerAreaUnit,
    String fertilizerMaterialName,
    double fertilizerMaterialUse,
    String fertilizerMaterialUnit,
    double fertilizerWater,
    String fertilizerWaterUnit,
  ) async* {
    Fertilize fertilize = Fertilize(
        fertilizerMethod: fertilizerMethod,
        fertilizerArea: fertilizerArea,
        fertilizerAreaUnit: fertilizerAreaUnit,
        fertilizerMaterialName: fertilizerMaterialName,
        fertilizerMaterialUse: fertilizerMaterialUse,
        fertilizerMaterialUnit: fertilizerMaterialUnit,
        fertilizerWater: fertilizerWater,
        fertilizerWaterUnit: fertilizerWaterUnit,
        index: state.fertilizerList.length);

    List<Fertilize> _list = state.fertilizerList;
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));

    _list.add(fertilize);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: fertilize.index,
    ));

    yield state.update(
        fertilizerList: _list, fertilizer: fertilize, widgets: widgets);
  }

  Stream<JournalCreateState> _mapFertilizerEditToState(
    String fertilizerMethod,
    double fertilizerArea,
    String fertilizerAreaUnit,
    String fertilizerMaterialName,
    double fertilizerMaterialUse,
    String fertilizerMaterialUnit,
    double fertilizerWater,
    String fertilizerWaterUnit,
    int currentIndex,
  ) async* {
    Fertilize fertilize = Fertilize(
        fertilizerMethod: fertilizerMethod,
        fertilizerArea: fertilizerArea,
        fertilizerAreaUnit: fertilizerAreaUnit,
        fertilizerMaterialName: fertilizerMaterialName,
        fertilizerMaterialUse: fertilizerMaterialUse,
        fertilizerMaterialUnit: fertilizerMaterialUnit,
        fertilizerWater: fertilizerWater,
        fertilizerWaterUnit: fertilizerWaterUnit,
        index: state.fertilizerList.length);

    List<Fertilize> _list = state.fertilizerList;
    _list[currentIndex] = fertilize;

    yield state.update(fertilizerList: _list, fertilizer: fertilize);
  }

  Stream<JournalCreateState> _mapFertilizerDeleteToState(
      int index, int listIndex) async* {
    List<Fertilize> _list = state.fertilizerList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "비료정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapFertilizerMethodToState(String method) async* {
    yield state.update(
      fertilizerMethod: method,
    );
  }

  Stream<JournalCreateState> _mapFertilizerAreaChangedToState(
      double area) async* {
    yield state.update(
      fertilizerArea: area,
    );
  }

  Stream<JournalCreateState> _mapFertilizerAreaUnitChangedToState(
      String areaUnit) async* {
    yield state.update(
      fertilizerAreaUnit: areaUnit,
    );
  }

  Stream<JournalCreateState> _mapFertilizerMaterialChangedToState(
      String material) async* {
    yield state.update(
      fertilizerMaterialName: material,
    );
  }

  Stream<JournalCreateState> _mapFertilizerMaterialUseChangedToState(
      double materialUse) async* {
    yield state.update(
      fertilizerMaterialUse: materialUse,
    );
  }

  Stream<JournalCreateState> _mapFertilizerMaterialUnitChangedToState(
      String materialUnit) async* {
    yield state.update(
      fertilizerMaterialUnit: materialUnit,
    );
  }

  Stream<JournalCreateState> _mapFertilizerWaterUseChangedToState(
      double waterUse) async* {
    yield state.update(
      fertilizerWater: waterUse,
    );
  }

  Stream<JournalCreateState> _mapFertilizerWaterUnitChangedToState(
      String waterUnit) async* {
    yield state.update(
      fertilizerWaterUnit: waterUnit,
    );
  }

//  Stream<JournalCreateState> _mapFertilizerValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    bool judge;
//    FertilizerUtil.setFertilizer(
//        state.fertilizerMethod,
//        state.fertilizerArea,
//        state.fertilizerAreaUnit,
//        state.fertilizerMaterialName,
//        state.fertilizerMaterialUse,
//        state.fertilizerMaterialUnit,
//        state.fertilizerWater,
//        state.fertilizerWaterUnit);
//    if (state.fertilizerMethod.length > 0 ||
//        state.fertilizerArea > 0 ||
//        state.fertilizerMaterialName.length > 0 ||
//        state.fertilizerMaterialUse > 0 ||
//        state.fertilizerWater > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[1]["name"])) {
//        widget.add(journalCategory[1]["name"]);
//      }
//    }
//    yield state.update(
//      widgets: widget,
//      fertilizerValid: judge,
//    );
//  }

  ///농약정보
  Stream<JournalCreateState> _mapPesticideCompleteToState(
      String pesticideMethod,
      double pesticideArea,
      String pesticideAreaUnit,
      String pesticideMaterialName,
      double pesticideMaterialUse,
      String pesticideMaterialUnit,
      double pesticideWater,
      String pesticideWaterUnit) async* {
    Pesticide pesticide = Pesticide(
        pesticideMethod: pesticideMethod,
        pesticideArea: pesticideArea,
        pesticideAreaUnit: pesticideAreaUnit,
        pesticideMaterialName: pesticideMaterialName,
        pesticideMaterialUse: pesticideMaterialUse,
        pesticideMaterialUnit: pesticideMaterialUnit,
        pesticideWater: pesticideWater,
        pesticideWaterUnit: pesticideWaterUnit,
        index: state.pesticideList.length);
    List<Pesticide> _list = state.pesticideList;
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));

    _list.add(pesticide);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: pesticide.index,
    ));
    yield state.update(
        pesticideList: _list, pesticide: pesticide, widgets: widgets);
  }

  Stream<JournalCreateState> _mapPesticideEditToState(
      String pesticideMethod,
      double pesticideArea,
      String pesticideAreaUnit,
      String pesticideMaterialName,
      double pesticideMaterialUse,
      String pesticideMaterialUnit,
      double pesticideWater,
      String pesticideWaterUnit,
      int currentIndex) async* {
    Pesticide pesticide = Pesticide(
        pesticideMethod: pesticideMethod,
        pesticideArea: pesticideArea,
        pesticideAreaUnit: pesticideAreaUnit,
        pesticideMaterialName: pesticideMaterialName,
        pesticideMaterialUse: pesticideMaterialUse,
        pesticideMaterialUnit: pesticideMaterialUnit,
        pesticideWater: pesticideWater,
        pesticideWaterUnit: pesticideWaterUnit,
        index: state.pesticideList.length);
    List<Pesticide> _list = state.pesticideList;
    _list[currentIndex] = pesticide;

    yield state.update(pesticideList: _list, pesticide: pesticide);
  }

  Stream<JournalCreateState> _mapPesticideDeleteToState(
      int index, int listIndex) async* {
    List<Pesticide> _list = state.pesticideList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "농약정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapPesticideMethodToState(String method) async* {
    yield state.update(
      pesticideMethod: method,
    );
  }

  Stream<JournalCreateState> _mapPesticideAreaChangedToState(
      double area) async* {
    yield state.update(
      pesticideArea: area,
    );
  }

  Stream<JournalCreateState> _mapPesticideAreaUnitChangedToState(
      String areaUnit) async* {
    yield state.update(
      pesticideAreaUnit: areaUnit,
    );
  }

  Stream<JournalCreateState> _mapPesticideMaterialChangedToState(
      String material) async* {
    yield state.update(
      pesticideMaterialName: material,
    );
  }

  Stream<JournalCreateState> _mapPesticideMaterialUseChangedToState(
      double materialUse) async* {
    yield state.update(
      pesticideMaterialUse: materialUse,
    );
  }

  Stream<JournalCreateState> _mapPesticideMaterialUnitChangedToState(
      String materialUnit) async* {
    yield state.update(
      pesticideMaterialUnit: materialUnit,
    );
  }

  Stream<JournalCreateState> _mapPesticideWaterUseChangedToState(
      double waterUse) async* {
    yield state.update(
      pesticideWater: waterUse,
    );
  }

  Stream<JournalCreateState> _mapPesticideWaterUnitChangedToState(
      String waterUnit) async* {
    yield state.update(
      pesticideWaterUnit: waterUnit,
    );
  }

//  Stream<JournalCreateState> _mapPesticideValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    bool judge;
//    PesticideUtil.setPesticide(
//        state.pesticideMethod,
//        state.pesticideArea,
//        state.pesticideAreaUnit,
//        state.pesticideMaterialName,
//        state.pesticideMaterialUse,
//        state.pesticideMaterialUnit,
//        state.pesticideWater,
//        state.pesticideWaterUnit);
//    if (state.pesticideMethod.length > 0 ||
//        state.pesticideArea > 0 ||
//        state.pesticideMaterialName.length > 0 ||
//        state.pesticideMaterialUse > 0 ||
//        state.pesticideWater > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[2]["name"])) {
//        widget.add(journalCategory[2]["name"]);
//      }
//    }
//    yield state.update(
//      widgets: widget,
//      pesticideValid: judge,
//    );
//  }

  Stream<JournalCreateState> _mapPesticideExpansionToState() async* {
    bool judge = state.pesticideExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      pesticideExpansion: judge,
    );
  }

  ///병,해충 정보
  Stream<JournalCreateState> _mapPestCompleteToState(
    String pestKind,
    double spreadDegree,
    String spreadDegreeUnit,
  ) async* {
    Pest pest = Pest(
        pestKind: pestKind,
        spreadDegree: spreadDegree,
        spreadDegreeUnit: spreadDegreeUnit,
        pestValid: true,
        index: state.pestList.length);
    List<Pest> _list = state.pestList;
    _list.add(pest);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: pest.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(pestList: _list, pest: pest, widgets: widgets);
  }

  Stream<JournalCreateState> _mapPestEditToState(
    String pestKind,
    double spreadDegree,
    String spreadDegreeUnit,
    int currentIndex,
  ) async* {
    Pest pest = Pest(
        pestKind: pestKind,
        spreadDegree: spreadDegree,
        spreadDegreeUnit: spreadDegreeUnit,
        pestValid: true,
        index: state.pestList.length);
    List<Pest> _list = state.pestList;
    _list[currentIndex] = pest;

    yield state.update(pestList: _list, pest: pest);
  }

  Stream<JournalCreateState> _mapPestDeleteToState(
      int index, int listIndex) async* {
    List<Pest> _list = state.pestList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "병,해충정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapPestKindChangedToState(String kind) async* {
    yield state.update(
      pestKind: kind,
    );
  }

  Stream<JournalCreateState> _mapSpreadDegreeChangedToState(
      double degree) async* {
    yield state.update(
      spreadDegree: degree,
    );
  }

  Stream<JournalCreateState> _mapSpreadDegreeUnitChangedToState(
      String degreeUnit) async* {
    yield state.update(
      spreadDegreeUnit: degreeUnit,
    );
  }

//  Stream<JournalCreateState> _mapPestValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    PestUtil.setPest(state.pestKind, state.spreadDegree,
//        state.spreadDegreeUnit);
//    bool judge;
//    if (state.spreadDegree > 0 || state.pestKind.length > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[3]["name"])) {
//        widget.add(journalCategory[3]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      pestValid: judge,
//    );
//  }

  Stream<JournalCreateState> _mapPestExpansionToState() async* {
    bool judge = state.pestExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      pestExpansion: judge,
    );
  }

  ///정식정보
  Stream<JournalCreateState> _mapPlantingCompleteToState(double plantingArea,
      String plantingAreaUnit, String plantingCount, int plantingPrice) async* {
    Planting planting = Planting(
        plantingArea: plantingArea,
        plantingAreaUnit: plantingAreaUnit,
        plantingCount: plantingCount,
        plantingPrice: plantingPrice,
        plantingValid: true,
        index: state.plantingList.length);
    List<Planting> _list = state.plantingList;

    _list.add(planting);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: planting.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(
        plantingList: _list, planting: planting, widgets: widgets);
  }

  Stream<JournalCreateState> _mapPlantingEditToState(
      double plantingArea,
      String plantingAreaUnit,
      String plantingCount,
      int plantingPrice,
      int currentIndex) async* {
    Planting planting = Planting(
        plantingArea: plantingArea,
        plantingAreaUnit: plantingAreaUnit,
        plantingCount: plantingCount,
        plantingPrice: plantingPrice,
        plantingValid: true,
        index: state.plantingList.length);
    List<Planting> _list = state.plantingList;
    _list[currentIndex] = planting;

    yield state.update(plantingList: _list, planting: planting);
  }

  Stream<JournalCreateState> _mapPlantingAreaChangedToState(
      double area) async* {
    yield state.update(
      plantingArea: area,
    );
  }

  Stream<JournalCreateState> _mapPlantingDeleteToState(
      int index, int listIndex) async* {
    List<Planting> _list = state.plantingList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "정식정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapPlantingAreaUnitChangedToState(
      String unit) async* {
    yield state.update(
      plantingAreaUnit: unit,
    );
  }

  Stream<JournalCreateState> _mapPlantingCountChangedToState(
      String count) async* {
    yield state.update(
      plantingCount: count,
    );
  }

  Stream<JournalCreateState> _mapPlantingPriceChangedToState(int price) async* {
    yield state.update(
      plantingPrice: price,
    );
  }

//  Stream<JournalCreateState> _mapPlantingValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    bool judge;
//    PlantingUtil.setPlanting(
//        state.plantingArea,
//        state.plantingAreaUnit,
//        state.plantingCount,
//        state.plantingPrice);
//    if (state.plantingArea > 0 ||
//        state.plantingCount.length > 0 ||
//        state.plantingPrice > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[4]["name"])) {
//        widget.add(journalCategory[4]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      plantingValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapPlantingExpansionToState() async* {
    bool judge = state.plantingExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      plantingExpansion: judge,
    );
  }

  ///파종정보
  Stream<JournalCreateState> _mapSeedingCompleteToState(
      double seedingArea,
      String seedingAreaUnit,
      double seedingAmount,
      String seedingAmountUnit) async* {
    Seeding seeding = Seeding(
        seedingArea: seedingArea,
        seedingAreaUnit: seedingAreaUnit,
        seedingAmount: seedingAmount,
        seedingAmountUnit: seedingAmountUnit,
        seedingValid: true,
        index: state.seedingList.length);

    List<Seeding> _list = state.seedingList;
    _list.add(seeding);

    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: seeding.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(seedingList: _list, seeding: seeding, widgets: widgets);
  }

  Stream<JournalCreateState> _mapSeedingEditToState(
      double seedingArea,
      String seedingAreaUnit,
      double seedingAmount,
      String seedingAmountUnit,
      int currentIndex) async* {
    Seeding seeding = Seeding(
        seedingArea: seedingArea,
        seedingAreaUnit: seedingAreaUnit,
        seedingAmount: seedingAmount,
        seedingAmountUnit: seedingAmountUnit,
        seedingValid: true,
        index: state.seedingList.length);
    List<Seeding> _list = state.seedingList;
    _list[currentIndex] = seeding;

    yield state.update(seedingList: _list, seeding: seeding);
  }

  Stream<JournalCreateState> _mapSeedingDeleteToState(
      int index, int listIndex) async* {
    List<Seeding> _list = state.seedingList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "파종정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
  }

  Stream<JournalCreateState> _mapSeedingAreaChangedToState(double area) async* {
    yield state.update(
      seedingArea: area,
    );
  }

  Stream<JournalCreateState> _mapSeedingAreaUnitChangedToState(
      String unit) async* {
    yield state.update(
      seedingAreaUnit: unit,
    );
  }

  Stream<JournalCreateState> _mapSeedingAmountChangedToState(
      double amount) async* {
    yield state.update(
      seedingAmount: amount,
    );
  }

  Stream<JournalCreateState> _mapSeedingAmountUnitToState(
      String amountUnit) async* {
    yield state.update(
      seedingAmountUnit: amountUnit,
    );
  }

//  Stream<JournalCreateState> _mapSeedingValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    bool judge;
//    SeedingUtil.setSeeding(
//        state.seedingArea,
//        state.seedingAreaUnit,
//        state.seedingAmount,
//        state.seedingAmountUnit);
//    if (state.seedingAmount > 0 || state.seedingArea > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[5]["name"])) {
//        widget.add(journalCategory[5]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      seedingValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapSeedingExpansionToState() async* {
    bool judge = state.seedingExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      seedingExpansion: judge,
    );
  }

  ///제초정보
  Stream<JournalCreateState> _mapWeedingCompleteToState(
      double weedingProgress, String weedingUnit) async* {
    Weeding weeding = Weeding(
        weedingProgress: weedingProgress,
        weedingUnit: weedingUnit,
        weedingValid: true,
        index: state.weedingList.length);
    List<Weeding> _list = state.weedingList;
    _list.add(weeding);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: weeding.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(weedingList: _list, weeding: weeding, widgets: widgets);
  }

  Stream<JournalCreateState> _mapWeedingEditToState(
      double weedingProgress, String weedingUnit, int currentIndex) async* {
    Weeding weeding = Weeding(
        weedingProgress: weedingProgress,
        weedingUnit: weedingUnit,
        weedingValid: true,
        index: state.weedingList.length);
    List<Weeding> _list = state.weedingList;
    _list[currentIndex] = weeding;

    yield state.update(weedingList: _list, weeding: weeding);
  }

  Stream<JournalCreateState> _mapWeedingDeleteToState(
      int index, int listIndex) async* {
    List<Weeding> _list = state.weedingList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "제초정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapWeedingProgressChangedToState(
      double progress) async* {
    yield state.update(
      weedingProgress: progress,
    );
  }

  Stream<JournalCreateState> _mapWeedingUnitChangedToState(
      String weedingUnit) async* {
    yield state.update(
      weedingUnit: weedingUnit,
    );
  }

//  Stream<JournalCreateState> _mapWeedingValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    bool judge;
//    WeedingUtil.setWeeding(
//        state.weedingProgress, state.weedingUnit);
//    if (state.weedingProgress > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[6]["name"])) {
//        widget.add(journalCategory[6]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      weedingValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapWeedingExpansionToState() async* {
    bool judge = state.weedingExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      weedingExpansion: judge,
    );
  }

  ///관수정보
  Stream<JournalCreateState> _mapWateringCompleteToState(
      double wateringArea,
      String wateringAreaUnit,
      double wateringAmount,
      String wateringAmountUnit) async* {
    Watering watering = Watering(
        wateringArea: wateringArea,
        wateringAreaUnit: wateringAreaUnit,
        wateringAmount: wateringAmount,
        wateringAmountUnit: wateringAmountUnit,
        wateringValid: true,
        index: state.wateringList.length);

    List<Watering> _list = state.wateringList;
    _list.add(watering);

    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: watering.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(
        wateringList: _list, watering: watering, widgets: widgets);
  }

  Stream<JournalCreateState> _mapWateringEditToState(
      double wateringArea,
      String wateringAreaUnit,
      double wateringAmount,
      String wateringAmountUnit,
      int currentIndex) async* {
    Watering watering = Watering(
        wateringArea: wateringArea,
        wateringAreaUnit: wateringAreaUnit,
        wateringAmount: wateringAmount,
        wateringAmountUnit: wateringAmountUnit,
        wateringValid: true,
        index: state.wateringList.length);
    List<Watering> _list = state.wateringList;
    _list[currentIndex] = watering;

    yield state.update(wateringList: _list, watering: watering);
  }

  Stream<JournalCreateState> _mapWateringDeleteToState(
      int index, int listIndex) async* {
    List<Watering> _list = state.wateringList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "관수정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapWateringAreaChangedToState(
      double area) async* {
    yield state.update(
      wateringArea: area,
    );
  }

  Stream<JournalCreateState> _mapWateringAreaUnitChangedToState(
      String unit) async* {
    yield state.update(
      wateringAreaUnit: unit,
    );
  }

  Stream<JournalCreateState> _mapWateringAmountChangedToState(
      double amount) async* {
    yield state.update(
      wateringAmount: amount,
    );
  }

  Stream<JournalCreateState> _mapWateringAmountUnitToState(
      String amountUnit) async* {
    yield state.update(
      wateringAmountUnit: amountUnit,
    );
  }

//  Stream<JournalCreateState> _mapWateringValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    WateringUtil.setWatering(
//        state.wateringArea,
//        state.wateringAreaUnit,
//        state.wateringAmount,
//        state.wateringAmountUnit);
//    bool judge;
//    if (state.wateringAmount > 0 || state.wateringArea > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[7]["name"])) {
//        widget.add(journalCategory[7]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      wateringValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapWateringExpansionToState() async* {
    bool judge = state.wateringExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }

    yield state.update(
      wateringExpansion: judge,
    );
  }

  ///인력투입정보
  Stream<JournalCreateState> _mapWorkforceCompleteToState(
      int workforceNum, int workforcePrice) async* {
    Workforce workforce = Workforce(
        workforceNum: workforceNum,
        workforcePrice: workforcePrice,
        workforceValid: true,
        index: state.workforceList.length);
    List<Workforce> _list = state.workforceList;
    _list.add(workforce);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: workforce.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(
        workforceList: _list, workforce: workforce, widgets: widgets);
  }

  Stream<JournalCreateState> _mapWorkforceEditToState(
      int workforceNum, int workforcePrice, int currentIndex) async* {
    Workforce workforce = Workforce(
        workforceNum: workforceNum,
        workforcePrice: workforcePrice,
        workforceValid: true,
        index: state.workforceList.length);
    List<Workforce> _list = state.workforceList;
    _list[currentIndex] = workforce;

    yield state.update(workforceList: _list, workforce: workforce);
  }

  Stream<JournalCreateState> _mapWorkforceDeleteToState(
      int index, int listIndex) async* {
    List<Workforce> _list = state.workforceList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "인력투입정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapWorkforceNumChangedToState(int num) async* {
    yield state.update(
      workforceNum: num,
    );
  }

  Stream<JournalCreateState> _mapWorkforcePriceChangedToState(
      int price) async* {
    yield state.update(
      workforcePrice: price,
    );
  }

//  Stream<JournalCreateState> _mapWorkforceValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    WorkforceUtil.setWorkforce(
//        state.workforceNum, state.workforcePrice);
//    bool judge;
//    if (state.workforceNum > 0 || state.workforcePrice > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[8]["name"])) {
//        widget.add(journalCategory[8]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      workforceValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapWorkforceExpansionToState() async* {
    bool judge = state.workforceExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }
    yield state.update(
      workforceExpansion: judge,
    );
  }

  ///경운정보
  Stream<JournalCreateState> _mapFarmingCompleteToState(
      double farmingArea,
      String farmingAreaUnit,
      String farmingMethod,
      String farmingMethodUnit) async* {
    Farming farming = Farming(
        farmingArea: farmingArea,
        farmingAreaUnit: farmingAreaUnit,
        farmingMethod: farmingMethod,
        farmingMethodUnit: farmingMethodUnit,
        farmingValid: true,
        index: state.farmingList.length);
    List<Farming> _list = state.farmingList;
    _list.add(farming);
    List<Widgets> widgets = state.widgets;
    widgets.add(Widgets(
      name: getJournalCategoryName(id: state.category),
      index: farming.index,
    ));
    List<String> widgetList = state.widgetList;
    widgetList.add(getJournalCategoryName(id: state.category));
    yield state.update(farmingList: _list, farming: farming, widgets: widgets);
  }

  Stream<JournalCreateState> _mapFarmingEditToState(
      double farmingArea,
      String farmingAreaUnit,
      String farmingMethod,
      String farmingMethodUnit,
      int currentIndex) async* {
    Farming farming = Farming(
        farmingArea: farmingArea,
        farmingAreaUnit: farmingAreaUnit,
        farmingMethod: farmingMethod,
        farmingMethodUnit: farmingMethodUnit,
        farmingValid: true,
        index: state.farmingList.length);
    List<Farming> _list = state.farmingList;
    _list[currentIndex] = farming;

    yield state.update(farmingList: _list, farming: farming);
  }

  Stream<JournalCreateState> _mapFarmingDeleteToState(
      int index, int listIndex) async* {
    List<Farming> _list = state.farmingList;
    List<Widgets> _temp = state.widgets;
    List<String> _widgetList = state.widgetList;

    for (int i = index + 1; i < state.widgets.length; i++) {
      if (state.widgets[i].name == "경운정보") {
        Widgets temp = Widgets(
            name: state.widgets[i].name, index: state.widgets[i].index - 1);
        _temp[i] = temp;
      }
    }
    _widgetList.removeAt(listIndex);
    _list.removeAt(index);
    _temp.removeAt(listIndex);
    yield state.update();
  }

  Stream<JournalCreateState> _mapFarmingAreaChangedToState(double area) async* {
    yield state.update(
      farmingArea: area,
    );
  }

  Stream<JournalCreateState> _mapFarmingAreaUnitChangedToState(
      String unit) async* {
    yield state.update(
      farmingAreaUnit: unit,
    );
  }

  Stream<JournalCreateState> _mapFarmingMethodChangedToState(
      String method) async* {
    yield state.update(
      farmingMethod: method,
    );
  }

  Stream<JournalCreateState> _mapFarmingMethodUnitToState(
      String methodUnit) async* {
    yield state.update(
      farmingMethodUnit: methodUnit,
    );
  }

//  Stream<JournalCreateState> _mapFarmingValidChangedToState() async* {
//    List<String> widget = state.widgets;
//    FarmingUtil.setFarming(
//        state.farmingArea,
//        state.farmingAreaUnit,
//        state.farmingMethod,
//        state.farmingMethodUnit);
//    bool judge;
//    if (state.farmingMethod.length > 0 || state.farmingArea > 0) {
//      judge = true;
//      if (!state.widgets.contains(journalCategory[9]["name"])) {
//        widget.add(journalCategory[9]["name"]);
//      }
//    }
//
//    yield state.update(
//      widgets: widget,
//      farmingValid: judge,
//    );
//  }
//
  Stream<JournalCreateState> _mapFarmingExpansionToState() async* {
    bool judge = state.farmingExpansion;
    if (judge == false) {
      judge = true;
    } else {
      judge = false;
    }

    yield state.update(
      farmingExpansion: judge,
    );
  }

  ///소등록
//  Stream<JournalCreateState> _mapCowCategoryChangedToState(int category) async* {
//    yield state.update(
//      cowCategory: category,
//    );
//  }
//
//  Stream<JournalCreateState> _mapCowIdChangedToState(int id) async* {
//    yield state.update(
//      cowId: id,
//    );
//  }
//
//  Stream<JournalCreateState> _mapSexChangedToState(String sex) async* {
//    yield state.update(
//      sex: sex,
//    );
//  }
//
//  Stream<JournalCreateState> _mapBirthChangedToState(String birth) async* {
//    yield state.update(
//      birth: birth,
//    );
//  }
//
//  Stream<JournalCreateState> _mapCowHouseChangedToState(String house) async* {
//    yield state.update(
//      cowHouse: house,
//    );
//  }
//
//  Stream<JournalCreateState> _mapFertilizationDateChangedToState(
//      String fertilizationDate) async* {
//    yield state.update(
//      fertilizationDate: fertilizationDate,
//    );
//  }
//
//  Stream<JournalCreateState> _mapSpermIDChangedToState(String sperm) async* {
//    yield state.update(
//      spermId: sperm,
//    );
//  }
//
//  Stream<JournalCreateState> _mapBirthDueDateChangedToState(
//      String birthDue) async* {
//    yield state.update(
//      birthDueDate: birthDue,
//    );
//  }
//
//  Stream<JournalCreateState> _mapCharacteristicChangedToState(
//      String character) async* {
//    yield state.update(
//      characteristic: character,
//    );
//  }
//
//  Stream<JournalCreateState> _mapManageDateChangedToState(
//      String manageDate) async* {
//    yield state.update(
//      manageDate: manageDate,
//    );
//  }
//
//  Stream<JournalCreateState> _mapCowValidChangedToState() async* {
//  List<String> widget = state.widgets;
//    bool judge;
//    if (state.cowCategory > 0 ||
//        state.cowId > 0 ||
//        state.sex.length > 0 ||
//        state.birth.length > 0) judge = true;
//    yield state.update(
//      cowValid: judge,
//    );
//  }

//  Stream<JournalCreateState> _mapCowExpansionToState() async* {
//    bool judge = state.cowExpansion;
//    if (judge == false)
//      judge = true;
//    else
//      judge = false;
//
//    yield state.update(
//      cowExpansion: judge,
//    );
//  }

  // Stream<JournalCreateState> _mapNewWriteCompleteChangedToState() async* {
  //   String date = state.picked.toIso8601String().substring(0, 10);
  //   String monthDay = state.picked.toIso8601String().substring(5, 10);
  //   String yearMonth = state.picked.toIso8601String().substring(0, 7);
  //   int year = int.parse(state.picked.toIso8601String().substring(0, 4));
  //   String weatherDate = date.replaceAll("-", "").trim();
  //   String jid = getRandomId();
  //   List<Future> futures = [];
  //   List<JournalTag> journalTags = [];
  //   List<File> temp = state.imageList;
  //   List<String> urlList = [];
  //   List<String> deletePathList = [];
  //   List<GalleryModel> gallList = [];
  //
  //   List<JournalWeather> _weather = [];
  //   List<Facility> _facility = [];
  //   JournalWeather _journalWeather;
  //
  //   String today = DateTime.now().toIso8601String().substring(0, 10);
  //   bool isEqualDay = date == today ? true : false;
  //
  //   if (isEqualDay) {
  //     QuerySnapshot _journalWeatherQuery = await Firestore.instance
  //         .collection("Facility")
  //         .where("fid", isEqualTo: UserUtil.getUser().fid)
  //         .getDocuments();
  //
  //     _facility = _journalWeatherQuery.documents
  //         .map((DocumentSnapshot ds) => Facility.fromDs(ds))
  //         .toList();
  //     _journalWeather = JournalWeather(
  //         skyNow: _facility[0].skyNow == null ? 0 : _facility[0].skyNow.toInt(),
  //         tempMax:
  //         _facility[0].tempMax == null ? 0 : _facility[0].tempMax.toInt(),
  //         tempMin:
  //         _facility[0].tempMin == null ? 0 : _facility[0].tempMin.toInt(),
  //         rainProb:
  //         _facility[0].rainProb == null ? 0 : _facility[0].rainProb.toInt(),
  //         humidity: _facility[0].humidity == null
  //             ? 0
  //             : _facility[0].humidity.toInt());
  //     _weather.add(_journalWeather);
  //   } else {
  //     QuerySnapshot _journalWeatherQuery = await Firestore.instance
  //         .collection("Facility")
  //         .where("fid", isEqualTo: UserUtil.getUser().fid)
  //         .getDocuments();
  //
  //     _facility = _journalWeatherQuery.documents
  //         .map((DocumentSnapshot ds) => Facility.fromDs(ds))
  //         .toList();
  //     double lat = _facility[0].lat;
  //     double lng = _facility[0].lng;
  //     String _stnLds = getStationNum(lat, lng).toString();
  //     http.Response _response = await http.get(
  //         '$pastDailyApi&startDt=$weatherDate&endDt=$weatherDate&stnIds=$_stnLds');
  //     Map<String, dynamic> data = json.decode(_response.body);
  //
  //     ///강수량 퍼센트로 어케넣을지 고민해야함. 임의로 0, 날씨도 어케해야할지 고민해야함 임의로 3.
  //     _journalWeather = JournalWeather(
  //         skyNow: 3,
  //         tempMax:
  //         data["response"]["body"]["items"]["item"][0]["maxTa"].toInt(),
  //         tempMin:
  //         data["response"]["body"]["items"]["item"][0]["minTa"].toInt(),
  //         rainProb: 0,
  //         humidity:
  //         data["response"]["body"]["items"]["item"][0]["avgRhm"].toInt());
  //     _weather.add(_journalWeather);
  //   }
  //
  //   Journal journal = Journal(
  //     fid: UserUtil.getUser().fid,
  //     jid: state.jid.isNotEmpty ? state.jid : jid,
  //     date: date,
  //     monthDay: monthDay,
  //     yearMonth: yearMonth,
  //     year: year,
  //     title: state.title,
  //     content: state.content,
  //     tags: state.tag,
  //     widgets: state.widgets,
  //     widgetList: state.widgetList,
  //     weather: _weather,
  //     shipment: state.shipmentList.isEmpty ? null : state.shipmentList,
  //     fertilize: state.fertilizerList.isEmpty ? null : state.fertilizerList,
  //     pesticide: state.pesticideList.isEmpty ? null : state.pesticideList,
  //     pest: state.pestList.isEmpty ? null : state.pestList,
  //     planting: state.plantingList.isEmpty ? null : state.plantingList,
  //     seeding: state.seedingList.isEmpty ? null : state.seedingList,
  //     weeding: state.weedingList.isEmpty ? null : state.weedingList,
  //     watering: state.wateringList.isEmpty ? null : state.wateringList,
  //     workforce: state.workforceList.isEmpty ? null : state.workforceList,
  //     farming: state.farmingList.isEmpty ? null : state.farmingList,
  //   );
  //
  //   try {
  //     WriteBatch batch = Firestore.instance.batch();
  //     batch.setData(getJournalRef(journal.date), journal.toMap(), merge: true);
  //     batch.setData(getJournalRecDateRef(journal.date),
  //         {"${journal.date}": true, "fid": UserUtil.getUser().fid},
  //         merge: true);
  //     await batch.commit();
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   ///tag document추가
  //   state.tag.forEach((String tag) {
  //     journalTags.add(JournalTag(
  //         tag: tag, fid: UserUtil.getUser().fid, count: 1, recent: date));
  //   });
  //
  //   for (int i = 0; i < state.tag.length; i++) {
  //     allTag.add(state.tag[i]);
  //   }
  //
  //   if (state.isNewWrite) {
  //     try {
  //       journalTags.forEach((JournalTag tag) async {
  //         QuerySnapshot _tagQuery = await Firestore.instance
  //             .collection('Tag')
  //             .where("fid", isEqualTo: UserUtil.getUser().fid)
  //             .where("tag", isEqualTo: tag.tag)
  //             .getDocuments();
  //
  //         if (_tagQuery.documents.isEmpty) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&${tag.tag}')
  //               .setData(tag.toMap());
  //         } else {
  //           JournalTag journalTag1 = _tagQuery.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&${tag.tag}')
  //               .updateData({
  //             'tag': tag.tag,
  //             'fid': tag.fid,
  //             'count': journalTag1.count + 1,
  //           });
  //         }
  //       });
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     try {
  //       allTag.forEach((String tagElement) async {
  //         QuerySnapshot _tagQueryDelete = await Firestore.instance
  //             .collection('Tag')
  //             .where("fid", isEqualTo: UserUtil.getUser().fid)
  //             .where("tag", isEqualTo: tagElement)
  //             .getDocuments();
  //
  //         if (_tagQueryDelete.documents.isEmpty) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .setData(JournalTag(
  //               tag: tagElement,
  //               fid: UserUtil.getUser().fid,
  //               count: 1,
  //               recent: date)
  //               .toMap());
  //         } else if (state.tag.contains(tagElement)) {
  //           JournalTag journalTag2 = _tagQueryDelete.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //           //if (journalTag2.count == 0) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .updateData({
  //             'tag': tagElement,
  //             'fid': journalTag2.fid,
  //             'count': journalTag2.count == 0
  //                 ? journalTag2.count + 1
  //                 : state.originalTag.contains(tagElement)
  //                 ? journalTag2.count
  //                 : journalTag2.count + 1,
  //           });
  //         } else {
  //           JournalTag journalTag3 = _tagQueryDelete.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .updateData({
  //             'tag': tagElement,
  //             'fid': journalTag3.fid,
  //             'count': journalTag3.count == 0 ? 0 : journalTag3.count - 1,
  //           });
  //         }
  //       });
  //     } catch (w) {
  //       print(w);
  //     }
  //   }
  //
  //   ///사진추가 !!
  //   temp.forEach((File f) {
  //     futures.add(uploadImageFile(f).then((String s) {
  //       urlList.add(s);
  //     }));
  //   });
  //
  //   await Future.wait(futures);
  //
  //   urlList.forEach((String s) {
  //     gallList.add(GalleryModel(
  //         path: s, date: date, fid: UserUtil.getUser().fid, jid: jid));
  //   });
  //
  //   state.originalFilePath.forEach((String s) {
  //     if (!state.filePath.contains(s)) {
  //       deletePathList.add(s);
  //     }
  //   });
  //   try {
  //     deletePathList.forEach((String s) async {
  //       QuerySnapshot documentName = await Firestore.instance
  //           .collection("Pictures")
  //           .where("path", isEqualTo: s)
  //           .getDocuments();
  //
  //       await Firestore.instance
  //           .collection("Pictures")
  //           .document(documentName.documents[0].documentID)
  //           .delete();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   try {
  //     WriteBatch batch1 = Firestore.instance.batch();
  //     gallList.forEach((GalleryModel g) => {
  //       batch1.setData(
  //           Firestore.instance
  //               .collection('Pictures')
  //               .document('${getRandomId()}'),
  //           g.toMap(),
  //           merge: true)
  //     });
  //     await batch1.commit();
  //     yield* _mapAllStateResetToState();
  //     yield state.update(
  //       writeComplete: true,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  ///completeBtn
  // Stream<JournalCreateState> _mapWriteCompleteChangedToState() async* {
  //   String date = state.date.toIso8601String().substring(0, 10);
  //   String monthDay = state.date.toIso8601String().substring(5, 10);
  //   String yearMonth = state.date.toIso8601String().substring(0, 7);
  //   int year = int.parse(state.date.toIso8601String().substring(0, 4));
  //   String jid = getRandomId();
  //   List<Future> futures = [];
  //   List<JournalTag> journalTags = [];
  //
  //   List<File> temp = state.imageList;
  //   List<String> urlList = [];
  //   List<String> deletePathList = [];
  //   List<GalleryModel> gallList = [];
  //
  //   List<JournalWeather> _weather = [];
  //   List<Facility> _facility = [];
  //   JournalWeather _journalWeather;
  //
  //   String today = DateTime.now().toIso8601String().substring(0, 10);
  //   bool isEqualDay = date == today ? true : false;
  //
  //   if (isEqualDay) {
  //     QuerySnapshot _journalWeatherQuery = await Firestore.instance
  //         .collection("Facility")
  //         .where("fid", isEqualTo: UserUtil.getUser().fid)
  //         .getDocuments();
  //
  //     _facility = _journalWeatherQuery.documents
  //         .map((DocumentSnapshot ds) => Facility.fromDs(ds))
  //         .toList();
  //     _journalWeather = JournalWeather(
  //         skyNow: _facility[0].skyNow == null ? 0 : _facility[0].skyNow.toInt(),
  //         tempMax:
  //         _facility[0].tempMax == null ? 0 : _facility[0].tempMax.toInt(),
  //         tempMin:
  //         _facility[0].tempMin == null ? 0 : _facility[0].tempMin.toInt(),
  //         rainProb:
  //         _facility[0].rainProb == null ? 0 : _facility[0].rainProb.toInt(),
  //         humidity: _facility[0].humidity == null
  //             ? 0
  //             : _facility[0].humidity.toInt());
  //     _weather.add(_journalWeather);
  //   }
  //
  //   Journal journal = Journal(
  //     fid: UserUtil.getUser().fid,
  //     jid: state.jid.isNotEmpty ? state.jid : jid,
  //     date: date,
  //     monthDay: monthDay,
  //     yearMonth: yearMonth,
  //     year: year,
  //     title: state.title,
  //     content: state.content,
  //     tags: state.tag,
  //     widgets: state.widgets,
  //     widgetList: state.widgetList,
  //     weather: _weather,
  //     shipment: state.shipmentList.isEmpty ? null : state.shipmentList,
  //     fertilize: state.fertilizerList.isEmpty ? null : state.fertilizerList,
  //     pesticide: state.pesticideList.isEmpty ? null : state.pesticideList,
  //     pest: state.pestList.isEmpty ? null : state.pestList,
  //     planting: state.plantingList.isEmpty ? null : state.plantingList,
  //     seeding: state.seedingList.isEmpty ? null : state.seedingList,
  //     weeding: state.weedingList.isEmpty ? null : state.weedingList,
  //     watering: state.wateringList.isEmpty ? null : state.wateringList,
  //     workforce: state.workforceList.isEmpty ? null : state.workforceList,
  //     farming: state.farmingList.isEmpty ? null : state.farmingList,
  //   );
  //
  //   try {
  //     WriteBatch batch = Firestore.instance.batch();
  //     batch.setData(getJournalRef(journal.date), journal.toMap(), merge: true);
  //     batch.setData(getJournalRecDateRef(journal.date),
  //         {"${journal.date}": true, "fid": UserUtil.getUser().fid},
  //         merge: true);
  //     await batch.commit();
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   ///tag document추가
  //   state.tag.forEach((String tag) {
  //     journalTags.add(JournalTag(
  //         tag: tag, fid: UserUtil.getUser().fid, count: 1, recent: date));
  //   });
  //
  //   for (int i = 0; i < state.tag.length; i++) {
  //     allTag.add(state.tag[i]);
  //   }
  //   if (state.isNewWrite) {
  //     try {
  //       journalTags.forEach((JournalTag tag) async {
  //         QuerySnapshot _tagQuery = await Firestore.instance
  //             .collection('Tag')
  //             .where("fid", isEqualTo: UserUtil.getUser().fid)
  //             .where("tag", isEqualTo: tag.tag)
  //             .getDocuments();
  //
  //         if (_tagQuery.documents.isEmpty) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&${tag.tag}')
  //               .setData(tag.toMap());
  //         } else {
  //           JournalTag journalTag1 = _tagQuery.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&${tag.tag}')
  //               .updateData({
  //             'tag': tag.tag,
  //             'fid': tag.fid,
  //             'count': journalTag1.count + 1,
  //           });
  //         }
  //       });
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     try {
  //       allTag.forEach((String tagElement) async {
  //         QuerySnapshot _tagQueryDelete = await Firestore.instance
  //             .collection('Tag')
  //             .where("fid", isEqualTo: UserUtil.getUser().fid)
  //             .where("tag", isEqualTo: tagElement)
  //             .getDocuments();
  //
  //         if (_tagQueryDelete.documents.isEmpty) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .setData(JournalTag(
  //               tag: tagElement,
  //               fid: UserUtil.getUser().fid,
  //               count: 1,
  //               recent: date)
  //               .toMap());
  //         } else if (state.tag.contains(tagElement)) {
  //           JournalTag journalTag2 = _tagQueryDelete.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //           //if (journalTag2.count == 0) {
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .updateData({
  //             'tag': tagElement,
  //             'fid': journalTag2.fid,
  //             'count': journalTag2.count == 0
  //                 ? journalTag2.count + 1
  //                 : state.originalTag.contains(tagElement)
  //                 ? journalTag2.count
  //                 : journalTag2.count + 1,
  //           });
  //         } else {
  //           JournalTag journalTag3 = _tagQueryDelete.documents
  //               .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //               .toList()[0];
  //           await Firestore.instance
  //               .collection('Tag')
  //               .document('${UserUtil.getUser().fid}&$tagElement')
  //               .updateData({
  //             'tag': tagElement,
  //             'fid': journalTag3.fid,
  //             'count': journalTag3.count == 0 ? 0 : journalTag3.count - 1,
  //           });
  //         }
  //       });
  //     } catch (w) {
  //       print(w);
  //     }
  //   }
  //
  //   ///사진추가 !!
  //   temp.forEach((File f) {
  //     futures.add(uploadImageFile(f).then((String s) {
  //       urlList.add(s);
  //     }));
  //   });
  //
  //   await Future.wait(futures);
  //
  //   urlList.forEach((String s) {
  //     gallList.add(GalleryModel(
  //         path: s, date: date, fid: UserUtil.getUser().fid, jid: jid));
  //   });
  //
  //   state.originalFilePath.forEach((String s) {
  //     if (!state.filePath.contains(s)) {
  //       deletePathList.add(s);
  //     }
  //   });
  //   try {
  //     deletePathList.forEach((String s) async {
  //       QuerySnapshot documentName = await Firestore.instance
  //           .collection("Pictures")
  //           .where("path", isEqualTo: s)
  //           .getDocuments();
  //
  //       await Firestore.instance
  //           .collection("Pictures")
  //           .document(documentName.documents[0].documentID)
  //           .delete();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   try {
  //     WriteBatch batch1 = Firestore.instance.batch();
  //     gallList.forEach((GalleryModel g) => {
  //       batch1.setData(
  //           Firestore.instance
  //               .collection('Pictures')
  //               .document('${getRandomId()}'),
  //           g.toMap(),
  //           merge: true)
  //     });
  //     await batch1.commit();
  //     yield* _mapAllStateResetToState();
  //     yield state.update(
  //       writeComplete: true,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<String> uploadImageFile(File file) async {
  //   FirebaseStorage storage = FirebaseStorage();
  //   String temp = "";
  //   final String rand = "${Random().nextInt(10000)}";
  //   final StorageReference ref = storage
  //       .ref()
  //       .child('image_records')
  //       .child(UserUtil.getUser().uid)
  //       .child('$rand.jpg');
  //   final StorageUploadTask uploadTask = ref.putFile(file);
  //
  //   await (await uploadTask.onComplete)
  //       .ref
  //       .getDownloadURL()
  //       .then((dynamic url) {
  //     temp = url;
  //   });
  //
  //   return temp;
  // }

  // Stream<JournalCreateState> _mapDeleteJournalBtnPressed(String date) async* {
  //   try {
  //     WriteBatch batch = Firestore.instance.batch();
  //     batch.setData(getJournalRecDateRef(date), {"$date": false}, merge: true);
  //     batch.delete(getJournalRef(date));
  //     await batch.commit();
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   try {
  //     state.originalFilePath.forEach((String s) async {
  //       QuerySnapshot documentName = await Firestore.instance
  //           .collection("Pictures")
  //           .where("path", isEqualTo: s)
  //           .getDocuments();
  //
  //       await Firestore.instance
  //           .collection("Pictures")
  //           .document(documentName.documents[0].documentID)
  //           .delete();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   try {
  //     state.originalTag.forEach((String s) async {
  //       QuerySnapshot taqSnapshot = await Firestore.instance
  //           .collection("Tag")
  //           .where("tag", isEqualTo: s)
  //           .getDocuments();
  //
  //       JournalTag journalTag = taqSnapshot.documents
  //           .map((DocumentSnapshot d) => JournalTag.fromDs(d))
  //           .toList()[0];
  //       await Firestore.instance
  //           .collection('Tag')
  //           .document('${UserUtil.getUser().fid}&$s')
  //           .updateData({
  //         'tag': s,
  //         'fid': journalTag.fid,
  //         'count': journalTag.count - 1,
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   yield state.update(isDeleted: true);
  // }

  Stream<JournalCreateState> _mapPastBtnChangedToState() async* {
    yield state.update(
      pastBtn: true,
    );
  }

  Stream<JournalCreateState> _mapSelectDateTimePressedToState() async* {
    yield state.update(selectDatePressed: true);
  }

  Stream<JournalCreateState> _mapUnSelectDateTimePressedToState(
      DateTime picked) async* {
    DateTime pickedDate = picked;
    if ((pickedDate.year == DateTime.now().year) &&
        (pickedDate.month == DateTime.now().month) &&
        (pickedDate.day == DateTime.now().day)) {
      pickedDate = DateTime(
          pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0, 0, 0);
    }
    yield state.update(selectDatePressed: false, picked: pickedDate);
  }

  Stream<JournalCreateState> _mapChangeCategoryToState() async* {
    yield state.update(changeCategoryPressed: true);
  }

  Stream<JournalCreateState> _mapDeleteJournalGrpPressedToState() async* {
    yield state.update(buttonSelected: true);
  }

  Stream<JournalCreateState> _mapJournalInitToState(
      Journal existJournal, List<ImagePicture> existImage) async* {
    List<Map<String, dynamic>> temp = journalCategory
        .where((Map<String, dynamic> category) =>
            category["id"] == 0 ||
            category["id"] == 1 ||
            category["id"] == 2 ||
            category["id"] == 3 ||
            category["id"] == 4 ||
            category["id"] == 5 ||
            category["id"] == 6 ||
            category["id"] == 7 ||
            category["id"] == 8 ||
            category["id"] == 9)
        .toList();
    yield state.update(
      categories: temp,
      shipmentList: existJournal.shipment,
      fertilizerList: existJournal.fertilize,
      pesticideList: existJournal.pesticide,
      pestList: existJournal.pest,
      plantingList: existJournal.planting,
      seedingList: existJournal.seeding,
      weedingList: existJournal.weeding,
      wateringList: existJournal.watering,
      workforceList: existJournal.workforce,
      farmingList: existJournal.farming,
      widgetList: existJournal.widgetList,
      existJournal: existJournal,
      existImageList: existImage,
      selectedDate: existJournal.date,
    );
  }

  Stream<JournalCreateState> _mapWidgetListLoadedToState(
      List<Widgets> widgets) async* {
    yield state.update(widgets: widgets);
  }
}
