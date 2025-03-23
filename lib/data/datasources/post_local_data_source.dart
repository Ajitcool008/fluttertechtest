import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getSavedPosts();
  Future<PostModel> savePost(PostModel post);
  Future<PostModel> unsavePost(PostModel post);
  Future<bool> isPostSaved(int postId);
  Future<int> getSavedPostsCount();
}

const cachedSavedPosts = 'CACHED_SAVED_POSTS';

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
  Future<PostModel> savePost(PostModel post) async {
    final savedPosts = await getSavedPosts();
    
    if (savedPosts.any((savedPost) => savedPost.id == post.id)) {
      return post.copyWith(isSaved: true);
    }

    final updatedPost = post.copyWith(isSaved: true);
    final updatedPosts = [...savedPosts, updatedPost];
    
    final jsonString = json.encode(updatedPosts.map((p) => p.toJson()).toList());
    final success = await sharedPreferences.setString(cachedSavedPosts, jsonString);
    
    if (success) {
      return updatedPost;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<PostModel> unsavePost(PostModel post) async {
    final savedPosts = await getSavedPosts();
    final updatedPosts = savedPosts.where((savedPost) => savedPost.id != post.id).toList();
    
    final jsonString = json.encode(updatedPosts.map((p) => p.toJson()).toList());
    final success = await sharedPreferences.setString(cachedSavedPosts, jsonString);
    
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
  Future<int> getSavedPostsCount() async {
    final savedPosts = await getSavedPosts();
    return savedPosts.length;
  }
}