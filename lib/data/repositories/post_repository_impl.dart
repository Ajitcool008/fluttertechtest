import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
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
  Future<Either<Failure, List<Comment>>> getPostComments(int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComments = await remoteDataSource.getPostComments(postId);
        return Right(remoteComments);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
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
      final savedPost = await localDataSource.savePost(PostModel.fromEntity(post));
      return Right(savedPost);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> unsavePost(Post post) async {
    try {
      final unsavedPost = await localDataSource.unsavePost(PostModel.fromEntity(post));
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
}