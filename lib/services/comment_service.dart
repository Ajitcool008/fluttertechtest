import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../core/error/failures.dart';
import '../core/usecases/usecase.dart';
import '../domain/entities/comment.dart';
import '../domain/usecases/get_post_comments.dart';

@lazySingleton
class CommentService {
  final GetPostComments _getPostComments;

  CommentService({
    required GetPostComments getPostComments,
  }) : _getPostComments = getPostComments;

  Future<Either<Failure, List<Comment>>> getPostComments(int postId) async {
    return await _getPostComments(Params(id: postId));
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