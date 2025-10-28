// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:mobile_concert/src/network/model/user.dart';

class Post extends Equatable {
  final String id;
  final String content;
  final List<String> medias;
  final bool isStream;
  final DateTime createAt;
  final User owner;
  const Post({
    required this.id,
    required this.content,
    required this.medias,
    required this.isStream,
    required this.createAt,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, content, medias, isStream, createAt, owner];

  Post copyWith({
    String? id,
    String? content,
    List<String>? medias,
    bool? isStream,
    DateTime? createAt,
    User? owner,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      medias: medias ?? this.medias,
      isStream: isStream ?? this.isStream,
      createAt: createAt ?? this.createAt,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'medias': medias,
      'isStream': isStream,
      'createAt': createAt.millisecondsSinceEpoch,
      'owner': owner.toMap(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      content: map['content'] as String,
      medias: List<String>.from((map['medias'] as List<String>)),
      isStream: map['isStream'] as bool,
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
      owner: User.fromMap(map['owner'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'Post{id=$id, content=$content, medias=$medias, isStream=$isStream, createAt=$createAt, owner=$owner}';
  }
}
