import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMPlanDetailScreen extends StatefulWidget {
  @override
  _FMPlanDetailScreenState createState() => _FMPlanDetailScreenState();
}

class _FMPlanDetailScreenState extends State<FMPlanDetailScreen> {
  FMPlanBloc _fmPlanBloc;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
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

  Widget _detailList(FMPlanState state) {
    List<List<FMPlan>> _list;
    (state.selectedField == 0)
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
                            getField(state, _list[main][sub].fid);
                        return (state.selectedField == 0)
                            ? _all(main, sub, _list, fieldName)
                            : _fromFieldSelection(main, sub, _list, fieldName, state);
                      }),
                    )
                  : Container();
            }),
          )
        : Container();
  }

  Widget _fromFieldSelection(
      int main, int sub, List<List<FMPlan>> list, String fieldName, FMPlanState state) {
    return Column(
      children: [
        (sub == 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: (main == 0)
                        ? Color(0xFF15B85B)
                        : (main == 1 && state.selectedField == 1)
                            ? Colors.orange
                            : (main == 1 && state.selectedField == 2)
                                ? Colors.yellow
                                : (main == 1 && state.selectedField == 3)
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
                                    : (main == 1 && state.selectedField == 1)
                                        ? Colors.orange
                                        : (main == 1 && state.selectedField == 2)
                                            ? Colors.yellow
                                            : (main == 1 && state.selectedField == 3)
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
                                : (main == 1 && state.selectedField == 1)
                                    ? Colors.orange
                                    : (main == 1 && state.selectedField == 2)
                                        ? Colors.yellow
                                        : (main == 1 && state.selectedField == 3)
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

  Widget _all(int main, int sub, List<List<FMPlan>> list, String fieldName) {
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

  String getField(FMPlanState state, String fid) {
    List<Field> _list =
        state.fieldList.where((element) => element.fid == fid).toList();
    return '${_list[0].name}';
    // int index = state.fieldList.indexWhere((element) => element.fid == fid);
    // return (index == 0)
    //     ? '통'
    //     : (index == 1)
    //         ? 'A'
    //         : (index == 2)
    //             ? 'B'
    //             : (index == 3)
    //                 ? 'C'
    //                 : 'D';
  }

  List<List<FMPlan>> getSortedListBySelection(FMPlanState state) {
    List<List<FMPlan>> _list = [];
    List<FMPlan> all =
        state.detailList.where((element) => element.fid == '').toList();
    List<FMPlan> selectedList = state.detailList.where((element) {
      return element.fid == state.fieldList[state.selectedField].fid;
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

  List<List<FMPlan>> getSortedList(FMPlanState state) {
    List<List<FMPlan>> _list = [];
    List<FMPlan> all = (state.fieldList.length >= 1)
        ? state.detailList.where((element) => element.fid == '').toList()
        : [];
    List<FMPlan> f1 = (state.fieldList.length >= 2)
        ? state.detailList
            .where((element) => element.fid == state.fieldList[1].fid)
            .toList()
        : [];
    List<FMPlan> f2 = (state.fieldList.length >= 3)
        ? state.detailList
            .where((element) => element.fid == state.fieldList[2].fid)
            .toList()
        : [];
    List<FMPlan> f3 = (state.fieldList.length >= 4)
        ? state.detailList
            .where((element) => element.fid == state.fieldList[3].fid)
            .toList()
        : [];
    List<FMPlan> f4 = (state.fieldList.length >= 5)
        ? state.detailList
            .where((element) => element.fid == state.fieldList[4].fid)
            .toList()
        : [];

    // print('///////////${all.length}');
    // print('///////////${f1.length}');
    // print('///////////${f2.length}');
    // print('///////////${f3.length}');
    // print('///////////${f4.length}');

    switch (state.fieldList.length) {
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
