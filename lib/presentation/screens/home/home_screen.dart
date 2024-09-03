import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:s_template/common/extensions/widget_extension.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomIdController = useTextEditingController();
    final usernameController = useTextEditingController();

    final isConnected = useState(false);
    final chats = useState(<String>[]);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                itemCount: chats.value.length,
                itemBuilder: (context, index) {
                  return Text(chats.value[index]);
                },
              ),
            ),
          ],
        ),
      ).safeArea(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
