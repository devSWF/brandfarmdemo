import 'package:BrandFarm/blocs/om_home/om_home_bloc.dart';
import 'package:BrandFarm/blocs/om_home/om_home_event.dart';
import 'package:BrandFarm/blocs/om_home/om_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectFarm extends StatefulWidget {
  const SelectFarm({Key key}) : super(key: key);

  @override
  _SelectFarmState createState() => _SelectFarmState();
}

class _SelectFarmState extends State<SelectFarm> {
  OMHomeBloc _omHomeBloc;

  @override
  void initState() {
    super.initState();
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    _omHomeBloc.add(ChangeCurrFarmIndex(index: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OMHomeBloc, OMHomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 66,
              width: 814,
              padding: EdgeInsets.fromLTRB(29, 17, 0, 17),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: List.generate(state.farmList.length ?? 1, (index) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _omHomeBloc.add(ChangeCurrFarmIndex(index: index));
                        },
                        child: Container(
                          width: 170,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width:
                                      (state.currentFarmIndex == index) ? 3 : 1,
                                  color: (state.currentFarmIndex == index)
                                      ? Color(0xFF15B85B)
                                      : Color(0x40000000))),
                          child: Center(
                            child: Text(
                              '${state.farmList[index].name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: (state.currentFarmIndex == index)
                                        ? Color(0xFF15B85B)
                                        : Color(0x40000000),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
