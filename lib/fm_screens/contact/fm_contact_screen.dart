import 'package:BrandFarm/blocs/fm_contact/bloc.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_bloc.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_state.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FMContactScreen extends StatefulWidget {
  @override
  _FMContactScreenState createState() => _FMContactScreenState();
}

class _FMContactScreenState extends State<FMContactScreen> {
  FMContactBloc _fmContactBloc;

  @override
  void initState() {
    super.initState();
    _fmContactBloc = BlocProvider.of<FMContactBloc>(context);
    _fmContactBloc.add(GetContactList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMContactBloc, FMContactState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.contactList.isNotEmpty)
            ? Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 11, 20, 11),
                    child: Container(
                      height: 1500,
                      width: 814,
                      padding: EdgeInsets.fromLTRB(56, 50, 56, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '연락처',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _titleBar('내 연락처', 1),
                              Divider(
                                height: 30,
                                thickness: 1,
                                color: Color(0x33000000),
                              ),
                              _profileCard(state, 1000),
                            ],
                          ),
                          SizedBox(
                            height: 42,
                          ),
                          _titleBar('관계자 연락처', 2),
                          Divider(
                            height: 30,
                            thickness: 1,
                            color: Color(0x33000000),
                          ),
                          Container(
                            width: 539,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(state.contactList.length,
                                  (index) {
                                return _profileCard(state, index);
                              }),

                              // List.generate(state.col, (col) {
                              //   return Row(
                              //     children: List.generate(state.row, (row) {
                              //       return Row(
                              //         children: [
                              //           Column(
                              //             children: [
                              //               _profileCard(state, col, row),
                              //               SizedBox(
                              //                 height: 20,
                              //               ),
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             width: 41,
                              //           ),
                              //         ],
                              //       );
                              //     }),
                              //   );
                              // }),
                            ),
                          )
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

  Widget _titleBar(String title, int from) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${title}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black,
                ),
          ),
          (from == 1)
              ? Icon(
                  Icons.settings,
                  color: Colors.black,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _profileCard(FMContactState state, int index) {
    return Container(
      height: 82,
      width: 249,
      padding: EdgeInsets.fromLTRB(18, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Color(0xB3000000)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profileAvatar(state, index),
          SizedBox(
            width: 14,
          ),
          _detailInfo(state, index),
        ],
      ),
    );
  }

  Widget _profileAvatar(FMContactState state, int index) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Color(0xFF15B85B),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
              color: Colors.lightGreen,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (index == 1000 && UserUtil.getUser().imgUrl.isNotEmpty)
                    ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
                    : (index == 1000 && UserUtil.getUser().imgUrl.isEmpty)
                        ? AssetImage('assets/profile.png')
                        : (state.contactList[index].imgUrl.isNotEmpty)
                            ? CachedNetworkImageProvider(
                                state.contactList[index].imgUrl,
                              )
                            : AssetImage('assets/profile.png'),
                fit: BoxFit.fitWidth,
              )),
        ),
      ),
    );
  }

  Widget _detailInfo(FMContactState state, int index) {
    String name = (index == 1000)
        ? UserUtil.getUser().name
        : state.contactList[index].name;
    String position =
        (index == 1000) ? '필드매니저' : state.contactList[index].position;
    String phoneNum = (index == 1000)
        ? UserUtil.getUser().phone
        : state.contactList[index].phoneNum;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${name}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xB3000000),
                  ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '${position}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color(0x80000000),
                  ),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        Text('${phoneNum}',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.black,
            )),
        // SizedBox(height: 5,),
      ],
    );
  }
}
