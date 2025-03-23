import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class UnsavePost {
  final PostRepository repository;

  UnsavePost(this.repository);

  Future<Either<Failure, Post>> call(Post post) async {
    return await repository.unsavePost(post);
  }
}