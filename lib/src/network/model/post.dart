import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:mobile_concert/src/network/model/user.dart';

class MPost extends Equatable {
  final String id;
  final String content;
  final List<String> medias;
  final bool isStream;
  final DateTime createAt;
  final String owner;
  final MUser? ownerUser;

  const MPost({
    required this.id,
    required this.content,
    required this.medias,
    required this.isStream,
    required this.createAt,
    required this.owner,
    this.ownerUser,
  });

  @override
  List<Object?> get props => [
    id,
    content,
    medias,
    isStream,
    createAt,
    owner,
    ownerUser,
  ];

  MPost copyWith({
    String? id,
    String? content,
    List<String>? medias,
    bool? isStream,
    DateTime? createAt,
    String? owner,
    MUser? ownerUser,
  }) {
    return MPost(
      id: id ?? this.id,
      content: content ?? this.content,
      medias: medias ?? this.medias,
      isStream: isStream ?? this.isStream,
      createAt: createAt ?? this.createAt,
      owner: owner ?? this.owner,
      ownerUser: ownerUser ?? this.ownerUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'medias': medias,
      'is_stream': isStream,
      'created_at': createAt.millisecondsSinceEpoch,
      'owner': owner,
    };
  }

  factory MPost.fromMap(Map<String, dynamic> map) {
    return MPost(
      id: map['id'] as String,
      content: map['content'] as String,
      medias: List<String>.from((map['medias'] as List<dynamic>)),
      isStream: map['is_stream'] as bool,
      createAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      owner: map['owner'] as String,
    );
  }

  factory MPost.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return MPost(
      id: snapshot.id,
      content: map['content'] as String,
      medias: List<String>.from((map['medias'] as List<dynamic>)),
      isStream: map['is_stream'] as bool,
      createAt: (map['created_at'] as Timestamp).toDate(),
      owner: map['owner'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MPost.fromJson(String source) =>
      MPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MPost{id=$id, content=$content, medias=$medias, isStream=$isStream, createAt=$createAt, owner=$owner}';
  }
}
