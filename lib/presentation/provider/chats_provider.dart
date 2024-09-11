import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:s_template/common/utils/logger.dart';
import 'package:s_template/data/models/chat/chat_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chats_provider.g.dart';

@Riverpod(keepAlive: true)
class Chats extends _$Chats {
  bool _isConnected = false;
  final _wsUrl = dotenv.get('WS_URL');
  late WebSocketChannel _channel;

  @override
  Stream<List<ChatModel>> build() async* {
    yield <ChatModel>[];
  }

  bool isConnected() => _isConnected;

  Future<void> connect({required String roomId, required Function(ChatModel) onMessage}) async {
    if (_isConnected) await disconnect();
    _channel = WebSocketChannel.connect(Uri.parse('$_wsUrl/$roomId'));
    await _channel.ready;
    _isConnected = true;
    _channel.stream.listen(
      (message) {
        logger.d('received message: $message');
        if (message is String) {
          final data = jsonDecode(message);
          final chatData = ChatModel.fromJson(jsonDecode(data));
          state = AsyncData([...?state.value, chatData]);
          onMessage.call(chatData);
        }
      },
      onDone: () => disconnect(),
    );
    state = AsyncData([
      ChatModel(username: 'System', message: 'Connected to $roomId'),
    ]);
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _channel.sink.close();
    state = const AsyncData([ChatModel(username: 'System', message: 'Disconnected')]);
  }

  void sendMessage(ChatModel chat) {
    if (!_isConnected) return;
    _channel.sink.add(jsonEncode(chat.toJson()));
  }
}
