import 'package:BrandFarm/blocs/om_notification/om_notification_bloc.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_event.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_state.dart';
import 'package:BrandFarm/om_screens/om_notification/om_notification_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OMNotificationScreen extends StatefulWidget {
  @override
  _OMNotificationScreenState createState() => _OMNotificationScreenState();
}

class _OMNotificationScreenState extends State<OMNotificationScreen> {
  OMNotificationBloc _omNotificationBloc;
  GlobalKey _searchMenu = GlobalKey();
  double x;
  double y;
  TextEditingController _searchController;
  FocusNode _searchNode;

  @override
  void initState() {
    super.initState();
    _omNotificationBloc = BlocProvider.of<OMNotificationBloc>(context);
    // _fmNotificationBloc.add(GetNotificationList());
    _searchController = TextEditingController();
    _searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OMNotificationBloc, OMNotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.notificationList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final RenderBox renderBox =
                _searchMenu.currentContext.findRenderObject();
            final position = renderBox.localToGlobal(Offset.zero);
            setState(() {
              x = position.dx;
              y = position.dy;
            });
            // print('${x} ${y}');
          });
        }
        return (state.notificationList.isNotEmpty)
            ? Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                body: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _searchNode.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                      child: Stack(
                        children: [
                          Container(
                            width: 814,
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(32, 31, 42, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '공지사항',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 25,
                                        color: Colors.black,
                                      ),
                                ),
                                SizedBox(
                                  height: 26,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _showTotalList(state),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    _searchType(state),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    _searchBar(),
                                  ],
                                ),
                                FittedBox(
                                  child: DataTable(
                                    showCheckboxColumn: false,
                                    sortColumnIndex: state.currentSortColumn,
                                    sortAscending: state.isAscending,
                                    columns: [
                                      DataColumn(label: Text('No.')),
                                      DataColumn(label: Text('제목')),
                                      DataColumn(
                                          label: Row(
                                            children: [
                                              Text('신청일자'),
                                              (state.isAscending)
                                                  ? Icon(
                                                      Icons.arrow_drop_up,
                                                      color: Colors.black,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black,
                                                    )
                                            ],
                                          ),
                                          onSort: (columnIndex, _) {
                                            _omNotificationBloc.add(
                                                SetNotificationListOrder(
                                                    columnIndex: columnIndex));
                                          }),
                                      DataColumn(label: Text('게시자')),
                                    ],
                                    rows: List.generate(
                                        state.notificationList.length, (index) {
                                      String postedDate =
                                          DateFormat('yyyy-MM-dd').format(state
                                                  .notificationList[index]
                                                  .postedDate
                                                  .toDate()) ??
                                              '--';
                                      return DataRow(
                                          cells: [
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (!state.notificationList[index]
                                                        .isReadByOffice)
                                                    ? Container(
                                                        height: 6,
                                                        width: 6,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 6,
                                                        width: 6,
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                Text(
                                                    '${state.notificationList[index].no}'),
                                              ],
                                            )),
                                            DataCell(Text(
                                                '${state.notificationList[index].title}')),
                                            DataCell(Text('${postedDate}')),
                                            DataCell(Text(
                                                '${state.notificationList[index].name}')),
                                          ],
                                          onSelectChanged: (value) async {
                                            _omNotificationBloc.add(
                                                SetNotification(
                                                    notice:
                                                        state.notificationList[
                                                            index]));
                                            if (!state.notificationList[index]
                                                .isReadByOffice) {
                                              _omNotificationBloc.add(
                                                  SetNoticeAsRead(
                                                      index: index));
                                            }
                                            await _showDetail();
                                          });
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (state.showDropdownMenu)
                              ? Positioned(
                                  top: y - 40,
                                  left: x - 328 + 65,
                                  child: _searchMenuList(state))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Row(
                children: [
                  Container(
                      width: 814,
                      child: Center(child: CircularProgressIndicator())),
                ],
              );
      },
    );
  }

  Future<void> _showDetail() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _omNotificationBloc,
            child: OMNotificationDetailScreen(),
          );
        });
  }

  Widget _showTotalList(OMNotificationState state) {
    return InkResponse(
      onTap: () {
        setState(() {
          _omNotificationBloc.add(ShowTotalList());
        });
      },
      child: Container(
        height: 24,
        width: 93,
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0x4D000000)),
        ),
        child: Text(
          '전체보기',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Color(0xB3000000),
              ),
        ),
      ),
    );
  }

  Widget _searchType(OMNotificationState state) {
    return InkResponse(
      onTap: () {
        setState(() {
          _omNotificationBloc.add(UpdateNotDropdownMenuState());
        });
      },
      child: Container(
        key: _searchMenu,
        height: 24,
        width: 93,
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0x4D000000)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.menu[state.menuIndex]}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Color(0xB3000000),
                  ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 12,
              color: Color(0xFFBEBEBE),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchMenuList(OMNotificationState state) {
    return Container(
      width: 93,
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Color(0x4D000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(state.menu.length, (index) {
          return InkResponse(
            onTap: () {
              setState(() {
                _omNotificationBloc.add(UpdateNotMenuIndex(menuIndex: index));
                _omNotificationBloc.add(UpdateNotDropdownMenuState());
              });
            },
            child: Container(
              height: 23,
              child: Text(
                '${state.menu[index]}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0xB3000000),
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Widget _searchType() {
  //   return DropdownBelow(
  //     value: dropDownValue,
  //     items: <String>['자재명', '신청자', '수령인']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //     itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //       color: Color(0xFF6F6F6F),
  //     ),
  //     itemWidth: 93,
  //     boxPadding: EdgeInsets.symmetric(horizontal: 8),
  //     boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //       color: Color(0xFF6F6F6F),
  //     ),
  //     boxWidth: 93,
  //     boxHeight: 24,
  //     onChanged: (String value) {
  //       setState(() {
  //         dropDownValue = value;
  //       });
  //     },
  //   );
  // }

  Widget _searchBar() {
    return Container(
      height: 24,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0x4D000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          FittedBox(
              child: Icon(
            Icons.search,
            color: Color(0x4D000000),
          )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchNode,
              onTap: () {
                _searchNode.requestFocus();
              },
              onChanged: (text) {},
              onSubmitted: (text) {
                _omNotificationBloc
                    .add(GetNotificationListBySearch(word: text));
              },
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Color(0xB3000000),
                  ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(6, 10, 0, 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
