import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';

import '../../../services/post_service.dart';

class HomeViewModel extends ReactiveViewModel {
  final _postService = locator<PostService>();

  int _currentIndex = 0;
  int _savedPostsCount = 0;

  int get currentIndex => _currentIndex;
  int get savedPostsCount => _savedPostsCount;

  void initialize() {
    getSavedPostsCount();
  }

  void setIndex(int index) {
    _currentIndex = index;
    if (index == 1) {
      // Refresh saved posts count when switching to saved posts tab
      getSavedPostsCount();
    }
    notifyListeners();
  }

  Future<void> getSavedPostsCount() async {
    final result = await _postService.getSavedPostsCount();
    result.fold(
      (failure) => null, // Handle error if needed
      (count) {
        _savedPostsCount = count;
        notifyListeners();
      },
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
