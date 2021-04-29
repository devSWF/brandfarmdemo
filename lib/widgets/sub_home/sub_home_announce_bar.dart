import 'package:BrandFarm/blocs/notification/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SubHomeAnnounceBar extends StatefulWidget {
  const SubHomeAnnounceBar({
    Key key,
  }) : super(key: key);

  @override
  _SubHomeAnnounceBarState createState() => _SubHomeAnnounceBarState();
}

class _SubHomeAnnounceBarState extends State<SubHomeAnnounceBar> {
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.allList.isNotEmpty)
            ? Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.5),
                    color: Color(0xfff5f5f5)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      (state.allList[0].type.contains('중요'))
                          ? Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xfffdd015),
                            )
                          : Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1, color: Color(0xff8b8b8b)),
                              ),
                              child: FittedBox(
                                child: Image.asset(
                                  'assets/megaphone.png',
                                ),
                              )),
                      SizedBox(
                        width: 7.0,
                      ),
                      Expanded(
                        child: Text(
                          '${getDate(state.allList[0].postedDate)} - ${state.allList[0].content}',
                          style: Theme.of(context)
                              .textTheme
                              .overline
                              .copyWith(color: Color(0xff8b8b8b)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  String getDate(Timestamp date) {
    DateTime dt = date.toDate();
    String d = DateFormat('M/d').format(dt);
    return '${d}';
  }
}
