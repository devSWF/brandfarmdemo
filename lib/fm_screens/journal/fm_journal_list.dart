import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:BrandFarm/utils/todays_date.dart';
import 'package:BrandFarm/utils/unicode/unicode_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FMJournalList extends StatefulWidget {
  bool shouldReload;

  FMJournalList({
    Key key,
    @required this.shouldReload,
  }) : super(key: key);

  @override
  _FMJournalListState createState() => _FMJournalListState();
}

class _FMJournalListState extends State<FMJournalList> {
  FMJournalBloc _fmJournalBloc;

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    if (widget.shouldReload) {
      _fmJournalBloc.add(GetJournalList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMJournalBloc, FMJournalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          itemCount: (state.order == '최신 순')
              ? state.journalList.length
              : state.reverseList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                    elevation: 3,
                    child: InkResponse(
                      onTap: () {
                        _fmJournalBloc
                            .add(ChangeScreen(navTo: 2, index: index));
                        _fmJournalBloc.add(SetJournal());
                      },
                      child: (state.order == '최신 순')
                          ? _cardBody(state, state.journalList[index])
                          : _cardBody(state, state.reverseList[index]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _cardBody(FMJournalState state, Journal obj) {
    List<ImagePicture> pic = state.imageList.where((element) {
      return obj.jid == element.jid;
    }).toList();
    return Container(
      height: 132,
      width: 706,
      child: Row(
        children: [
          (obj.isReadByFM)
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${DateFormat('MM').format(obj.date.toDate())}',
                  style: GoogleFonts.lato(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      color: Colors.black)),
              Text('${daysOfWeek(index: obj.date.toDate().weekday)}',
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0x80000000))),
            ],
          ),
          SizedBox(
            width: 44,
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Color(0x1A000000),
            indent: 11,
            endIndent: 11,
          ),
          SizedBox(
            width: 23,
          ),
          Container(
            width: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 11,
                    ),
                    Text(
                      '${getDate(1, obj.date.toDate())} 일지',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Text(
                  '${obj.content}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                  maxLines: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '댓글 ${obj.comments} ${dot} ${getDate(2, obj.date.toDate())}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                color: Color(0x80000000),
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
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
                  image: (pic.isNotEmpty)
                      ? CachedNetworkImageProvider(pic[0].url)
                      : AssetImage('assets/brandfarm.png'),
                  fit: (pic.isNotEmpty) ? BoxFit.cover : BoxFit.fitHeight,
                )),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getDate(int from, DateTime dt) {
    String date;
    if (from == 1) {
      // 예) 2021년 4월 5일
      date = '${dt.year}년 ${dt.month}월 ${dt.day}일';
    } else {
      date = DateFormat('yyyy-MM-dd').format(dt);
    }
    return date;
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
