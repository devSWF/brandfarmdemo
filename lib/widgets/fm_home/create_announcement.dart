import 'package:BrandFarm/blocs/fm_notification/fm_notification_bloc.dart';
import 'package:BrandFarm/fm_screens/notification/write_notice_screen.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({
    Key key,
    VoidCallback onPressed,
  })  : _onPressed = onPressed,
        super(key: key);
  final VoidCallback _onPressed;

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(29, 8, 36, 8),
            height: 55,
            width: 814,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                      radius: 19.0,
                      backgroundImage: (UserUtil.getUser().imgUrl.isEmpty ||
                              UserUtil.getUser().imgUrl == '--')
                          ? AssetImage('assets/profile.png')
                          : NetworkImage(UserUtil.getUser().imgUrl)),
                ),
                SizedBox(
                  width: 13,
                ),
                InkResponse(
                  onTap: widget._onPressed,
                  child: Container(
                    height: 29,
                    width: 698,
                    padding: EdgeInsets.only(left: 18),
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(width: 1, color: Colors.transparent),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '어떤 공지사항을 게시할까요?',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 15,
                              color: Color(0xFF848484),
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}
