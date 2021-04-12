import 'package:BrandFarm/blocs/journal_create/bloc.dart';
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
import 'package:BrandFarm/utils/journal/farming_util.dart';
import 'package:BrandFarm/utils/journal/fertilizer_util.dart';
import 'package:BrandFarm/utils/journal/pest_util.dart';
import 'package:BrandFarm/utils/journal/pesticide_util.dart';
import 'package:BrandFarm/utils/journal/planting_util.dart';
import 'package:BrandFarm/utils/journal/seeding_util.dart';
import 'package:BrandFarm/utils/journal/shipment_util.dart';
import 'package:BrandFarm/utils/journal/watering_util.dart';
import 'package:BrandFarm/utils/journal/weeding_util.dart';
import 'package:BrandFarm/utils/journal/workforce_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubJournalInputActivityScreen extends StatefulWidget {
  @override
  _SubJournalInputActivityScreenState createState() =>
      _SubJournalInputActivityScreenState();
}

class _SubJournalInputActivityScreenState
    extends State<SubJournalInputActivityScreen> {
  JournalCreateBloc _journalCreateBloc;

  TextTheme textTheme;
  ColorScheme colorScheme;


  @override
  void initState() {
    super.initState();
    _journalCreateBloc = BlocProvider.of<JournalCreateBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    colorScheme = Theme.of(context).colorScheme;
    return BlocListener<JournalCreateBloc, JournalCreateState>(
      cubit: _journalCreateBloc,
      listener: (BuildContext context, JournalCreateState state) async {},
      child: BlocBuilder<JournalCreateBloc, JournalCreateState>(
          cubit: _journalCreateBloc,
          builder: (BuildContext context, JournalCreateState state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 2.0,
                centerTitle: true,
                leading: TextButton(
                  child: Text('취소', style: textTheme.subtitle1,),
                  onPressed: ()=> Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: _selectedCategory(context, state),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "완료", style: textTheme.subtitle1,
                    ),
                    onPressed: state.checkData == true ? () {} : completeValid,
                  )
                ],
              ),
              body: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  if (state.category == 8)
                    WorkForceAdd(
                        workforce: state.isNewWrite == true
                            ? null
                            : WorkforceUtil.getWorkforce())
                  else if (state.category == 3)
                    PestAdd(
                      pest:
                          state.isNewWrite == true ? null : PestUtil.getPest(),
                    )
                  else if (state.category == 9)
                    FarmingAdd(
                        farming: state.isNewWrite == true
                            ? null
                            : FarmingUtil.getFarming())
                  else if (state.category == 0)
                    ShipmentAdding(
                        shipment: state.isNewWrite == true
                            ? null
                            : ShipmentUtil.getShipment())
                  else if (state.category == 1)
                    FertilizerAdd(
                        fertilize: state.isNewWrite == true
                            ? null
                            : FertilizerUtil.getFertilizer())
                  else if (state.category == 2)
                    PesticideAdd(
                        pesticide: state.isNewWrite == true
                            ? null
                            : PesticideUtil.getPesticide())
                  else if (state.category == 4)
                    PlantingAdd(
                        planting: state.isNewWrite == true
                            ? null
                            : PlantingUtil.getPlanting())
                  else if (state.category == 5)
                    SeedingAdd(
                        seeding: state.isNewWrite == true
                            ? null
                            : SeedingUtil.getSeeding())
                  else if (state.category == 6)
                    WeedingAdd(
                        weeding: state.isNewWrite == true
                            ? null
                            : WeedingUtil.getWeeding())
                  else if (state.category == 7)
                    WateringAdd(
                        watering: state.isNewWrite == true
                            ? null
                            : WateringUtil.getWatering())
                ],
              ),
//      body: ,
            );
          }),
    );
    //return ;
  }

  completeValid() {
    if (_journalCreateBloc.state.category == 8) {
      _journalCreateBloc.add(WorkforceComplete(
          workforceNum: _journalCreateBloc.state.workforceNum,
          workforcePrice: _journalCreateBloc.state.workforcePrice));
    } else if (_journalCreateBloc.state.category == 3) {
      _journalCreateBloc.add(PestComplete(
          pestKind: _journalCreateBloc.state.pestKind,
          spreadDegree: _journalCreateBloc.state.spreadDegree,
          spreadDegreeUnit: _journalCreateBloc.state.spreadDegreeUnit));
    } else if (_journalCreateBloc.state.category == 9) {
      _journalCreateBloc.add(FarmingComplete(
          farmingArea: _journalCreateBloc.state.farmingArea,
          farmingAreaUnit: _journalCreateBloc.state.farmingAreaUnit,
          farmingMethod: _journalCreateBloc.state.farmingMethod,
          farmingMethodUnit: _journalCreateBloc.state.farmingMethodUnit));
    } else if (_journalCreateBloc.state.category == 0) {
      _journalCreateBloc.add(ShipmentComplete(
          shipmentPlant: _journalCreateBloc.state.shipmentPlant,
          shipmentPath: _journalCreateBloc.state.shipmentPath,
          shipmentUnit: _journalCreateBloc.state.shipmentUnit,
          shipmentUnitSelect: _journalCreateBloc.state.shipmentUnitSelect,
          shipmentAmount: _journalCreateBloc.state.shipmentAmount,
          shipmentGrade: _journalCreateBloc.state.shipmentGrade,
          shipmentPrice: _journalCreateBloc.state.shipmentPrice));
    } else if (_journalCreateBloc.state.category == 1) {
      _journalCreateBloc.add(FertilizerComplete(
          fertilizerMethod: _journalCreateBloc.state.fertilizerMethod,
          fertilizerArea: _journalCreateBloc.state.fertilizerArea,
          fertilizerAreaUnit: _journalCreateBloc.state.fertilizerAreaUnit,
          fertilizerMaterialName:
              _journalCreateBloc.state.fertilizerMaterialName,
          fertilizerMaterialUse: _journalCreateBloc.state.fertilizerMaterialUse,
          fertilizerMaterialUnit:
              _journalCreateBloc.state.fertilizerMaterialUnit,
          fertilizerWater: _journalCreateBloc.state.fertilizerWater,
          fertilizerWaterUnit: _journalCreateBloc.state.fertilizerWaterUnit));
    } else if (_journalCreateBloc.state.category == 2) {
      _journalCreateBloc.add(PesticideComplete(
          pesticideMethod: _journalCreateBloc.state.pesticideMethod,
          pesticideArea: _journalCreateBloc.state.pesticideArea,
          pesticideAreaUnit: _journalCreateBloc.state.pesticideAreaUnit,
          pesticideMaterialName: _journalCreateBloc.state.pesticideMaterialName,
          pesticideMaterialUse: _journalCreateBloc.state.pesticideMaterialUse,
          pesticideMaterialUnit: _journalCreateBloc.state.pesticideMaterialUnit,
          pesticideWater: _journalCreateBloc.state.pesticideWater,
          pesticideWaterUnit: _journalCreateBloc.state.pesticideWaterUnit));
    } else if (_journalCreateBloc.state.category == 4) {
      _journalCreateBloc.add(PlantingComplete(
          plantingArea: _journalCreateBloc.state.plantingArea,
          plantingAreaUnit: _journalCreateBloc.state.plantingAreaUnit,
          plantingCount: _journalCreateBloc.state.plantingCount,
          plantingPrice: _journalCreateBloc.state.plantingPrice));
    } else if (_journalCreateBloc.state.category == 5) {
      _journalCreateBloc.add(SeedingComplete(
          seedingArea: _journalCreateBloc.state.seedingArea,
          seedingAreaUnit: _journalCreateBloc.state.seedingAreaUnit,
          seedingAmount: _journalCreateBloc.state.seedingAmount,
          seedingAmountUnit: _journalCreateBloc.state.seedingAmountUnit));
    } else if (_journalCreateBloc.state.category == 6) {
      _journalCreateBloc.add(WeedingComplete(
          weedingProgress: _journalCreateBloc.state.weedingProgress,
          weedingUnit: _journalCreateBloc.state.weedingUnit));
    } else if (_journalCreateBloc.state.category == 7) {
      _journalCreateBloc.add(WateringComplete(
          wateringArea: _journalCreateBloc.state.wateringArea,
          wateringAmountUnit: _journalCreateBloc.state.wateringAmountUnit,
          wateringAmount: _journalCreateBloc.state.wateringAmount,
          wateringAreaUnit: _journalCreateBloc.state.wateringAreaUnit));
    }
    Navigator.of(context).pop();
  }
  //
  // Widget categoryItem(String buttonText, int id, BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.5,
  //     child: FlatButton(
  //       // focusColor: mainColor,
  //       // highlightColor: mainColor,
  //       // splashColor: mainColor,
  //       onPressed: () {
  //         // _JournalCreateBloc.add(CategoryChanged(
  //         //     category: getJournalCategoryId(name: buttonText)));
  //         // Navigator.of(context).pop();
  //       },
  //       padding: EdgeInsets.only(top: 20, bottom: 20),
  //       child: Text(
  //         buttonText,
  //         // style: button5,
  //       ),
  //     ),
  //   );
  // }

  Widget _selectedCategory(BuildContext context, JournalCreateState state){
    TextStyle _titleStyle = textTheme.bodyText1.copyWith(fontSize: 18.0);
    if (state.category == 0)
      return Text(
        '출하정보',
        style: _titleStyle,
      );
    else if (state.category == 1)
      return Text(
        '비료정보',
        style: _titleStyle,
      );
    else if (state.category == 2)
      return Text(
        '농약정보',
        style: _titleStyle,
      );
    else if (state.category == 3)
      return Text(
        '병,해충정보',
        style: _titleStyle,
      );
    else if (state.category == 4)
      return Text(
        '정식정보',
        style: _titleStyle,
      );
    else if (state.category == 5)
      return Text(
        '파종정보',
        style: _titleStyle,
      );
    else if (state.category == 6)
      return Text(
        '제초정보',
        style: _titleStyle,
      );
    else if (state.category == 7)
      return Text(
        '관수정보',
        style: _titleStyle,
      );
    else if (state.category == 8)
      return Text(
        '인력투입정보',
        style: _titleStyle,
      );
    else
      return Text(
        '경운정보',
        style: _titleStyle,
      );
  }
}
