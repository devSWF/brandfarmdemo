

import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:bloc/bloc.dart';

class FMHomeBloc extends Bloc<FMHomeEvent, FMHomeState> {
  FMHomeBloc() : super(FMHomeState.empty());

  @override
  Stream<FMHomeState> mapEventToState(FMHomeEvent event) async* {
    if (event is LoadFMHome) {
      yield* _mapLoadFMHomeToState();
    } else if (event is SetPageIndex) {
      yield* _mapSetPageIndexToState(event.index);
    } else if (event is SetSubPageIndex) {
      yield* _mapSetSubPageIndexToState(event.index);
    } else if (event is SetSelectedIndex) {
      yield* _mapSetSelectedIndexToState(event.index);
    }
  }

  Stream<FMHomeState> _mapLoadFMHomeToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMHomeState> _mapSetPageIndexToState(int index) async* {
    yield state.update(pageIndex: index);
  }

  Stream<FMHomeState> _mapSetSubPageIndexToState(int index) async* {
    yield state.update(subPageIndex: index);
  }

  Stream<FMHomeState> _mapSetSelectedIndexToState(int index) async* {
    yield state.update(selectedIndex: index);
  }
}
