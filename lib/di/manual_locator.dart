import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/network/network_info.dart';
import '../data/datasources/post_local_data_source.dart';
import '../data/datasources/post_remote_data_source.dart';
import '../data/repositories/post_repository_impl.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/usecases/get_all_posts.dart';
import '../domain/usecases/get_post_comments.dart';
import '../domain/usecases/get_post_details.dart';
import '../domain/usecases/get_saved_posts.dart';
import '../domain/usecases/get_saved_posts_count.dart';
import '../domain/usecases/save_post.dart';
import '../domain/usecases/unsave_post.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../ui/views/posts/posts_viewmodel.dart';
import '../ui/views/saved_posts/saved_posts_viewmodel.dart';

final GetIt locator = GetIt.instance;

Future<void> setupDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );

  // Core
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(locator<InternetConnectionChecker>()),
  );

  // Services
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());

  // Data sources
  locator.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: locator<http.Client>()),
  );
  locator.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(
      sharedPreferences: locator<SharedPreferences>(),
    ),
  );

  // Repository
  locator.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: locator<PostRemoteDataSource>(),
      localDataSource: locator<PostLocalDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  // Use cases
  locator.registerLazySingleton<GetAllPosts>(
    () => GetAllPosts(locator<PostRepository>()),
  );
  locator.registerLazySingleton<GetPostDetails>(
    () => GetPostDetails(locator<PostRepository>()),
  );
  locator.registerLazySingleton<GetPostComments>(
    () => GetPostComments(locator<PostRepository>()),
  );
  locator.registerLazySingleton<GetSavedPosts>(
    () => GetSavedPosts(locator<PostRepository>()),
  );
  locator.registerLazySingleton<GetSavedPostsCount>(
    () => GetSavedPostsCount(locator<PostRepository>()),
  );
  locator.registerLazySingleton<SavePost>(
    () => SavePost(locator<PostRepository>()),
  );
  locator.registerLazySingleton<UnsavePost>(
    () => UnsavePost(locator<PostRepository>()),
  );

  // Application services
  locator.registerLazySingleton<PostService>(
    () => PostService(
      getAllPosts: locator<GetAllPosts>(),
      getPostDetails: locator<GetPostDetails>(),
      getSavedPosts: locator<GetSavedPosts>(),
      getSavedPostsCount: locator<GetSavedPostsCount>(),
      savePost: locator<SavePost>(),
      unsavePost: locator<UnsavePost>(),
    ),
  );

  locator.registerLazySingleton<CommentService>(
    () => CommentService(
      getPostComments: locator<GetPostComments>(),
      repository: locator<PostRepository>(), // Add repository
    ),
  );

  // Register ViewModels as singletons so they can be accessed from anywhere
  locator.registerSingleton<PostsViewModel>(PostsViewModel());
  locator.registerSingleton<SavedPostsViewModel>(SavedPostsViewModel());
}
