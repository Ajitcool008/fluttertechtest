import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/usecases/get_all_posts.dart';
import 'package:flutter_tech_task/domain/usecases/get_post_details.dart';
import 'package:flutter_tech_task/domain/usecases/get_saved_posts.dart';
import 'package:flutter_tech_task/domain/usecases/get_saved_posts_count.dart';
import 'package:flutter_tech_task/domain/usecases/save_post.dart';
import 'package:flutter_tech_task/domain/usecases/unsave_post.dart';
import 'package:flutter_tech_task/services/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_service_test.mocks.dart';

@GenerateMocks([
  GetAllPosts,
  GetPostDetails,
  GetSavedPosts,
  GetSavedPostsCount,
  SavePost,
  UnsavePost,
])
void main() {
  late PostService postService;
  late MockGetAllPosts mockGetAllPosts;
  late MockGetPostDetails mockGetPostDetails;
  late MockGetSavedPosts mockGetSavedPosts;
  late MockGetSavedPostsCount mockGetSavedPostsCount;
  late MockSavePost mockSavePost;
  late MockUnsavePost mockUnsavePost;

  setUp(() {
    mockGetAllPosts = MockGetAllPosts();
    mockGetPostDetails = MockGetPostDetails();
    mockGetSavedPosts = MockGetSavedPosts();
    mockGetSavedPostsCount = MockGetSavedPostsCount();
    mockSavePost = MockSavePost();
    mockUnsavePost = MockUnsavePost();

    // handles the call to updateSavedPostsCount() in the constructor
    when(mockGetSavedPostsCount(any)).thenAnswer((_) async => const Right(0));

    postService = PostService(
      getAllPosts: mockGetAllPosts,
      getPostDetails: mockGetPostDetails,
      getSavedPosts: mockGetSavedPosts,
      getSavedPostsCount: mockGetSavedPostsCount,
      savePost: mockSavePost,
      unsavePost: mockUnsavePost,
    );

    // Reset
    reset(mockGetSavedPostsCount);
  });

  group('getAllPosts', () {
    final tPosts = [
      const Post(id: 1, title: 'Test Title 1', body: 'Test Body 1', userId: 1),
      const Post(id: 2, title: 'Test Title 2', body: 'Test Body 2', userId: 1),
    ];

    test('should get posts from the usecase', () async {
      // arrange
      when(mockGetAllPosts(any)).thenAnswer((_) async => Right(tPosts));
      // act
      final result = await postService.getAllPosts();
      // assert
      expect(result, Right(tPosts));
      verify(mockGetAllPosts(NoParams()));
      verifyNoMoreInteractions(mockGetAllPosts);
    });

    test('should return server failure when usecase fails', () async {
      // arrange
      when(mockGetAllPosts(any)).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await postService.getAllPosts();
      // assert
      expect(result, Left(ServerFailure()));
    });
  });

  group('savePost', () {
    const tPost = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
    );
    const tSavedPost = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
      isSaved: true,
    );

    test('should save post using the usecase', () async {
      // arrange
      when(mockSavePost(any)).thenAnswer((_) async => const Right(tSavedPost));
      when(mockGetSavedPostsCount(any)).thenAnswer((_) async => const Right(1));

      // act
      final result = await postService.savePost(tPost);

      // assert
      expect(result, const Right(tSavedPost));
      verify(mockSavePost(tPost));
      verify(mockGetSavedPostsCount(NoParams()));
    });
  });
}
