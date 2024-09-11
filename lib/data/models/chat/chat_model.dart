import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'chat_model.freezed.dart';

part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const ChatModel._();

  const factory ChatModel({
    required final String username,
    required final String message,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, Object?> json) => _$ChatModelFromJson(json);

  String displayMessage() => '$username: $message';
}
