
import 'package:BrandFarm/blocs/om_home/bloc.dart';
import 'package:bloc/bloc.dart';

class OMHomeBloc extends Bloc<OMHomeEvent,OMHomeState>{
  OMHomeBloc(): super(OMHomeState.empty());

  @override
  Stream<OMHomeState> mapEventToState(OMHomeEvent event) async*{
    if(event is LoadOMHome){
      yield* _mapLoadOMHomeToState();
    } else if (event is SetPageIndex) {
      yield* _mapSetPageIndexToState(event.index);
    } else if (event is SetSubPageIndex) {
      yield* _mapSetSubPageIndexToState(event.index);
    }
  }

  Stream<OMHomeState> _mapLoadOMHomeToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<OMHomeState> _mapSetPageIndexToState(int index) async* {
    yield state.update(pageIndex: index);
  }

  Stream<OMHomeState> _mapSetSubPageIndexToState(int index) async* {
    yield state.update(subPageIndex: index);
  }
}