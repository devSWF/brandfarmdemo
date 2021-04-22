import 'package:BrandFarm/blocs/fm_notification/bloc.dart';
import 'package:BrandFarm/fm_screens/notification/fm_notification_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMNotificationScreen extends StatefulWidget {
  @override
  _FMNotificationScreenState createState() => _FMNotificationScreenState();
}

class _FMNotificationScreenState extends State<FMNotificationScreen> {
  FMNotificationBloc _fmNotificationBloc;
  GlobalKey _searchMenu = GlobalKey();
  double x;
  double y;
  TextEditingController _searchController;
  FocusNode _searchNode;

  @override
  void initState() {
    super.initState();
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
    // _fmNotificationBloc.add(GetNotificationList());
    _searchController = TextEditingController();
    _searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMNotificationBloc, FMNotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if(state.notificationList.isNotEmpty){
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
                                            _fmNotificationBloc.add(
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
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                (!state.notificationList[index]
                                                    .isReadByFM)
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
                                                Text('${state.notificationList[index].no}'),
                                              ],
                                            )),
                                            DataCell(Text(
                                                '${state.notificationList[index].title}')),
                                            DataCell(Text('${postedDate}')),
                                            DataCell(Text(
                                                '${state.notificationList[index].name}')),
                                          ],
                                          onSelectChanged: (value) async {
                                            _fmNotificationBloc.add(
                                                SetNotification(
                                                    notice:
                                                        state.notificationList[
                                                            index]));
                                            if(!state.notificationList[index].isReadByFM){
                                              _fmNotificationBloc.add(
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
                                  left: x - 328,
                                  child: _searchMenuList(state))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : LinearProgressIndicator();
      },
    );
  }

  Future<void> _showDetail() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmNotificationBloc,
            child: FMNotificationDetailScreen(),
          );
        });
  }

  Widget _showTotalList(FMNotificationState state) {
    return InkResponse(
      onTap: () {
        setState(() {
          _fmNotificationBloc.add(ShowTotalList());
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

  Widget _searchType(FMNotificationState state) {
    return InkResponse(
      onTap: () {
        setState(() {
          _fmNotificationBloc.add(UpdateNotDropdownMenuState());
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

  Widget _searchMenuList(FMNotificationState state) {
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
                _fmNotificationBloc.add(UpdateNotMenuIndex(menuIndex: index));
                _fmNotificationBloc.add(UpdateNotDropdownMenuState());
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
                _fmNotificationBloc
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
