import 'package:BrandFarm/widgets/fm_shared_widgets/fm_small_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FMAddPlan extends StatefulWidget {
  @override
  _FMAddPlanState createState() => _FMAddPlanState();
}

class _FMAddPlanState extends State<FMAddPlan> {
  DateTime startDate;
  DateTime endDate;

  TextEditingController _titleController;
  TextEditingController _contentController;
  FocusNode _titleNode;
  FocusNode _contentNode;
  String _title;
  String _content;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _titleNode = FocusNode();
    _contentNode = FocusNode();
    _title = '';
    _content = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            _pickDate(),
            SizedBox(height: 19,),
            _writeTitle(),
            SizedBox(height: 16,),
            _writeContent(),
            SizedBox(height: 27,),
            _requestButton(),
          ],
        ),
      ),
    );
  }

  Widget _titleBar() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            '영농계획 추가요청',
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

  Widget _pickDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 10,),
            Container(
              width: 255,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime pickedDate = await _showDatePicker(1) ?? startDate;
                      setState(() {
                        startDate = pickedDate;
                      });
                    },
                    child: Text('${startDate.year}년 ${startDate.month}월 ${startDate.day}일',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(0xFF15B85B),
                      ),),
                  ),
                  Text('-',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF15B85B),
                    ),),
                  TextButton(
                    onPressed: () async{
                      DateTime pickedDate = await _showDatePicker(2) ?? endDate;
                      setState(() {
                        endDate = pickedDate;
                      });
                    },
                    child: Text('${endDate.year}년 ${endDate.month}월 ${endDate.day}일',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(0xFF15B85B),
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF15B85B),),
            SizedBox(width: 17,),
          ],
        ),
      ],
    );
  }

  Future<DateTime> _showDatePicker(int category) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FMSmallCalendar(category: category,);
        }
    );
  }

  Widget _writeTitle() {
    return Container(
      height: 32,
      width: 451,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: _titleController,
        focusNode: _titleNode,
        onTap: (){
          _titleNode.requestFocus();
        },
        onChanged: (text){
          setState(() {
            _title = text;
          });
        },
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
      child: TextField(
        controller: _contentController,
        focusNode: _contentNode,
        onTap: (){
          _contentNode.requestFocus();
        },
        onChanged: (text){
          setState(() {
            _content = text;
          });
        },
        keyboardType: TextInputType.text,
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

  Widget _requestButton() {
    return InkResponse(
      onTap: (){},
        child: Container(
          height: 35,
          width: 451,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text('요청',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
                color: Color(0xFF969696),
              ),),
          ),
        )
    );
  }
}
