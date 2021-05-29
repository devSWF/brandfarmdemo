import 'package:BrandFarm/blocs/purchase/purchase_bloc.dart';
import 'package:BrandFarm/blocs/purchase/purchase_event.dart';
import 'package:BrandFarm/blocs/purchase/purchase_state.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_purchase_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMPurchaseScreen extends StatefulWidget {
  @override
  _FMPurchaseScreenState createState() => _FMPurchaseScreenState();
}

class _FMPurchaseScreenState extends State<FMPurchaseScreen> {
  PurchaseBloc _fmPurchaseBloc;
  GlobalKey _searchMenu = GlobalKey();
  double x;
  double y;
  String dropDownValue = '자재명';
  TextEditingController _searchController;
  FocusNode _searchNode;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<PurchaseBloc>(context);
    _fmPurchaseBloc.add(LoadFMPurchase());
    _fmPurchaseBloc.add(GetPurchaseList());
    _searchController = TextEditingController();
    _searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBloc, PurchaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (!state.isLoading) {
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
        return (!state.isLoading)
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
                                  '구매목록',
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
                                            _fmPurchaseBloc.add(SetListOrder(
                                                columnIndex: columnIndex));
                                          }),
                                      DataColumn(label: Text('자재명')),
                                      DataColumn(label: Text('수량')),
                                      DataColumn(label: Text('상태')),
                                      DataColumn(label: Text('수령일자')),
                                      DataColumn(label: Text('신청자')),
                                      DataColumn(label: Text('수령인')),
                                    ],
                                    rows: List.generate(
                                        state.productListBySearch.length,
                                        (index) {
                                      String reqDate = DateFormat('yyyy-MM-dd')
                                          .format(state
                                              .productListBySearch[index]
                                              .requestDate
                                              .toDate());
                                      String recDate = (state
                                                  .productListBySearch[index]
                                                  .receiveDate !=
                                              null)
                                          ? DateFormat('yyyy-MM-dd').format(
                                              state.productListBySearch[index]
                                                  .receiveDate
                                                  .toDate())
                                          : '--';
                                      String rec = (state
                                                  .productListBySearch[index]
                                                  .receiver
                                                  .isNotEmpty ||
                                              state.productListBySearch[index]
                                                      .receiver !=
                                                  null)
                                          ? state.productListBySearch[index]
                                              .receiver
                                          : '--';
                                      return DataRow(
                                          cells: [
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (state
                                                        .productListBySearch[
                                                            index]
                                                        .isThereUpdates)
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
                                                Text('${reqDate}'),
                                              ],
                                            )),
                                            DataCell(Text(
                                                '${state.productListBySearch[index].productName}')),
                                            DataCell(Text(
                                                '${state.productListBySearch[index].amount}')),
                                            DataCell(Text(
                                                '${state.productListBySearch[index].waitingState}')),
                                            DataCell(Text('${recDate}')),
                                            DataCell(Text(
                                                '${state.productListBySearch[index].requester}')),
                                            DataCell(Text('${rec}')),
                                          ],
                                          onSelectChanged: (value) async {
                                            _fmPurchaseBloc.add(SetProduct(
                                                product:
                                                    state.productListBySearch[
                                                        index]));
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
            value: _fmPurchaseBloc,
            child: FMPurchaseDetailScreen(),
          );
        });
  }

  Widget _searchType(PurchaseState state) {
    return InkResponse(
      onTap: () {
        setState(() {
          _fmPurchaseBloc.add(UpdateDropdownMenuState());
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

  Widget _searchMenuList(PurchaseState state) {
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
                _fmPurchaseBloc.add(UpdateMenuIndex(menuIndex: index));
                _fmPurchaseBloc.add(UpdateDropdownMenuState());
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
  //           color: Color(0xFF6F6F6F),
  //         ),
  //     itemWidth: 93,
  //     boxPadding: EdgeInsets.symmetric(horizontal: 8),
  //     boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //           color: Color(0xFF6F6F6F),
  //         ),
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
                _fmPurchaseBloc.add(GetPurchaseListBySearch(word: text));
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
