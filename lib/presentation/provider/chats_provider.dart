import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:s_template/common/utils/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chats_provider.g.dart';

@Riverpod(keepAlive: true)
class Chats extends _$Chats {
  bool _isConnected = false;
  final _wsUrl = dotenv.get('WS_URL');
  late WebSocketChannel _channel;

  @override
  Stream<List<String>> build() async* {
    yield <String>[];
  }

  bool isConnected() => _isConnected;

  Future<void> connect({required String roomId, required Function(String) onMessage}) async {
    if (_isConnected) await disconnect();
    _channel = WebSocketChannel.connect(Uri.parse('$_wsUrl/$roomId'));
    await _channel.ready;
    _isConnected = true;
    _channel.stream.listen(
      (message) {
        logger.d('message: $message');
        if (message is String) {
          state = AsyncData([...?state.value, json.decode(message)]);
        }
        onMessage?.call(message);
      },
      onDone: () => disconnect(),
    );
    state = AsyncData(["Connected to $roomId"]);
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _channel.sink.close();
    state = const AsyncData(["Disconnected"]);
  }

  void sendMessage({required String message, required String username}) {
    if (!_isConnected) return;
    final jsonString = jsonEncode({
      'username': username,
      'message': message,
    });
    _channel.sink.add(jsonString);
  }
}