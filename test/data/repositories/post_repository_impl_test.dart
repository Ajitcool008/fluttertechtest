import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/exceptions.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/network/network_info.dart';
import 'package:flutter_tech_task/data/datasources/post_local_data_source.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_data_source.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/repositories/post_repository_impl.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_repository_impl_test.mocks.dart';

@GenerateMocks([PostRemoteDataSource, PostLocalDataSource, NetworkInfo])
void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockPostLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalDataSource = MockPostLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = PostRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllPosts', () {
    final tPostModels = [
      const PostModel(
        id: 1,
        title: 'Test Title 1',
        body: 'Test Body 1',
        userId: 1,
      ),
      const PostModel(
        id: 2,
        title: 'Test Title 2',
        body: 'Test Body 2',
        userId: 2,
      ),
    ];
    final List<Post> tPosts = tPostModels;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getAllPosts(),
      ).thenAnswer((_) async => tPostModels);
      when(mockLocalDataSource.isPostSaved(any)).thenAnswer((_) async => false);

      // act
      await repository.getAllPosts();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getAllPosts(),
          ).thenAnswer((_) async => tPostModels);
          // Need to stub isPostSaved for each post
          when(
            mockLocalDataSource.isPostSaved(1),
          ).thenAnswer((_) async => false);
          when(
            mockLocalDataSource.isPostSaved(2),
          ).thenAnswer((_) async => false);

          // act
          final result = await repository.getAllPosts();

          // assert
          verify(mockRemoteDataSource.getAllPosts());
          // Use matcher that ignores reference equality
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Expected Right but got Left(failure)'),
            (posts) {
              expect(posts.length, tPosts.length);
              for (int i = 0; i < posts.length; i++) {
                expect(posts[i].id, tPosts[i].id);
                expect(posts[i].title, tPosts[i].title);
                expect(posts[i].body, tPosts[i].body);
                expect(posts[i].userId, tPosts[i].userId);
              }
            },
          );
        },
      );
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getAllPosts()).thenThrow(ServerException());

          // act
          final result = await repository.getAllPosts();

          // assert
          verify(mockRemoteDataSource.getAllPosts());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}
