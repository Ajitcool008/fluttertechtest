import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked_annotations.dart';
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
import '../ui/views/comments/comments_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/post_details/post_details_view.dart';

@StackedApp(
  routes: [
    AdaptiveRoute(page: HomeView, initial: true),
    AdaptiveRoute(page: PostDetailsView),
    AdaptiveRoute(page: CommentsView),
  ],
  dependencies: [
    // Services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: PostService),
    LazySingleton(classType: CommentService),

    // Use cases
    LazySingleton(classType: GetAllPosts),
    LazySingleton(classType: GetPostDetails),
    LazySingleton(classType: GetPostComments),
    LazySingleton(classType: GetSavedPosts),
    LazySingleton(classType: GetSavedPostsCount),
    LazySingleton(classType: SavePost),
    LazySingleton(classType: UnsavePost),

    // Repository
    LazySingleton<PostRepository>(classType: PostRepositoryImpl),

    // Data sources
    LazySingleton<PostRemoteDataSource>(classType: PostRemoteDataSourceImpl),
    LazySingleton<PostLocalDataSource>(classType: PostLocalDataSourceImpl),

    // Core
    LazySingleton<NetworkInfo>(classType: NetworkInfoImpl),

    // External
    LazySingleton(classType: InternetConnectionChecker),
    LazySingleton(classType: SharedPreferences, resolveUsing: getSharedPrefs),
    LazySingleton(classType: http.Client),
  ],
  logger: StackedLogger(),
)
class App {
  // This class has no purpose beside housing the annotation above
}

Future<SharedPreferences> getSharedPrefs() async {
  return await SharedPreferences.getInstance();
}
