import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;
  final bool isSaved;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.isSaved = false,
  });

  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    bool? isSaved,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [id, title, body, userId, isSaved];
}