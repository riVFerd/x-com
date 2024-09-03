import 'dart:convert';

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

  Future<bool> isConnected() async {
    if (_isConnected) return true;
    try {
      await _channel.ready;
    } catch (e) {
      logger.e(e);
      return false;
    }
    _isConnected = true;
    return _isConnected;
  }

  Future<void> connect({required String roomId}) async {
    if (_isConnected) disconnect();
    _channel = WebSocketChannel.connect(Uri.parse('$_wsUrl/$roomId'));
    if (!await isConnected()) return;
    _channel.stream.listen(
      (message) {
        logger.d('message: $message');
        if (message is String) {
          state = AsyncData([...?state.value, json.decode(message)]);
        }
      },
      onDone: () => disconnect(),
    );
    state = const AsyncData([]);
  }

  void disconnect() {
    _isConnected = false;
    _channel.sink.close();
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