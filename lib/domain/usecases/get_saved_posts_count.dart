import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/post_repository.dart';

class GetSavedPostsCount implements UseCase<int, NoParams> {
  final PostRepository repository;

  GetSavedPostsCount(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getSavedPostsCount();
  }
}