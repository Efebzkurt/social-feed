class Comment {
  final String? commentId;
  final String? postId;
  final String? userId;
  final String? commentText;
  final DateTime? createdAt;

  Comment({
    this.commentId,
    this.postId,
    this.userId,
    this.commentText,
    this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      postId: map['postId'],
      userId: map['userId'],
      commentText: map['commentText'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
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
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'commentText': commentText,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Comment copyWith({
    String? commentId,
    String? postId,
    String? userId,
    String? commentText,
    DateTime? createdAt,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      commentText: commentText ?? this.commentText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
