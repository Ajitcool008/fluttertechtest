import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';

import '../../../domain/entities/comment.dart';
import '../../../services/comment_service.dart';

class CommentsViewModel extends BaseViewModel {
  final _commentService = locator<CommentService>();

  List<Comment> _comments = [];
  String _errorMessage = '';
  bool _isOfflineData = false;

  List<Comment> get comments => _comments;
  String get errorMessage => _errorMessage;
  bool get isOfflineData => _isOfflineData;

  Future<void> loadComments(int postId) async {
    setBusy(true);
    clearErrors();
    _isOfflineData = false;

    // Check if we have offline comments before loading
    final hasOffline = await _commentService.hasOfflineComments(postId);

    final result = await _commentService.getPostComments(postId);

    result.fold(
      (failure) {
        _errorMessage = _commentService.mapFailureToMessage(failure);

        // If it's a network failure and we have offline data, show it
        if (failure is NetworkFailure && hasOffline) {
          _isOfflineData = true;
          // Try to get offline comments
          _commentService.getPostComments(postId).then((offlineResult) {
            offlineResult.fold(
              (_) {
                // If still can't get comments, show error
                setBusy(false);
                setError(_errorMessage);
              },
              (offlineComments) {
                _comments = offlineComments;
                setBusy(false);
                notifyListeners();
              },
            );
          });
        } else {
          setBusy(false);
          setError(_errorMessage);
        }
      },
      (comments) {
        _comments = comments;
        setBusy(false);
      },
    );
  }
}
