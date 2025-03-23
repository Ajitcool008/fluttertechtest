import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class SavePost {
  final PostRepository repository;

  SavePost(this.repository);

  Future<Either<Failure, Post>> call(Post post) async {
    return await repository.savePost(post);
  }
}