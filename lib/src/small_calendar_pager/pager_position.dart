import 'package:meta/meta.dart';

typedef void JumpToPageCallback(int index);

typedef int GetPageCallback();

@immutable
class PagerPosition {
  PagerPosition({
    @required this.jumpToPage,
    @required this.getPage,
  });

  final JumpToPageCallback jumpToPage;

  final GetPageCallback getPage;
}
