import 'package:BrandFarm/blocs/fm_contact/bloc.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_bloc.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_state.dart';
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
                          SizedBox(height: 40,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(state.contactList.length, (index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 93,
                                    width: 258,
                                    padding: EdgeInsets.fromLTRB(6, 7, 6, 7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1, color: Color(0xB3000000)),
                                    ),
                                    child: Row(
                                      children: [
                                        _profileAvatar(state, index),
                                        SizedBox(width: 13,),
                                        _detailInfo(state, index),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : LinearProgressIndicator();
      },
    );
  }

  Widget _profileAvatar(FMContactState state, int index) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: (state.contactList[index].imgUrl.isNotEmpty)
              ? CachedNetworkImageProvider(state.contactList[index].imgUrl,)
              : AssetImage('assets/profile.png'),
          fit: BoxFit.fill,
        )
      ),
    );
  }

  Widget _detailInfo(FMContactState state, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${state.contactList[index].position}',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color(0xB3000000),
          ),),
        Text('${state.contactList[index].name}',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xB3000000),
          ),),
        Text('${state.contactList[index].phoneNum}',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Color(0xB3000000),
          )),
      ],
    );
  }
}
