import 'package:BrandFarm/blocs/om_plan/om_plan_bloc.dart';
import 'package:BrandFarm/blocs/om_plan/om_plan_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OMPlanDetailScreen extends StatefulWidget {
  @override
  _OMPlanDetailScreenState createState() => _OMPlanDetailScreenState();
}

class _OMPlanDetailScreenState extends State<OMPlanDetailScreen> {
  OMPlanBloc _omPlanBloc;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _omPlanBloc = BlocProvider.of<OMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OMPlanBloc, OMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${state.selectedDate.year}년 ${state.selectedDate.month}월 ${state.selectedDate.day}일',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
            ),
            SizedBox(
              height: 37,
            ),
            (state.detailList.length > 0) ? _detailList(state) : Container(),
          ],
        );
      },
    );
  }

  Widget _detailList(OMPlanState state) {
    List<List<OMPlan>> _list;
    (state.selectedFarm == 0)
        ? _list = getSortedList(state)
        : _list = getSortedListBySelection(state);
    // print(_list.length);
    // return Container();
    return (_list.length > 0)
        ? Column(
            children: List.generate(_list.length, (main) {
              return (_list[main].length > 0)
                  ? Column(
                      children: List.generate(_list[main].length, (sub) {
                        String fieldName =
                            getFarm(state, _list[main][sub].farmID);
                        return (state.selectedFarm == 0)
                            ? _all(main, sub, _list, fieldName)
                            : _fromFieldSelection(
                                main, sub, _list, fieldName, state);
                      }),
                    )
                  : Container();
            }),
          )
        : Container();
  }

  Widget _fromFieldSelection(int main, int sub, List<List<OMPlan>> list,
      String fieldName, OMPlanState state) {
    return Column(
      children: [
        (sub == 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: (main == 0)
                        ? Color(0xFF15B85B)
                        : (main == 1 && state.selectedFarm == 1)
                            ? Colors.orange
                            : (main == 1 && state.selectedFarm == 2)
                                ? Colors.yellow
                                : (main == 1 && state.selectedFarm == 3)
                                    ? Colors.blue
                                    : Colors.purple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${fieldName}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // (main == 0)
                  //     ? SizedBox(
                  //         width: 11,
                  //       )
                  //     : SizedBox(
                  //         width: 16,
                  //       ),
                  Row(
                    children: [
                      Container(
                        width: 22,
                      ),
                      Container(
                        width: 166,
                        child: Text(
                          '${list[main][sub].content} (${DateFormat('M/d').format(list[main][sub].startDate.toDate())} ~ ${DateFormat('M/d').format(list[main][sub].endDate.toDate())})',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: (main == 0)
                                    ? Color(0xFF15B85B)
                                    : (main == 1 && state.selectedFarm == 1)
                                        ? Colors.orange
                                        : (main == 1 && state.selectedFarm == 2)
                                            ? Colors.yellow
                                            : (main == 1 &&
                                                    state.selectedFarm == 3)
                                                ? Colors.blue
                                                : Colors.purple,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 22,
                  ),
                  Container(
                    width: 166,
                    child: Text(
                      '${list[main][sub].content} (${DateFormat('M/d').format(list[main][sub].startDate.toDate())} ~ ${DateFormat('M/d').format(list[main][sub].endDate.toDate())})',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: (main == 0)
                                ? Color(0xFF15B85B)
                                : (main == 1 && state.selectedFarm == 1)
                                    ? Colors.orange
                                    : (main == 1 && state.selectedFarm == 2)
                                        ? Colors.yellow
                                        : (main == 1 && state.selectedFarm == 3)
                                            ? Colors.blue
                                            : Colors.purple,
                          ),
                    ),
                  ),
                ],
              ),
        SizedBox(
          height: 12,
        ),
        (sub == list[main].length - 1)
            ? Divider(
                height: 1,
                thickness: 1,
                color: Color(0x4D000000),
              )
            : Container(),
        (sub == list[main].length - 1)
            ? SizedBox(
                height: 12,
              )
            : Container(),
      ],
    );
  }

  Widget _all(int main, int sub, List<List<OMPlan>> list, String fieldName) {
    return Column(
      children: [
        (sub == 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: (main == 0)
                        ? Color(0xFF15B85B)
                        : (main == 1)
                            ? Colors.orange
                            : (main == 2)
                                ? Colors.yellow
                                : (main == 3)
                                    ? Colors.blue
                                    : Colors.purple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${fieldName}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // (main == 0)
                  //     ? SizedBox(
                  //         width: 11,
                  //       )
                  //     : SizedBox(
                  //         width: 16,
                  //       ),
                  Row(
                    children: [
                      Container(
                        width: 22,
                      ),
                      Container(
                        width: 166,
                        child: Text(
                          '${list[main][sub].content} (${DateFormat('M/d').format(list[main][sub].startDate.toDate())} ~ ${DateFormat('M/d').format(list[main][sub].endDate.toDate())})',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: (main == 0)
                                    ? Color(0xFF15B85B)
                                    : (main == 1)
                                        ? Colors.orange
                                        : (main == 2)
                                            ? Colors.yellow
                                            : (main == 3)
                                                ? Colors.blue
                                                : Colors.purple,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 22,
                  ),
                  Container(
                    width: 166,
                    child: Text(
                      '${list[main][sub].content} (${DateFormat('M/d').format(list[main][sub].startDate.toDate())} ~ ${DateFormat('M/d').format(list[main][sub].endDate.toDate())})',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: (main == 0)
                                ? Color(0xFF15B85B)
                                : (main == 1)
                                    ? Colors.orange
                                    : (main == 2)
                                        ? Colors.yellow
                                        : (main == 3)
                                            ? Colors.blue
                                            : Colors.purple,
                          ),
                    ),
                  ),
                ],
              ),
        SizedBox(
          height: 12,
        ),
        (sub == list[main].length - 1)
            ? Divider(
                height: 1,
                thickness: 1,
                color: Color(0x4D000000),
              )
            : Container(),
        (sub == list[main].length - 1)
            ? SizedBox(
                height: 12,
              )
            : Container(),
      ],
    );
  }

  String getFarm(OMPlanState state, String farmID) {
    List<Farm> _list =
        state.farmList.where((element) => element.farmID == farmID).toList();
    return '${_list[0].name}';
  }

  List<List<OMPlan>> getSortedListBySelection(OMPlanState state) {
    List<List<OMPlan>> _list = [];
    List<OMPlan> all =
        state.detailList.where((element) => element.farmID == '').toList();
    List<OMPlan> selectedList = state.detailList.where((element) {
      return element.farmID == state.farmList[state.selectedFarm].farmID;
    }).toList();

    // print('///////////${all.length}');
    // print('///////////${selectedList.length}');

    (all.isNotEmpty)
        ? _list.insert(0, all)
        : _list.insert(0, []); //print('all is empty');
    (selectedList.isNotEmpty)
        ? _list.add(selectedList)
        : _list.add([]); //print('f1 is empty');

    return _list;
  }

  List<List<OMPlan>> getSortedList(OMPlanState state) {
    List<List<OMPlan>> _list = [];
    List<OMPlan> all = (state.farmList.length >= 1)
        ? state.detailList.where((element) => element.farmID == '').toList()
        : [];
    List<OMPlan> f1 = (state.farmList.length >= 2)
        ? state.detailList
            .where((element) => element.farmID == state.farmList[1].farmID)
            .toList()
        : [];
    List<OMPlan> f2 = (state.farmList.length >= 3)
        ? state.detailList
            .where((element) => element.farmID == state.farmList[2].farmID)
            .toList()
        : [];
    List<OMPlan> f3 = (state.farmList.length >= 4)
        ? state.detailList
            .where((element) => element.farmID == state.farmList[3].farmID)
            .toList()
        : [];
    List<OMPlan> f4 = (state.farmList.length >= 5)
        ? state.detailList
            .where((element) => element.farmID == state.farmList[4].farmID)
            .toList()
        : [];

    // print('///////////${all.length}');
    // print('///////////${f1.length}');
    // print('///////////${f2.length}');
    // print('///////////${f3.length}');
    // print('///////////${f4.length}');

    switch (state.farmList.length) {
      case 2:
        {
          // print('////////////// case 2');
          (all.isNotEmpty)
              ? _list.insert(0, all)
              : _list.insert(0, []); //print('all is empty');
          (f1.isNotEmpty)
              ? _list.add(f1)
              : _list.add([]); //print('f1 is empty');
        }
        break;
      case 3:
        {
          // print('////////////// case 3');
          (all.isNotEmpty)
              ? _list.insert(0, all)
              : _list.insert(0, []); //print('all is empty');
          (f1.isNotEmpty)
              ? _list.add(f1)
              : _list.add([]); //print('f1 is empty');
          (f2.isNotEmpty)
              ? _list.add(f2)
              : _list.add([]); //print('f2 is empty');
        }
        break;
      case 4:
        {
          // print('////////////// case 4');
          (all.isNotEmpty)
              ? _list.insert(0, all)
              : _list.insert(0, []); //print('all is empty');
          (f1.isNotEmpty)
              ? _list.add(f1)
              : _list.add([]); //print('f1 is empty');
          (f2.isNotEmpty)
              ? _list.add(f2)
              : _list.add([]); //print('f2 is empty');
          (f3.isNotEmpty)
              ? _list.add(f3)
              : _list.add([]); //print('f3 is empty');
        }
        break;
      case 5:
        {
          // print('////////////// case 5');
          (all.isNotEmpty)
              ? _list.insert(0, all)
              : _list.insert(0, []); //print('all is empty');
          (f1.isNotEmpty)
              ? _list.add(f1)
              : _list.add([]); //print('f1 is empty');
          (f2.isNotEmpty)
              ? _list.add(f2)
              : _list.add([]); //print('f2 is empty');
          (f3.isNotEmpty)
              ? _list.add(f3)
              : _list.add([]); //print('f3 is empty');
          (f4.isNotEmpty)
              ? _list.add(f4)
              : _list.add([]); //print('f4 is empty');
        }
        break;
      default:
        {
          // print('////////////// default');
          (all.isNotEmpty)
              ? _list.insert(0, all)
              : _list.insert(0, []); //print('all is empty');
        }
        break;
    }

    return _list;
  }
}
