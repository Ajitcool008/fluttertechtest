import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostDetails implements UseCase<Post, Params> {
  final PostRepository repository;

  GetPostDetails(this.repository);

  @override
  Future<Either<Failure, Post>> call(Params params) async {
    return await repository.getPostDetails(params.id);
  }
}