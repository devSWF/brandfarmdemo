import 'package:BrandFarm/blocs/fm_issue/fm_issue_bloc.dart';
import 'package:BrandFarm/blocs/fm_issue/fm_issue_event.dart';
import 'package:BrandFarm/blocs/fm_issue/fm_issue_state.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMJournalDatePicker extends StatefulWidget {
  bool isIssue;

  FMJournalDatePicker({Key key, this.isIssue}) : super(key: key);

  @override
  _FMJournalDatePickerState createState() => _FMJournalDatePickerState();
}

class _FMJournalDatePickerState extends State<FMJournalDatePicker> {
  FMJournalBloc _fmJournalBloc;
  FMIssueBloc _fmIssueBloc;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    _fmIssueBloc = BlocProvider.of<FMIssueBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMJournalBloc, FMJournalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (widget.isIssue)
            ? MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _fmIssueBloc,
                  ),
                  BlocProvider.value(
                    value: _fmJournalBloc,
                  ),
                ],
                child: IssueDatePicker(field: state.field),
              )
            : BlocProvider.value(
                value: _fmJournalBloc,
                child: JournalDatePicker(),
              );
      },
    );
  }
}

class Util {
  List<String> generateYear() {
    List<String> yList = List.generate(10, (index) {
      int initial = 2020;
      int num = initial + index;
      return num.toString();
    });
    return yList;
  }

  List<String> generateMonth() {
    List<String> mList = List.generate(12, (index) {
      int initial = 1;
      int num = initial + index;
      return num.toString();
    });
    return mList;
  }
}

class JournalDatePicker extends StatefulWidget {
  @override
  _JournalDatePickerState createState() => _JournalDatePickerState();
}

class _JournalDatePickerState extends State<JournalDatePicker> {
  FMJournalBloc _fmJournalBloc;
  List<String> yearList;
  List<String> monthList;

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    yearList = Util().generateYear();
    monthList = Util().generateMonth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMJournalBloc, FMJournalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            _selectYear(state),
            SizedBox(
              width: 24,
            ),
            _selectMonth(state),
            SizedBox(
              width: 24,
            ),
            IconButton(
              onPressed: () {
                _fmJournalBloc.add(ReloadFMJournal());
                _fmJournalBloc.add(GetJournalList());
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _selectYear(FMJournalState state) {
    return DropdownBelow(
      value: state.year,
      items: yearList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // style: Theme.of(context).textTheme.bodyText2.copyWith(
      //       fontSize: 18,
      //       color: Color(0x66000000),
      //     ),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      itemWidth: 90,
      boxPadding: EdgeInsets.symmetric(horizontal: 6),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      boxWidth: 90,
      boxHeight: 45,
      // icon: Icon(
      //   Icons.keyboard_arrow_down_sharp,
      //   color: Color(0x66000000),
      // ),
      onChanged: (String value) {
        setState(() {
          _fmJournalBloc.add(SetJourYear(year: value));
        });
      },
      // underline: Container(),
    );
  }

  Widget _selectMonth(FMJournalState state) {
    return DropdownBelow(
      value: state.month,
      items: monthList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // style: Theme.of(context).textTheme.bodyText2.copyWith(
      //       fontSize: 18,
      //       color: Color(0x66000000),
      //     ),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      itemWidth: 90,
      boxPadding: EdgeInsets.symmetric(horizontal: 6),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      boxWidth: 90,
      boxHeight: 45,
      // icon: Icon(
      //   Icons.keyboard_arrow_down_sharp,
      //   color: Color(0x66000000),
      // ),
      onChanged: (String value) {
        setState(() {
          _fmJournalBloc.add(SetJourMonth(month: value));
        });
      },
      // underline: Container(),
    );
  }
}

class IssueDatePicker extends StatefulWidget {
  Field field;

  IssueDatePicker({Key key, this.field}) : super(key: key);

  @override
  _IssueDatePickerState createState() => _IssueDatePickerState();
}

class _IssueDatePickerState extends State<IssueDatePicker> {
  FMJournalBloc _fmJournalBloc;
  FMIssueBloc _fmIssueBloc;
  List<String> yearList;
  List<String> monthList;

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    _fmIssueBloc = BlocProvider.of<FMIssueBloc>(context);
    yearList = Util().generateYear();
    monthList = Util().generateMonth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMIssueBloc, FMIssueState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            _selectYear(state),
            SizedBox(
              width: 24,
            ),
            _selectMonth(state),
            SizedBox(
              width: 24,
            ),
            IconButton(
              onPressed: () {
                _fmJournalBloc.add(ReloadFMJournal());
                _fmIssueBloc.add(GetIssueList(field: widget.field));
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _selectYear(FMIssueState state) {
    return DropdownBelow(
      value: state.year,
      items: yearList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // style: Theme.of(context).textTheme.bodyText2.copyWith(
      //       fontSize: 18,
      //       color: Color(0x66000000),
      //     ),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      itemWidth: 90,
      boxPadding: EdgeInsets.symmetric(horizontal: 6),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      boxWidth: 90,
      boxHeight: 45,
      // icon: Icon(
      //   Icons.keyboard_arrow_down_sharp,
      //   color: Color(0x66000000),
      // ),
      onChanged: (String value) {
        setState(() {
          _fmIssueBloc.add(SetIssYear(year: value));
        });
      },
      // underline: Container(),
    );
  }

  Widget _selectMonth(FMIssueState state) {
    return DropdownBelow(
      value: state.month,
      items: monthList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // style: Theme.of(context).textTheme.bodyText2.copyWith(
      //       fontSize: 18,
      //       color: Color(0x66000000),
      //     ),
      itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      itemWidth: 90,
      boxPadding: EdgeInsets.symmetric(horizontal: 6),
      boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18,
            color: Color(0x66000000),
          ),
      boxWidth: 90,
      boxHeight: 45,
      // icon: Icon(
      //   Icons.keyboard_arrow_down_sharp,
      //   color: Color(0x66000000),
      // ),
      onChanged: (String value) {
        setState(() {
          _fmIssueBloc.add(SetIssMonth(month: value));
        });
      },
      // underline: Container(),
    );
  }
}
