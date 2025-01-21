import 'package:fstore/models/comment.dart';

class Post {
  final String? postId;
  final String? userId;
  final String? photoUrl;
  final String? description;
  final DateTime? createdAt;
  final List<String> likes; // Postu beğenen kullanıcıların ID'leri
  final List<Comment> comments; // Posta yapılan yorumların listesi
  final bool isUploaded;

  Post({
    this.postId,
    this.userId,
    this.photoUrl,
    this.description,
    this.createdAt,
    this.likes = const [],
    this.comments = const [],
    this.isUploaded = false,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'],
      userId: map['userId'],
      photoUrl: map['photoUrl'],
      description: map['description'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      likes: List<String>.from(map['likes'] ?? []),
      comments: (map['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromMap(e))
              .toList() ??
          [],
      isUploaded: map['isUploaded'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    final classMap = _createMap();
    final Map<String, dynamic> map = {};
    for (MapEntry<String, dynamic> entry in classMap.entries) {
      if (entry.value != null) {
        map.addEntries([entry]);
      }
    }
    return map;
  }

  Map<String, dynamic> _createMap() {
    return {
      'postId': postId,
      'userId': userId,
      'photoUrl': photoUrl,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'likes': likes,
      'comments': comments.map((c) => c.toMap()).toList(),
      'isUploaded': isUploaded,
    };
  }

  Post copyWith({
    String? postId,
    String? userId,
    String? photoUrl,
    String? description,
    DateTime? createdAt,
    List<String>? likes,
    List<Comment>? comments,
    bool? isUploaded,
  }) {
    return Post(
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        photoUrl: photoUrl ?? this.photoUrl,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        isUploaded: isUploaded ?? this.isUploaded);
  }
}
