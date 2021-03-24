import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/repository/fm_plan/fm_plan_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMPlanBloc extends Bloc<FMPlanEvent, FMPlanState> {
  FMPlanBloc() : super(FMPlanState.empty());

  @override
  Stream<FMPlanState> mapEventToState(FMPlanEvent event) async* {
    if (event is LoadFMPlan) {
      yield* _mapLoadFMPlanToState();
    } else if (event is GetFieldListForFMPlan) {
      yield* _mapGetFieldListForFMPlanToState();
    } else if (event is GetPlanList) {
      yield* _mapGetPlanListToState();
    } else if (event is PostNewPlan) {
      yield* _mapPostNewPlanToState(
        event.startDate,
        event.endDate,
        event.title,
        event.content,
        event.selectedField,
      );
    }
  }

  Stream<FMPlanState> _mapLoadFMPlanToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMPlanState> _mapGetFieldListForFMPlanToState() async* {
    Farm farm = await FMPlanRepository().getFarmInfo();
    List<Field> currFieldList = [
      Field(
          fieldCategory: farm.fieldCategory,
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: '전체일정')
    ];
    List<Field> newFieldList =
        await FMPlanRepository().getFieldList(farm.fieldCategory);
    List<Field> totalFieldList = [
      ...currFieldList,
      ...newFieldList,
    ];

    yield state.update(
      farm: farm,
      fieldList: totalFieldList,
      field: totalFieldList[0],
    );
  }

  Stream<FMPlanState> _mapGetPlanListToState() async* {
    // get plan list
    List<FMPlan> plist = [];
    plist = await FMPlanRepository().getPlanList(state.farm.farmID);

    yield state.update(
      planList: plist,
    );
  }

  Stream<FMPlanState> _mapPostNewPlanToState(
      DateTime startDate,
      DateTime endDate,
      String title,
      String content,
      int selectedField) async* {
    // post new plan
    String planID = '';
    planID = FirebaseFirestore.instance.collection('Plan').doc().id;
    FMPlan newPlan = FMPlan(
      planID: planID,
      uid: UserUtil.getUser().uid,
      name: UserUtil.getUser().name,
      imgUrl: UserUtil.getUser().imgUrl,
      startDate: Timestamp.fromDate(startDate),
      endDate: Timestamp.fromDate(endDate),
      title: title,
      content: content,
      isReadByFM: true,
      isReadByOffice: false,
      isReadBySFM: false,
      from: 2, // 1 : office, 2 : FM
      fid: (selectedField > 0) ? state.fieldList[selectedField].fid : '',
      farmID: state.farm.farmID,
    );

    FMPlanRepository().postPlan(newPlan);

    List<FMPlan> plist = state.planList;
    if (plist.isEmpty) {
      plist.insert(0, newPlan);
    } else {
      plist.add(newPlan);
    }

    yield state.update(
      planList: plist,
    );
  }
}
