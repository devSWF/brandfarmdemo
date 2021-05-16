import 'package:BrandFarm/blocs/fm_issue/bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/blocs/fm_notification/fm_notification_bloc.dart';
import 'package:BrandFarm/fm_screens/issue/fm_issue_detail_screen.dart';
import 'package:BrandFarm/fm_screens/issue/fm_issue_screen.dart';
import 'package:BrandFarm/fm_screens/journal/fm_journal_detail_screen.dart';
import 'package:BrandFarm/fm_screens/journal/fm_journal_list.dart';
import 'package:BrandFarm/widgets/fm_journal/fm_journal_date_picker.dart';
import 'package:BrandFarm/widgets/fm_journal/fm_journal_title_bar.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMJournalScreen extends StatefulWidget {
  @override
  _FMJournalScreenState createState() => _FMJournalScreenState();
}

class _FMJournalScreenState extends State<FMJournalScreen> {
  FMJournalBloc _fmJournalBloc;
  FMIssueBloc _fmIssueBloc;
  FMNotificationBloc _fmNotificationBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    _fmIssueBloc = BlocProvider.of<FMIssueBloc>(context);
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMIssueBloc, FMIssueState>(
      listener: (context, istate) {},
      builder: (context, istate) {
        return BlocConsumer<FMJournalBloc, FMJournalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state.year.isNotEmpty && state.month.isNotEmpty)
                ? Scaffold(
                    backgroundColor: Color(0xFFEEEEEE),
                    body: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 11, 20, 11),
                        child: Stack(
                          children: [
                            Container(
                              // height: 800,
                              width: 814,
                              padding: EdgeInsets.fromLTRB(19, 29, 24, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: (state.navTo == 1)
                                  ? _homeList(state)
                                  : (state.navTo == 2)
                                      ? MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: _fmJournalBloc,
                                            ),
                                            BlocProvider.value(
                                              value: _fmNotificationBloc,
                                            ),
                                          ],
                                          child: FMJournalDetailScreen(),
                                        )
                                      : MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: _fmIssueBloc,
                                            ),
                                            BlocProvider.value(
                                              value: _fmJournalBloc,
                                            ),
                                            BlocProvider.value(
                                              value: _fmNotificationBloc,
                                            ),
                                          ],
                                          child: (state.order == '최신 순')
                                              ? FMIssueDetailScreen(
                                                  obj: istate
                                                      .issueList[state.index],
                                                  index: state.index,
                                                  order: state.order)
                                              : FMIssueDetailScreen(
                                                  obj: istate
                                                      .reverseList[state.index],
                                                  index: state.index,
                                                  order: state.order),
                                        ),
                            ),
                            (state.isFieldMenuButtonVisible)
                                ? Positioned(
                                    top: state.fieldMenuButtonY -
                                        state.fieldMenuButtonHeight -
                                        10,
                                    left: state.fieldMenuButtonX + 20,
                                    child: _dropdownMenu(state),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  )
                : LinearProgressIndicator();
          },
        );
      },
    );
  }

  Widget _dropdownMenu(FMJournalState state) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        child: Column(
          children: List.generate(state.fieldList.length, (index) {
            return InkResponse(
              onTap: () {
                _fmJournalBloc.add(SetField(field: state.fieldList[index]));
                _fmJournalBloc.add(ReloadFMJournal());
                _fmJournalBloc.add(GetJournalList());
                _fmIssueBloc.add(GetIssueList(field: state.fieldList[index]));
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${state.fieldList[index].name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFF15B85B),
                            ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _homeList(FMJournalState state) {
    return ListView(
      shrinkWrap: true,
      children: [
        BlocProvider.value(
          value: _fmJournalBloc,
          child: FMJournalTitle(shouldReload: state.shouldReload),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _fmIssueBloc,
            ),
            BlocProvider.value(
              value: _fmJournalBloc,
            ),
          ],
          child: FMJournalDatePicker(
            isIssue: state.isIssue,
          ),
        ),
        SizedBox(
          height: 27,
        ),
        // FMJournalListPicker(),
        _fmJournalListPicker(state),
        SizedBox(
          height: 76,
        ),
        // (!isIssue) ? FMJournalList() : FMIssueList(),
        switchList(state),
      ],
    );
  }

  Widget switchList(FMJournalState state) {
    switch (state.isIssue) {
      case true:
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _fmIssueBloc,
              ),
              BlocProvider.value(
                value: _fmJournalBloc,
              ),
            ],
            child: FMIssueList(
              field: state.field,
              shouldReload: state.shouldReload,
            ),
          );
        }
        break;
      default:
        {
          return BlocProvider.value(
            value: _fmJournalBloc,
            child: FMJournalList(
              shouldReload: state.shouldReload,
            ),
          );
        }
        break;
    }
  }

  Widget _fmJournalListPicker(FMJournalState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _journalSwitch(state),
        SizedBox(
          width: 180,
        ),
        Row(
          children: [
            _order(state: state),
            SizedBox(
              width: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _journalSwitch(FMJournalState state) {
    return Container(
      height: 30,
      width: 212,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xFFBCBCBC)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            alignment: (state.isIssue) ? Alignment(1, 0) : Alignment(-1, 0),
            child: Container(
              height: 30,
              width: 115,
              decoration: BoxDecoration(
                color: Color(0xFF15B85B),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(26, 4, 26, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkResponse(
                  onTap: () {
                    setState(() {
                      _fmJournalBloc.add(ChangeSwitchState());
                    });
                  },
                  child: Text(
                    '성장일지',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, // normal
                          color: (state.isIssue)
                              ? Color(0x4D000000)
                              : Colors.white, // Color(0x4D000000) or white
                        ),
                  ),
                ),
                InkResponse(
                  onTap: () {
                    setState(() {
                      _fmJournalBloc.add(ChangeSwitchState());
                    });
                  },
                  child: Text(
                    '이슈일지',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, // normal
                          color: (state.isIssue)
                              ? Colors.white
                              : Color(0x4D000000), // Color(0x4D000000) or white
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _order({FMJournalState state}) {
    return DropdownBelow(
      // isDense: true,
      value: state.order,
      items: <String>['최신 순', '오래된 순']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // style: Theme.of(context).textTheme.bodyText2.copyWith(
      //       fontWeight: FontWeight.normal,
      //       fontSize: 13,
      //       color: Color(0xB3000000),
      //     ),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 10,
            color: Color(0xB3000000),
          ),
      itemWidth: 100,
      boxPadding: EdgeInsets.symmetric(horizontal: 6),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 13,
            color: Color(0xB3000000),
          ),
      boxWidth: 100,
      boxHeight: 24,
      // icon: Icon(
      //   Icons.arrow_drop_down_outlined,
      //   color: Color(0xFFBEBEBE),
      // ),
      onChanged: (String value) {
        setState(() {
          _fmJournalBloc.add(ChangeListOrder(order: value));
        });
      },
      // underline: Container(),
    );
  }
}

// class FMIssueDetailScreen extends StatefulWidget {
//   @override
//   _FMIssueDetailScreenState createState() => _FMIssueDetailScreenState();
// }

// class _FMIssueDetailScreenState extends State<FMIssueDetailScreen> {
//   //  for testing
//   SubJournalIssue testObj;
//   List pic = [1, 2, 3];
//
//   String date;
//   String weekday;
//   String fieldName;
//
//   @override
//   void initState() {
//     super.initState();
//     testObj = SubJournalIssue(
//       category: 1,
//       comments: 0,
//       date: Timestamp.now(),
//       fid: '--',
//       issid: '--',
//       issueState: 1,
//       sfmid: '--',
//       title: '2021_04_05_작물영양이슈',
//       uid: '--',
//       contents: contents,
//     );
//     date = getDate(date: testObj.date);
//     fieldName = '한동이네 딸기 농장 필드A';
//   }
//
//   String getDate({Timestamp date}) {
//     DateTime dt = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
//     setState(() {
//       weekday = daysOfWeek(index: dt.weekday);
//     });
//     return '${dt.year}년 ${dt.month}월 ${dt.day}일';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//     // return Container(
//     //   width: 814,
//     //   padding: EdgeInsets.fromLTRB(32, 39, 18, defaultPadding),
//     //   decoration: BoxDecoration(
//     //     color: Colors.white,
//     //     borderRadius: BorderRadius.circular(12),
//     //   ),
//     //   child: ListView(
//     //     children: [
//     //       _title(),
//     //       SizedBox(height: 31,),
//     //       Divider(height: 26, thickness: 1, color: Color(0xFFDFDFDF),),
//     //       _subtitle(),
//     //       Divider(height: 26, thickness: 1, color: Color(0xFFDFDFDF),),
//     //       SizedBox(height: 8,),
//     //       _infoCard(),
//     //       SizedBox(height: 7,),
//     //       Divider(height: 48, thickness: 1, color: Color(0xFFDFDFDF),),
//     //       (pic.isNotEmpty) ? _imageList() : Container(),
//     //       SizedBox(height: 5,),
//     //       Divider(height: 60, thickness: 1, color: Color(0xFFDFDFDF),),
//     //       _contents(),
//     //     ],
//     //   ),
//     // );
//   }
//
//   Widget _title() {
//     return Text('${testObj.title}',
//       style: Theme.of(context).textTheme.bodyText2.copyWith(
//         fontSize: 24,
//         fontWeight: FontWeight.w200,
//         color: Colors.black,
//       ),);
//   }
//
//   Widget _subtitle() {
//     return Text('${date} / ${fieldName} / 이슈일지',
//       style: Theme.of(context).textTheme.bodyText2.copyWith(
//         color: Color(0x80000000),
//       ),);
//   }
//
//   Widget _infoCard() {
//     return Container(
//       width: 343,
//       height: 137,
//       padding: EdgeInsets.fromLTRB(30, 23, 0, 0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(width: 1, color: Color(0x4D000000)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text('날짜',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   color: Color(0xB3000000),
//                 ),),
//               SizedBox(width: 14,),
//               Text('${date} ${weekday}',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),),
//             ],
//           ),
//           SizedBox(height: 19,),
//           Row(
//             children: [
//               Text('카테고리',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   color: Color(0xB3000000),
//                 ),),
//               SizedBox(width: 14,),
//               Text('${getCategory(cat: testObj.category)}',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF219653),
//                 ),),
//             ],
//           ),
//           SizedBox(height: 19,),
//           Row(
//             children: [
//               Text('이슈상태',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   color: Color(0xB3000000),
//                 ),),
//               SizedBox(width: 14,),
//               Container(
//                 width: 32.22,
//                 height: 20,
//                 child: FittedBox(
//                   child: DepartmentBadge(department: getIssueState(state: testObj.issueState),),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _imageList() {
//     return Column(
//       children: [
//         InkWell(
//           onTap: (){},
//           child: Row(
//             children: [
//               Text('사진',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),),
//               SizedBox(width: 6,),
//               Text('${pic.length}',
//                 style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   fontSize: 18,
//                   color: Color(0xFF15B85B),
//                 ),),
//               SizedBox(width: 6,),
//               Icon(Icons.arrow_drop_down_outlined, color: Color(0xFFBEBEBE),),
//             ],
//           ),
//         ),
//         SizedBox(height: 22,),
//         ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: pic.length,
//           itemBuilder: (context, index) {
//             return Row(
//               children: [
//                 (index == 0) ? SizedBox(width: 32,) : Container(),
//                 Container(
//                   width: 144,
//                   height: 144,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/strawberry.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _contents() {
//     return Text('${testObj.contents}',
//       style: Theme.of(context).textTheme.bodyText1.copyWith(
//         fontWeight: FontWeight.w300,
//         color: Color(0xB3000000),
//       ),);
//   }
//
//   String getCategory({int cat}) {
//     switch(cat) {
//       case 1 : {
//         return '작물';
//       }
//       break;
//       case 2 : {
//         return '시설';
//       }
//       break;
//       case 3 : {
//         return '기타';
//       }
//       break;
//     }
//   }
//
//   String getIssueState({int state}) {
//     switch(state) {
//       case 1 : {
//         return 'todo';
//       }
//       break;
//       case 2 : {
//         return 'doing';
//       }
//       break;
//       case 3 : {
//         return 'done';
//       }
//       break;
//     }
//   }
// }
