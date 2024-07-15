
abstract class NavBarEvent {}

class ChangePageEvent extends NavBarEvent {
  final int pageIndex;

  ChangePageEvent(this.pageIndex);
}