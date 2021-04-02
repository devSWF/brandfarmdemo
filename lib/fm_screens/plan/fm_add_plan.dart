import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/widgets/fm_shared_widgets/fm_small_calendar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMAddPlan extends StatefulWidget {
  // final int selectedField;
  //
  // FMAddPlan({Key key, @required this.selectedField}) : super(key: key);

  @override
  _FMAddPlanState createState() => _FMAddPlanState();
}

class _FMAddPlanState extends State<FMAddPlan> {
  FMPlanBloc _fmPlanBloc;
  GlobalKey _key = GlobalKey();
  OverlayEntry _overlayEntry;

  // DateTime startDate;
  // DateTime endDate;
  bool isDateOrderCorrect;
  bool isEverythingFilledOut;

  TextEditingController _titleController;
  TextEditingController _contentController;
  FocusNode _titleNode;
  FocusNode _contentNode;
  String _title;
  String _content;

  // for dropdown menu
  int selectedFieldIndex = 0;
  double height = 0.0;
  double width = 0.0;
  double x = 0.0;
  double y = 0.0;
  bool isDropdownButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    // startDate = DateTime.now();
    // endDate = DateTime.now();
    isDateOrderCorrect = true;
    isEverythingFilledOut = false;
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _titleNode = FocusNode();
    _contentNode = FocusNode();
    _title = '';
    _content = '';
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _afterLayout();
    // });
  }

  void _afterLayout() {
    _getSize();
    _getPosition();
  }

  void _getSize() {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final size = renderBox.size;
    setState(() {
      height = size.height;
      width = size.width;
    });
    print(size);
  }

  void _getPosition() {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      x = position.dx;
      y = position.dy;
    });
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _afterLayout();
          if (_title.isNotEmpty && _content.isNotEmpty) {
            setState(() {
              isEverythingFilledOut = true;
            });
          } else {
            setState(() {
              isEverythingFilledOut = false;
            });
          }
          if (state.startDate.isBefore(state.endDate) ||
              state.startDate.isAtSameMomentAs(state.endDate)) {
            setState(() {
              isDateOrderCorrect = true;
            });
          } else {
            setState(() {
              isDateOrderCorrect = false;
            });
          }
        });
        return (!state.isConfirmed)
            ? Stack(
                children: [
                  AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      height: 464,
                      width: 493,
                      padding: EdgeInsets.fromLTRB(20, 18, 18, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _titleBar(),
                          Divider(
                            height: 22,
                            thickness: 1,
                            color: Color(0xFFE1E1E1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _pickDate(state),
                          SizedBox(
                            height: 19,
                          ),
                          _writeTitle(),
                          SizedBox(
                            height: 16,
                          ),
                          _writeContent(),
                          SizedBox(
                            height: 27,
                          ),
                          _requestButton(state),
                        ],
                      ),
                    ),
                  ),
                  (isDropdownButtonPressed)
                      ? _showDropdownMenu(state)
                      : Container(),
                ],
              )
            : AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Container(
                  height: 203,
                  width: 366,
                  color: Colors.transparent,
                ),
              );
      },
    );
  }

  Widget _titleBar() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            '영농계획 추가',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickDate(FMPlanState state) {
    return InkResponse(
      onTap: () async {
        await _showDatePicker(1);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFF15B85B),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${state.startDate.year}년 ${state.startDate.month}월 ${state.startDate.day}일',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(0xFF15B85B),
                          ),
                    ),
                    Text(
                      '-',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF15B85B),
                          ),
                    ),
                    Text(
                      '${state.endDate.year}년 ${state.endDate.month}월 ${state.endDate.day}일',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(0xFF15B85B),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Icon(
              //   Icons.calendar_today,
              //   color: Color(0xFF15B85B),
              // ),
              _customDropdownButton(state),
              SizedBox(
                width: 17,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showDropdownMenu(FMPlanState state) {
    return Positioned(
      top: y + height,
      left: x,
      width: width,
      child: Material(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              state.fieldList.length,
              (index) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedFieldIndex = index;
                        isDropdownButtonPressed = !isDropdownButtonPressed;
                      });
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          '${state.fieldList[index].name}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.black,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }

  Widget _customDropdownButton(FMPlanState state) {
    return OutlinedButton(
      key: _key,
      onPressed: () {
        setState(() {
          isDropdownButtonPressed = !isDropdownButtonPressed;
        });
      },
      child: Text(
        '${state.fieldList[selectedFieldIndex].name}',
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }

  Future<DateTime> _showDatePicker(int category) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmPlanBloc,
            child: FMSmallCalendar(
              category: category,
            ),
          );
        });
  }

  Widget _writeTitle() {
    return Container(
      height: 32,
      width: 451,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.fromLTRB(8, 7, 0, 3),
      child: TextField(
        controller: _titleController,
        focusNode: _titleNode,
        onTap: () {
          _titleNode.requestFocus();
        },
        onChanged: (text) {
          setState(() {
            _title = text;
          });
        },
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintText: '일정 제목을 입력해주세요',
          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 18,
                color: Color(0xFFA8A8A8),
              ),
        ),
      ),
    );
  }

  Widget _writeContent() {
    return Container(
      height: 217,
      width: 451,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.fromLTRB(8, 9, 0, 0),
      child: TextField(
        controller: _contentController,
        focusNode: _contentNode,
        onTap: () {
          _contentNode.requestFocus();
        },
        onChanged: (text) {
          setState(() {
            _content = text;
          });
        },
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
        minLines: null,
        maxLines: 9,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintText: '세부사항을 입력해주세요',
          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 18,
                color: Color(0xFFA8A8A8),
              ),
        ),
      ),
    );
  }

  Widget _requestButton(FMPlanState state) {
    return InkResponse(
        onTap: () async {
          if (isEverythingFilledOut) {
            if (isDateOrderCorrect) {
              _fmPlanBloc.add(SetWaitingPlan(
                  wPlan: WaitingConfirmation(
                startDate: state.startDate,
                endDate: state.endDate,
                title: _title,
                content: _content,
                selectedFieldIndex: selectedFieldIndex,
              )));
              // Navigator.pop(context);
              _fmPlanBloc.add(CheckConfirmState(confirmState: true));
              await _showConfirmationDialog();
            }
          }
        },
        child: Container(
          height: 35,
          width: 451,
          decoration: BoxDecoration(
            color: (!isDateOrderCorrect)
                ? Color(0xFFEEEEEE)
                : (isEverythingFilledOut)
                    ? Color(0xFF15B85B)
                    : Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              (!isEverythingFilledOut)
                  ? '모두 입력했는지 확인해 주세요'
                  : (!isDateOrderCorrect)
                      ? '날짜 순서를 확인해주세요'
                      : '추가',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: (!isDateOrderCorrect)
                        ? Colors.red
                        : (!isEverythingFilledOut)
                            ? Colors.red
                            : (isEverythingFilledOut)
                                ? Colors.white
                                : Color(0xFF969696),
                  ),
            ),
          ),
        ));
  }

  Future<void> _showConfirmationDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmPlanBloc,
            child: Confirm(),
          );
        });
  }
}

class Confirm extends StatefulWidget {
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  FMPlanBloc _fmPlanBloc;

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
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 203,
            width: 366,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '새로운 일정 ',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(0xFF15B85B),
                              ),
                        ),
                        Text(
                          '등록을 요청하시겠습니까?',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: 23,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 31,
                          width: 97,
                          decoration: BoxDecoration(
                            color: Color(0xFFB5B5B5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _fmPlanBloc
                                  .add(CheckConfirmState(confirmState: false));
                              Navigator.pop(context);
                            },
                            child: Text(
                              '취소',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          height: 31,
                          width: 97,
                          decoration: BoxDecoration(
                            color: Color(0xFF15B85B),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _fmPlanBloc.add(PostNewPlan());
                              _fmPlanBloc.add(CheckConfirmState(confirmState: false));
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              '확인',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    onPressed: () {
                      _fmPlanBloc.add(CheckConfirmState(confirmState: false));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
