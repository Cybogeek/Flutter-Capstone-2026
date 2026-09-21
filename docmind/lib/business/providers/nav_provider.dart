import 'package:flutter_riverpod/flutter_riverpod.dart';

final navProvider = NotifierProvider<NavNotifier, int>(NavNotifier.new);

class NavNotifier extends Notifier<int> {
  void setNavIndex(int index) {
    state = index;
  }

  @override
  int build() {
    return 0;
  }
}
