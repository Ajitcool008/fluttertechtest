import 'package:flutter_tech_task/app/app.router.dart';
import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../domain/entities/post.dart';
import '../../../services/post_service.dart';

class SavedPostsViewModel extends BaseViewModel {
  final _postService = locator<PostService>();
  final _navigationService = locator<NavigationService>();

  List<Post> _savedPosts = [];
  String _errorMessage = '';

  List<Post> get savedPosts => _savedPosts;
  String get errorMessage => _errorMessage;

  Future<void> loadSavedPosts() async {
    setBusy(true);
    final result = await _postService.getSavedPosts();

    result.fold(
      (failure) {
        _errorMessage = _postService.mapFailureToMessage(failure);
        setBusy(false);
        setError(_errorMessage);
      },
      (posts) {
        _savedPosts = posts;
        updateSavedPostsCount();
        setBusy(false);
      },
    );
  }

  Future<void> updateSavedPostsCount() async {
    await _postService.getSavedPostsCount();
  }

  void navigateToPostDetails(int postId) {
    _navigationService.navigateTo(
      Routes.postDetailsView,
      arguments: PostDetailsViewArguments(postId: postId),
    );
  }
}
