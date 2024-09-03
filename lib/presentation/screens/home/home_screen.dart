import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:s_template/common/extensions/widget_extension.dart';
import 'package:s_template/presentation/provider/chats_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomIdController = useTextEditingController();
    final usernameController = useTextEditingController();
    final messageController = useTextEditingController();

    final isConnected = useState(false);
    final chats = ref.watch(chatsProvider);

    ref.listen(chatsProvider, (_, __) async {
      isConnected.value = await ref.read(chatsProvider.notifier).isConnected();
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(chatsProvider.notifier).connect(roomId: roomIdController.text);
                  },
                  child: const Text('Connect'),
                ),
                isConnected.value ? const Icon(Icons.check) : const Icon(Icons.close),
              ],
            ),
            TextFormField(
              controller: roomIdController,
              decoration: const InputDecoration(
                labelText: 'Room ID',
              ),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemCount: chats.value?.length ?? 0,
                itemBuilder: (context, index) {
                  // safely to force non-null because will only called when chats.value is not null
                  return Text(chats.value![index]);
                },
              ),
            ),
          ],
        ),
      ).safeArea(),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ref.read(chatsProvider.notifier).sendMessage(
                  message: messageController.text,
                  username: usernameController.text,
                );
                messageController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
