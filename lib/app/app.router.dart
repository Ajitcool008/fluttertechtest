// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i5;
import 'package:flutter/material.dart';
import 'package:flutter_tech_task/ui/views/comments/comments_view.dart' as _i4;
import 'package:flutter_tech_task/ui/views/home/home_view.dart' as _i2;
import 'package:flutter_tech_task/ui/views/post_details/post_details_view.dart'
    as _i3;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i6;

class Routes {
  static const homeView = '/';

  static const postDetailsView = '/post-details-view';

  static const commentsView = '/comments-view';

  static const all = <String>{
    homeView,
    postDetailsView,
    commentsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.postDetailsView,
      page: _i3.PostDetailsView,
    ),
    _i1.RouteDef(
      Routes.commentsView,
      page: _i4.CommentsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i1.buildAdaptivePageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.PostDetailsView: (data) {
      final args = data.getArgs<PostDetailsViewArguments>(nullOk: false);
      return _i1.buildAdaptivePageRoute<dynamic>(
        builder: (context) =>
            _i3.PostDetailsView(key: args.key, postId: args.postId),
        settings: data,
      );
    },
    _i4.CommentsView: (data) {
      final args = data.getArgs<CommentsViewArguments>(nullOk: false);
      return _i1.buildAdaptivePageRoute<dynamic>(
        builder: (context) =>
            _i4.CommentsView(key: args.key, postId: args.postId),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class PostDetailsViewArguments {
  const PostDetailsViewArguments({
    this.key,
    required this.postId,
  });

  final _i5.Key? key;

  final int postId;

  @override
  String toString() {
    return '{"key": "$key", "postId": "$postId"}';
  }

  @override
  bool operator ==(covariant PostDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.postId == postId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ postId.hashCode;
  }
}

class CommentsViewArguments {
  const CommentsViewArguments({
    this.key,
    required this.postId,
  });

  final _i5.Key? key;

  final int postId;

  @override
  String toString() {
    return '{"key": "$key", "postId": "$postId"}';
  }

  @override
  bool operator ==(covariant CommentsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.postId == postId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ postId.hashCode;
  }
}

extension NavigatorStateExtension on _i6.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPostDetailsView({
    _i5.Key? key,
    required int postId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.postDetailsView,
        arguments: PostDetailsViewArguments(key: key, postId: postId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCommentsView({
    _i5.Key? key,
    required int postId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.commentsView,
        arguments: CommentsViewArguments(key: key, postId: postId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPostDetailsView({
    _i5.Key? key,
    required int postId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.postDetailsView,
        arguments: PostDetailsViewArguments(key: key, postId: postId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCommentsView({
    _i5.Key? key,
    required int postId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.commentsView,
        arguments: CommentsViewArguments(key: key, postId: postId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
