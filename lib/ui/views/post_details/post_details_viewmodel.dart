import 'package:flutter_tech_task/app/app.router.dart';
import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../domain/entities/post.dart';
import '../../../services/post_service.dart';

class PostDetailsViewModel extends BaseViewModel {
  final _postService = locator<PostService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  Post? _post;
  String _errorMessage = '';

  Post? get post => _post;
  String get errorMessage => _errorMessage;

  Future<void> loadPostDetails(int postId) async {
    setBusy(true);
    final result = await _postService.getPostDetails(postId);

    result.fold(
      (failure) {
        _errorMessage = _postService.mapFailureToMessage(failure);
        setBusy(false);
        setError(_errorMessage);
      },
      (post) {
        _post = post;
        setBusy(false);
      },
    );
  }

  Future<void> toggleSavePost() async {
    if (_post == null) return;

    setBusy(true);

    final result =
        _post!.isSaved
            ? await _postService.unsavePost(_post!)
            : await _postService.savePost(_post!);

    result.fold(
      (failure) {
        _errorMessage = _postService.mapFailureToMessage(failure);
        _snackbarService.showSnackbar(
          message: _errorMessage,
          duration: const Duration(seconds: 2),
        );
        setBusy(false);
      },
      (updatedPost) {
        _post = updatedPost;
        _snackbarService.showSnackbar(
          message:
              updatedPost.isSaved
                  ? 'Post saved successfully'
                  : 'Post removed from saved',
          duration: const Duration(seconds: 2),
        );
        setBusy(false);
      },
    );
  }

  void navigateToComments() {
    if (_post == null) return;

    _navigationService.navigateTo(
      Routes.commentsView,
      arguments: CommentsViewArguments(postId: _post!.id),
    );
  }
}
