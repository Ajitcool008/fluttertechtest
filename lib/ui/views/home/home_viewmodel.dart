import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';

import '../../../services/post_service.dart';
import '../saved_posts/saved_posts_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  final _postService = locator<PostService>();
  final _savedPostsViewModel = locator<SavedPostsViewModel>();

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  int get savedPostsCount => _postService.savedPostsCount;

  HomeViewModel() {
    _postService.addListener(_refreshUI);
  }

  void _refreshUI() {
    notifyListeners();
  }

  @override
  void dispose() {
    _postService.removeListener(_refreshUI);
    super.dispose();
  }

  void initialize() {
    // Make sure we have the latest count
    _postService.updateSavedPostsCount();
  }

  void setIndex(int index) {
    _currentIndex = index;
    if (index == 1) {
      // Force refresh saved posts when switching to saved posts tab
      _savedPostsViewModel.loadSavedPosts();
    }
    notifyListeners();
  }
}
