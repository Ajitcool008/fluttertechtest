import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../core/error/failures.dart';
import '../core/usecases/usecase.dart';
import '../domain/entities/post.dart';
import '../domain/usecases/get_all_posts.dart';
import '../domain/usecases/get_post_details.dart';
import '../domain/usecases/get_saved_posts.dart';
import '../domain/usecases/get_saved_posts_count.dart';
import '../domain/usecases/save_post.dart';
import '../domain/usecases/unsave_post.dart';

@lazySingleton
class PostService {
  final GetAllPosts _getAllPosts;
  final GetPostDetails _getPostDetails;
  final GetSavedPosts _getSavedPosts;
  final GetSavedPostsCount _getSavedPostsCount;
  final SavePost _savePost;
  final UnsavePost _unsavePost;

  PostService({
    required GetAllPosts getAllPosts,
    required GetPostDetails getPostDetails,
    required GetSavedPosts getSavedPosts,
    required GetSavedPostsCount getSavedPostsCount,
    required SavePost savePost,
    required UnsavePost unsavePost,
  })  : _getAllPosts = getAllPosts,
        _getPostDetails = getPostDetails,
        _getSavedPosts = getSavedPosts,
        _getSavedPostsCount = getSavedPostsCount,
        _savePost = savePost,
        _unsavePost = unsavePost;

  Future<Either<Failure, List<Post>>> getAllPosts() async {
    return await _getAllPosts(NoParams());
  }

  Future<Either<Failure, Post>> getPostDetails(int id) async {
    return await _getPostDetails(Params(id: id));
  }

  Future<Either<Failure, List<Post>>> getSavedPosts() async {
    return await _getSavedPosts(NoParams());
  }

  Future<Either<Failure, int>> getSavedPostsCount() async {
    return await _getSavedPostsCount(NoParams());
  }

  Future<Either<Failure, Post>> savePost(Post post) async {
    return await _savePost(post);
  }

  Future<Either<Failure, Post>> unsavePost(Post post) async {
    return await _unsavePost(post);
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