import 'package:BrandFarm/blocs/fm_issue/bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BrandFarm/utils/unicode/unicode_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMIssueList extends StatefulWidget {
  final Field field;
  final bool shouldReload;

  FMIssueList({
    Key key,
    this.field,
    this.shouldReload,
  }) : super(key: key);

  @override
  _FMIssueListState createState() => _FMIssueListState();
}

class _FMIssueListState extends State<FMIssueList> {
  FMJournalBloc _fmJournalBloc;
  FMIssueBloc _fmIssueBloc;

  @override
  void initState() {
    super.initState();
    _fmIssueBloc = BlocProvider.of<FMIssueBloc>(context);
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    if (widget.shouldReload) {
      _fmIssueBloc.add(GetIssueList(field: widget.field));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMJournalBloc, FMJournalState>(
      listener: (context, jstate) {},
      builder: (context, jstate) {
        return BlocConsumer<FMIssueBloc, FMIssueState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state.imageList.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: (jstate.order == '최신 순')
                        ? state.issueList.length
                        : state.reverseList.length,
                    itemBuilder: (context, index) {
                      return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Card(
                                    elevation: 3,
                                    child: InkResponse(
                                      onTap: () {
                                        _fmJournalBloc.add(ChangeScreen(
                                            navTo: 3, index: index));
                                      },
                                      child: (jstate.order == '최신 순')
                                          ? CardBody(
                                              obj: state.issueList[index],
                                              state: state)
                                          : CardBody(
                                              obj: state.reverseList[index],
                                              state: state),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                              ],
                            );
                    },
                  )
                : Container();
          },
        );
      },
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class CardBody extends StatefulWidget {
  SubJournalIssue obj;
  FMIssueState state;

  CardBody({Key key, this.obj, this.state}) : super(key: key);

  @override
  _CardBodyState createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> {
  List<ImagePicture> url;

  @override
  void initState() {
    super.initState();
    url = widget.state.imageList
        .where((element) => element.issid == widget.obj.issid)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: 706,
      child: Row(
        children: [
          (widget.obj.isReadByFM)
              ? Container(
                  width: 34,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: Color(0xFFF7685B),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            width: 3.28,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Container(
              width: 515,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 22,
                        child: FittedBox(
                          child: DepartmentBadge(
                            department:
                                getIssueState(state: widget.obj.issueState),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${widget.obj.title}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.obj.contents}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w200,
                          color: Color(0xB3000000),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '댓글 ${widget.obj.comments} ${dot} ${widget.obj.date.toDate().year}-${widget.obj.date.toDate().month}-${widget.obj.date.toDate().day}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                              color: Color(0x80000000),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 28,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 106,
                width: 106,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: (url.isNotEmpty)
                      ? NetworkImage(url[0].url)
                      : AssetImage('assets/brandfarm.png'),
                  // image: AssetImage('assets/strawberry.png'),
                  fit: (url.isNotEmpty) ? BoxFit.cover : BoxFit.fitHeight,
                )),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // String _getImageUrl({List<ImagePicture> pic, SubJournalIssue obj}) {
  //   List<ImagePicture> img =
  //       pic.where((element) => element.issid == obj.issid).toList();
  //   return img[0].url;
  // }

  String getIssueState({int state}) {
    switch (state) {
      case 1:
        {
          return 'todo';
        }
        break;
      case 2:
        {
          return 'doing';
        }
        break;
      case 3:
        {
          return 'done';
        }
        break;
    }
  }
}
