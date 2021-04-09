import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_event.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_purchase_detail_screen.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMPurchaseScreen extends StatefulWidget {
  @override
  _FMPurchaseScreenState createState() => _FMPurchaseScreenState();
}

class _FMPurchaseScreenState extends State<FMPurchaseScreen> {
  FMPurchaseBloc _fmPurchaseBloc;

  // for testing
  List<ForTest> forTesting = List.generate(
      10,
      (index) => ForTest(
            index,
            'product${index}',
            '${index * 3}',
            '대기',
            index * 5,
            '박브팜',
            '김브팜${index}',
          ));

  int _currentSortColumn = 0;
  bool _isAscending = true;
  String dropDownValue = '자재명';
  TextEditingController _searchController;
  FocusNode _searchNode;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _fmPurchaseBloc.add(LoadFMPurchase());
    _fmPurchaseBloc.add(GetPurchaseList());
    _searchController = TextEditingController();
    _searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPurchaseBloc, FMPurchaseState>(
      listener: (context, state) {},
      builder: (context, state) {
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
                      child: Container(
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
                                _searchType(),
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
                                        _fmPurchaseBloc.add(SetListOrder(columnIndex: columnIndex));
                                      }),
                                  DataColumn(label: Text('자재명')),
                                  DataColumn(label: Text('수량')),
                                  DataColumn(label: Text('상태')),
                                  DataColumn(label: Text('수령일자')),
                                  DataColumn(label: Text('신청자')),
                                  DataColumn(label: Text('수령인')),
                                ],
                                rows: List.generate(
                                    state.productListFromDB.length, (index) {
                                  String reqDate = DateFormat('yyyy-MM-dd')
                                      .format(state
                                          .productListFromDB[index].requestDate
                                          .toDate());
                                  String recDate = (state
                                              .productListFromDB[index]
                                              .receiveDate !=
                                          null)
                                      ? DateFormat('yyyy-MM-dd').format(state
                                          .productListFromDB[index].receiveDate
                                          .toDate())
                                      : '--';
                                  String rec = (state.productListFromDB[index]
                                              .receiver.isNotEmpty ||
                                          state.productListFromDB[index]
                                                  .receiver !=
                                              null)
                                      ? state.productListFromDB[index].receiver
                                      : '--';
                                  return DataRow(
                                      cells: [
                                        DataCell(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            (state.productListFromDB[index]
                                                    .isThereUpdates)
                                                ? Container(
                                                    height: 6,
                                                    width: 6,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 6,
                                                    width: 6,
                                                    color: Colors.transparent,
                                                  ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            Text('${reqDate}'),
                                          ],
                                        )),
                                        DataCell(Text(
                                            '${state.productListFromDB[index].productName}')),
                                        DataCell(Text(
                                            '${state.productListFromDB[index].amount}')),
                                        DataCell(Text(
                                            '${state.productListFromDB[index].waitingState}')),
                                        DataCell(Text('${recDate}')),
                                        DataCell(Text(
                                            '${state.productListFromDB[index].requester}')),
                                        DataCell(Text('${rec}')),
                                      ],
                                      onSelectChanged: (value) async {
                                        await _showDetail();
                                      });
                                }),
                              ),
                            ),
                          ],
                        ),
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
          return FMPurchaseDetailScreen();
        });
  }

  Widget _searchType() {
    return DropdownBelow(
      value: dropDownValue,
      items: <String>['자재명', '신청자', '수령인']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Color(0xFF6F6F6F),
          ),
      itemWidth: 93,
      boxPadding: EdgeInsets.symmetric(horizontal: 8),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Color(0xFF6F6F6F),
          ),
      boxWidth: 93,
      boxHeight: 24,
      onChanged: (String value) {
        setState(() {
          dropDownValue = value;
        });
      },
    );
  }

  Widget _searchBar() {
    return Container(
      height: 24,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0x4D000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.fromLTRB(8, 6, 0, 6),
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
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// for testing
class ForTest {
  int requestDate;
  String productName;
  String amountOfProduct;
  String waitingState;
  int receiveDate;
  String requester;
  String receiver;

  ForTest(
    this.requestDate,
    this.productName,
    this.amountOfProduct,
    this.waitingState,
    this.receiveDate,
    this.requester,
    this.receiver,
  );
}
