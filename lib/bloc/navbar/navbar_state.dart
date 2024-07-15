
abstract class NavBarState {}

class PageLoadedState extends NavBarState {
  final int pageIndex;

  PageLoadedState(this.pageIndex);
}