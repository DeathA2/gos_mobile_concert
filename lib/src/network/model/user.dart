import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MUser extends Equatable {
  final String id;
  final String name;
  final String avatar;
  const MUser({required this.id, required this.name, required this.avatar});

  MUser copyWith({String? id, String? name, String? avatar}) {
    return MUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'avatar': avatar};
  }

  factory MUser.fromMap(Map<String, dynamic> map) {
    return MUser(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
    );
  }

  factory MUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return MUser(
      id: snapshot.id,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MUser.fromJson(String source) =>
      MUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MUser(id: $id, name: $name, avatar: $avatar)';

  @override
  List<Object?> get props => [id, name, avatar];
}
