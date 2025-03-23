import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();

        List<Post> posts = [];
        for (var post in remotePosts) {
          final isSaved = await localDataSource.isPostSaved(post.id);
          posts.add(post.copyWith(isSaved: isSaved));
        }

        return Right(posts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> getPostDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.getPostDetails(id);
        final isSaved = await localDataSource.isPostSaved(remotePost.id);
        return Right(remotePost.copyWith(isSaved: isSaved));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final savedPosts = await localDataSource.getSavedPosts();
        final post = savedPosts.firstWhere((post) => post.id == id);
        return Right(post);
      } on Exception {
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getSavedPosts() async {
    try {
      final localPosts = await localDataSource.getSavedPosts();
      return Right(localPosts);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> savePost(Post post) async {
    try {
      final savedPost = await localDataSource.savePost(
        PostModel.fromEntity(post),
      );
      return Right(savedPost);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> unsavePost(Post post) async {
    try {
      final unsavedPost = await localDataSource.unsavePost(
        PostModel.fromEntity(post),
      );
      return Right(unsavedPost);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isPostSaved(int postId) async {
    try {
      final isSaved = await localDataSource.isPostSaved(postId);
      return Right(isSaved);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getSavedPostsCount() async {
    try {
      final count = await localDataSource.getSavedPostsCount();
      return Right(count);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComments = await remoteDataSource.getPostComments(postId);

        // Cache comments for offline use
        try {
          await localDataSource.savePostComments(postId, remoteComments);
        } catch (_) {
          // Ignore caching errors
        }

        return Right(remoteComments);
      } on ServerException {
        // Try to get cached comments if server fails
        try {
          final localComments = await localDataSource.getSavedPostComments(
            postId,
          );
          if (localComments.isNotEmpty) {
            return Right(localComments);
          }
        } catch (_) {
          // Ignore cache errors and return server failure
        }
        return Left(ServerFailure());
      }
    } else {
      // When offline, try to get cached comments
      try {
        final localComments = await localDataSource.getSavedPostComments(
          postId,
        );
        if (localComments.isNotEmpty) {
          return Right(localComments);
        } else {
          return Left(NetworkFailure());
        }
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> cachePostComments(
    int postId,
    List<Comment> comments,
  ) async {
    try {
      final commentModels =
          comments.map((comment) {
            if (comment is CommentModel) {
              return comment;
            }
            // Convert Comment to CommentModel if needed
            return CommentModel(
              id: comment.id,
              postId: comment.postId,
              name: comment.name,
              email: comment.email,
              body: comment.body,
            );
          }).toList();

      await localDataSource.savePostComments(postId, commentModels);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasLocalComments(int postId) async {
    try {
      final hasComments = await localDataSource.hasCommentsForPost(postId);
      return Right(hasComments);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
