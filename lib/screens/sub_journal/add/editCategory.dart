import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:BrandFarm/screens/sub_journal/add/farmingAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/fertilizerAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/pestAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/pesticideAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/plantingAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/seedingAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/shipmentAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/wateringAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/weedingAdd.dart';
import 'package:BrandFarm/screens/sub_journal/add/workForceAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategory extends StatefulWidget {
  final Journal journal;
  final int index;
  final int listIndex;
  final String category;

  EditCategory(
      {this.journal,
      @required this.index,
      @required this.category,
      @required this.listIndex});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  JournalCreateBloc _journalCreateBloc;
  int _index;
  int _listIndex;
  String _category;

  @override
  void initState() {
    super.initState();
    _journalCreateBloc = BlocProvider.of<JournalCreateBloc>(context);
    _index = widget.index;
    _category = widget.category;
    _listIndex = widget.listIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JournalCreateBloc, JournalCreateState>(
      cubit: _journalCreateBloc,
      listener: (BuildContext context, JournalCreateState state) async {},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: TextButton(
            child: Text(
              '취소',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            "활동 수정하기",
            style:
                Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "완료",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onPressed: () {
                if (_category == "인력투입정보") {
                  _journalCreateBloc.add(WorkforceEdit(
                      workforceNum: _journalCreateBloc.state.workforceNum,
                      workforcePrice: _journalCreateBloc.state.workforcePrice,
                      currentIndex: _index));
                } else if (_category == "병,해충정보") {
                  _journalCreateBloc.add(PestEdit(
                      pestKind: _journalCreateBloc.state.pestKind,
                      spreadDegree: _journalCreateBloc.state.spreadDegree,
                      spreadDegreeUnit:
                          _journalCreateBloc.state.spreadDegreeUnit,
                      currentIndex: _index));
                } else if (_category == "경운정보") {
                  _journalCreateBloc.add(FarmingEdit(
                      farmingArea: _journalCreateBloc.state.farmingArea,
                      farmingAreaUnit: _journalCreateBloc.state.farmingAreaUnit,
                      farmingMethod: _journalCreateBloc.state.farmingMethod,
                      farmingMethodUnit:
                          _journalCreateBloc.state.farmingMethodUnit,
                      currentIndex: _index));
                } else if (_category == "출하정보") {
                  _journalCreateBloc.add(ShipmentEdit(
                    shipmentPlant: _journalCreateBloc.state.shipmentPlant,
                    shipmentPath: _journalCreateBloc.state.shipmentPath,
                    shipmentUnit: _journalCreateBloc.state.shipmentUnit,
                    shipmentUnitSelect:
                        _journalCreateBloc.state.shipmentUnitSelect,
                    shipmentAmount: _journalCreateBloc.state.shipmentAmount,
                    shipmentGrade: _journalCreateBloc.state.shipmentGrade,
                    shipmentPrice: _journalCreateBloc.state.shipmentPrice,
                    currentIndex: _index,
                    listIndex: _listIndex,
                  ));
                } else if (_category == "비료정보") {
                  _journalCreateBloc.add(FertilizerEdit(
                      fertilizerMethod:
                          _journalCreateBloc.state.fertilizerMethod,
                      fertilizerArea: _journalCreateBloc.state.fertilizerArea,
                      fertilizerAreaUnit:
                          _journalCreateBloc.state.fertilizerAreaUnit,
                      fertilizerMaterialName:
                          _journalCreateBloc.state.fertilizerMaterialName,
                      fertilizerMaterialUse:
                          _journalCreateBloc.state.fertilizerMaterialUse,
                      fertilizerMaterialUnit:
                          _journalCreateBloc.state.fertilizerMaterialUnit,
                      fertilizerWater: _journalCreateBloc.state.fertilizerWater,
                      fertilizerWaterUnit:
                          _journalCreateBloc.state.fertilizerWaterUnit,
                      currentIndex: _index));
                } else if (_category == "농약정보") {
                  _journalCreateBloc.add(PesticideEdit(
                      pesticideMethod: _journalCreateBloc.state.pesticideMethod,
                      pesticideArea: _journalCreateBloc.state.pesticideArea,
                      pesticideAreaUnit:
                          _journalCreateBloc.state.pesticideAreaUnit,
                      pesticideMaterialName:
                          _journalCreateBloc.state.pesticideMaterialName,
                      pesticideMaterialUse:
                          _journalCreateBloc.state.pesticideMaterialUse,
                      pesticideMaterialUnit:
                          _journalCreateBloc.state.pesticideMaterialUnit,
                      pesticideWater: _journalCreateBloc.state.pesticideWater,
                      pesticideWaterUnit:
                          _journalCreateBloc.state.pesticideWaterUnit,
                      currentIndex: _index));
                } else if (_category == "정식정보") {
                  _journalCreateBloc.add(PlantingEdit(
                      plantingArea: _journalCreateBloc.state.plantingArea,
                      plantingAreaUnit:
                          _journalCreateBloc.state.plantingAreaUnit,
                      plantingCount: _journalCreateBloc.state.plantingCount,
                      plantingPrice: _journalCreateBloc.state.plantingPrice,
                      currentIndex: _index));
                } else if (_category == "파종정보") {
                  _journalCreateBloc.add(SeedingEdit(
                      seedingArea: _journalCreateBloc.state.seedingArea,
                      seedingAreaUnit: _journalCreateBloc.state.seedingAreaUnit,
                      seedingAmount: _journalCreateBloc.state.seedingAmount,
                      seedingAmountUnit:
                          _journalCreateBloc.state.seedingAmountUnit,
                      currentIndex: _index));
                } else if (_category == "제초정보") {
                  _journalCreateBloc.add(WeedingEdit(
                      weedingProgress: _journalCreateBloc.state.weedingProgress,
                      weedingUnit: _journalCreateBloc.state.weedingUnit,
                      currentIndex: _index));
                } else if (_category == "관수정보") {
                  _journalCreateBloc.add(WateringEdit(
                      wateringArea: _journalCreateBloc.state.wateringArea,
                      wateringAmountUnit:
                          _journalCreateBloc.state.wateringAmountUnit,
                      wateringAmount: _journalCreateBloc.state.wateringAmount,
                      wateringAreaUnit:
                          _journalCreateBloc.state.wateringAreaUnit,
                      currentIndex: _index));
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: BlocBuilder(
          cubit: _journalCreateBloc,
          builder: (BuildContext context, JournalCreateState state) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(_category,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      if (_category == "인력투입정보")
                        WorkForceAdd(
                            workforce: state.isNewWrite
                                ? null
                                : state.workforceList.length == _index
                                    ? null
                                    : state.workforceList[_index])
                      else if (_category == "병,해충정보")
                        PestAdd(
                          pest: state.isNewWrite
                              ? null
                              : state.pestList.length == _index
                                  ? null
                                  : state.pestList[_index],
                        )
                      else if (_category == "경운정보")
                        FarmingAdd(
                            farming: state.isNewWrite
                                ? null
                                : state.farmingList.length == _index
                                    ? null
                                    : state.farmingList[_index])
                      else if (_category == "출하정보")
                        ShipmentAdding(
                            shipment: state.isNewWrite
                                ? null
                                : state.shipmentList.length == _index
                                    ? null
                                    : state.shipmentList[_index])
                      else if (_category == "비료정보")
                        FertilizerAdd(
                            fertilize: state.isNewWrite
                                ? null
                                : state.fertilizerList.length == _index
                                    ? null
                                    : state.fertilizerList[_index])
                      else if (_category == "농약정보")
                        PesticideAdd(
                            pesticide: state.isNewWrite
                                ? null
                                : state.pesticideList.length == _index
                                    ? null
                                    : state.pesticideList[_index])
                      else if (_category == "정식정보")
                        PlantingAdd(
                            planting: state.isNewWrite
                                ? null
                                : state.plantingList.length == _index
                                    ? null
                                    : state.plantingList[_index])
                      else if (_category == "파종정보")
                        SeedingAdd(
                            seeding: state.seedingList.length == _index
                                ? null
                                : state.seedingList[_index])
                      else if (_category == "제초정보")
                        WeedingAdd(
                            weeding: state.isNewWrite
                                ? null
                                : state.weedingList.length == _index
                                    ? null
                                    : state.weedingList[_index])
                      else if (_category == "관수정보")
                        WateringAdd(
                            watering: state.isNewWrite
                                ? null
                                : state.wateringList.length == _index
                                    ? null
                                    : state.wateringList[_index])
                    ],
                  ),
                ),
                RaisedButton(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.086,
                      child: Center(
                        child: Text(
                          "삭제",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 20.0,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      )),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (_category == "출하정보") {
                      _journalCreateBloc.add(
                          ShipmentDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "비료정보") {
                      _journalCreateBloc.add(FertilizerDelete(
                          index: _index, listIndex: _listIndex));
                    } else if (_category == "농약정보") {
                      _journalCreateBloc.add(PesticideDelete(
                          index: _index, listIndex: _listIndex));
                    } else if (_category == "병,해충정보") {
                      _journalCreateBloc.add(
                          PestDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "정식정보") {
                      _journalCreateBloc.add(
                          PlantingDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "파종정보") {
                      _journalCreateBloc.add(
                          SeedingDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "제초정보") {
                      _journalCreateBloc.add(
                          WeedingDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "관수정보") {
                      _journalCreateBloc.add(
                          WateringDelete(index: _index, listIndex: _listIndex));
                    } else if (_category == "인력투입정보") {
                      _journalCreateBloc.add(WorkforceDelete(
                          index: _index, listIndex: _listIndex));
                    } else if (_category == "경운정보") {
                      _journalCreateBloc.add(
                          FarmingDelete(index: _index, listIndex: _listIndex));
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
    //return ;
  }
}
