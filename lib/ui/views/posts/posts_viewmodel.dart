import 'package:flutter_tech_task/app/app.router.dart';
import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../domain/entities/post.dart';
import '../../../services/post_service.dart';

class PostsViewModel extends BaseViewModel {
  final _postService = locator<PostService>();
  final _navigationService = locator<NavigationService>();

  List<Post> _posts = [];
  String _errorMessage = '';

  List<Post> get posts => _posts;
  String get errorMessage => _errorMessage;

  Future<void> loadPosts() async {
    setBusy(true);
    final result = await _postService.getAllPosts();

    result.fold(
      (failure) {
        _errorMessage = _postService.mapFailureToMessage(failure);
        setBusy(false);
        setError(_errorMessage);
      },
      (posts) {
        _posts = posts;
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
