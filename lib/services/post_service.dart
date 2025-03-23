import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../core/error/failures.dart';
import '../core/usecases/usecase.dart';
import '../domain/entities/post.dart';
import '../domain/usecases/get_all_posts.dart';
import '../domain/usecases/get_post_details.dart';
import '../domain/usecases/get_saved_posts.dart';
import '../domain/usecases/get_saved_posts_count.dart';
import '../domain/usecases/save_post.dart';
import '../domain/usecases/unsave_post.dart';

class PostService extends ChangeNotifier {
  final GetAllPosts _getAllPosts;
  final GetPostDetails _getPostDetails;
  final GetSavedPosts _getSavedPosts;
  final GetSavedPostsCount _getSavedPostsCount;
  final SavePost _savePost;
  final UnsavePost _unsavePost;

  int _savedPostsCount = 0;
  int get savedPostsCount => _savedPostsCount;

  PostService({
    required GetAllPosts getAllPosts,
    required GetPostDetails getPostDetails,
    required GetSavedPosts getSavedPosts,
    required GetSavedPostsCount getSavedPostsCount,
    required SavePost savePost,
    required UnsavePost unsavePost,
  }) : _getAllPosts = getAllPosts,
       _getPostDetails = getPostDetails,
       _getSavedPosts = getSavedPosts,
       _getSavedPostsCount = getSavedPostsCount,
       _savePost = savePost,
       _unsavePost = unsavePost {
    // Initialize saved posts count
    updateSavedPostsCount();
  }

  Future<Either<Failure, List<Post>>> getAllPosts() async {
    return await _getAllPosts(NoParams());
  }

  Future<Either<Failure, Post>> getPostDetails(int id) async {
    return await _getPostDetails(Params(id: id));
  }

  Future<Either<Failure, List<Post>>> getSavedPosts() async {
    return await _getSavedPosts(NoParams());
  }

  // Add a method to force a saved posts refresh
  void notifySavedPostsChanged() {
    // Just trigger the listeners to refresh any UIs that depend on saved posts
    notifyListeners();
  }

  // savePost method
  Future<Either<Failure, Post>> savePost(Post post) async {
    final result = await _savePost(post);
    // Update saved posts count after saving
    if (result.isRight()) {
      await updateSavedPostsCount();
      // Notify of changes
      notifySavedPostsChanged();
    }
    return result;
  }

  // unsavePost method
  Future<Either<Failure, Post>> unsavePost(Post post) async {
    final result = await _unsavePost(post);
    // Update saved posts count after unsaving
    if (result.isRight()) {
      await updateSavedPostsCount();
      // Notify of changes
      notifySavedPostsChanged();
    }
    return result;
  }

  // update the count
  Future<void> updateSavedPostsCount() async {
    final result = await _getSavedPostsCount(NoParams());
    result.fold(
      (failure) => null, // Handle error if needed
      (count) {
        if (_savedPostsCount != count) {
          _savedPostsCount = count;
          notifyListeners();
        }
      },
    );
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
