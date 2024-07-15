
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navbar_event.dart';
import 'navbar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(PageLoadedState(0)) {
    on<ChangePageEvent>((event, emit) {
      emit(PageLoadedState(event.pageIndex));
    });
  }
}
