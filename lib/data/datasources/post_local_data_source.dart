import 'dart:convert';

import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getSavedPosts();
  Future<PostModel> savePost(PostModel post);
  Future<PostModel> unsavePost(PostModel post);
  Future<bool> isPostSaved(int postId);
  Future<int> getSavedPostsCount();
  Future<List<CommentModel>> getSavedPostComments(int postId);
  Future<void> savePostComments(int postId, List<CommentModel> comments);
  Future<bool> hasCommentsForPost(int postId);
}

const cachedSavedPosts = 'CACHED_SAVED_POSTS';
const cachedSavedComments = 'CACHED_COMMENTS_';

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getSavedPosts() async {
    final jsonString = sharedPreferences.getString(cachedSavedPosts);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<CommentModel>> getSavedPostComments(int postId) async {
    final key = cachedSavedComments + postId.toString();
    final jsonString = sharedPreferences.getString(key);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => CommentModel.fromJson(json)).toList();
      } catch (e) {
        throw CacheException();
      }
    }

    // Return empty list if no cached comments
    return [];
  }

  @override
  Future<PostModel> savePost(PostModel post) async {
    final savedPosts = await getSavedPosts();

    // Check if post is already saved
    if (savedPosts.any((savedPost) => savedPost.id == post.id)) {
      return post.copyWith(isSaved: true);
    }

    final updatedPost = post.copyWith(isSaved: true);
    final updatedPosts = [...savedPosts, updatedPost];

    final jsonString = json.encode(
      updatedPosts.map((p) => p.toJson()).toList(),
    );
    final success = await sharedPreferences.setString(
      cachedSavedPosts,
      jsonString,
    );

    if (success) {
      return updatedPost;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<PostModel> unsavePost(PostModel post) async {
    final savedPosts = await getSavedPosts();
    final updatedPosts =
        savedPosts.where((savedPost) => savedPost.id != post.id).toList();

    final jsonString = json.encode(
      updatedPosts.map((p) => p.toJson()).toList(),
    );
    final success = await sharedPreferences.setString(
      cachedSavedPosts,
      jsonString,
    );

    if (success) {
      return post.copyWith(isSaved: false);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> isPostSaved(int postId) async {
    final savedPosts = await getSavedPosts();
    return savedPosts.any((post) => post.id == postId);
  }

  @override
  Future<void> savePostComments(int postId, List<CommentModel> comments) async {
    final key = cachedSavedComments + postId.toString();
    final jsonString = json.encode(
      comments.map((comment) => comment.toJson()).toList(),
    );

    final success = await sharedPreferences.setString(key, jsonString);
    if (!success) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasCommentsForPost(int postId) async {
    final key = cachedSavedComments + postId.toString();
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<int> getSavedPostsCount() async {
    final savedPosts = await getSavedPosts();
    return savedPosts.length;
  }
}
