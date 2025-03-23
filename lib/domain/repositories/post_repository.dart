import 'package:dartz/dartz.dart';
import '../entities/post.dart';
import '../entities/comment.dart';
import '../../core/error/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getAllPosts();
  Future<Either<Failure, Post>> getPostDetails(int id);
  Future<Either<Failure, List<Comment>>> getPostComments(int postId);
  Future<Either<Failure, List<Post>>> getSavedPosts();
  Future<Either<Failure, Post>> savePost(Post post);
  Future<Either<Failure, Post>> unsavePost(Post post);
  Future<Either<Failure, bool>> isPostSaved(int postId);
  Future<Either<Failure, int>> getSavedPostsCount();
}