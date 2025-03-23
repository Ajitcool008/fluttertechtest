import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../core/error/failures.dart';
import '../core/usecases/usecase.dart';
import '../domain/entities/comment.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/usecases/get_post_comments.dart';

class CommentService extends ChangeNotifier {
  final GetPostComments _getPostComments;
  final PostRepository _repository; // Added repository reference

  CommentService({
    required GetPostComments getPostComments,
    required PostRepository repository, // Added parameter
  }) : _getPostComments = getPostComments,
       _repository = repository;

  Future<Either<Failure, List<Comment>>> getPostComments(int postId) async {
    // Get comments through use case (will handle caching)
    return await _getPostComments(Params(id: postId));
  }

  // New method to check if we have offline comments
  Future<bool> hasOfflineComments(int postId) async {
    final result = await _repository.hasLocalComments(postId);
    return result.fold((failure) => false, (hasComments) => hasComments);
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server failure';
      case const (CacheFailure):
        return 'Cache failure';
      case const (NetworkFailure):
        return 'Network failure - Please check your internet connection';
      default:
        return 'Unexpected error';
    }
  }
}
