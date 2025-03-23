import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/comment.dart';
import '../repositories/post_repository.dart';

class GetPostComments implements UseCase<List<Comment>, Params> {
  final PostRepository repository;

  GetPostComments(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(Params params) async {
    return await repository.getPostComments(params.id);
  }
}