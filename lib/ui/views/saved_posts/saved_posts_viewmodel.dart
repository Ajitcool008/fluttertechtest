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

  SavedPostsViewModel() {
    // Listen for changes in the post service
    _postService.addListener(_refreshSavedPosts);
  }

  @override
  void dispose() {
    _postService.removeListener(_refreshSavedPosts);
    super.dispose();
  }

  // When post service changes, refresh the saved posts
  void _refreshSavedPosts() {
    loadSavedPosts();
  }

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
        setBusy(false);
      },
    );
  }

  void navigateToPostDetails(int postId) {
    _navigationService.navigateTo(
      Routes.postDetailsView,
      arguments: PostDetailsViewArguments(postId: postId),
    );
  }
}
