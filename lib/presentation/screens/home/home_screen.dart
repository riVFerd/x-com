import 'package:button_animations/button_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:s_template/common/extensions/context_extension.dart';
import 'package:s_template/common/extensions/widget_extension.dart';
import 'package:s_template/presentation/provider/chats_provider.dart';
import 'package:s_template/presentation/themes/color_theme.dart';
import 'package:s_template/presentation/themes/sizing.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomId = useState('');
    final username = useState('');
    final messageController = useTextEditingController();

    final isConnected = useState(false);
    final chats = ref.watch(chatsProvider);

    ref.listen(chatsProvider, (_, __) async {
      isConnected.value = ref.read(chatsProvider.notifier).isConnected();
    });

    return Scaffold(
      body: Container(
        color: Colors.grey.shade900,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Connection Status : ',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected.value ? Colors.green : Colors.red,
                      border: Border.all(
                        color: Colors.grey.shade700,
                        width: 3,
                      ),
                    ),
                  ),
                ],
              ),
              Sz.vSpacingMedium,
              Row(
                children: [
                  TextFormField(
                    onChanged: (value) => roomId.value = value,
                    enabled: !isConnected.value,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Room ID',
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CT.primaryColor.withOpacity(0.5)),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: CT.primaryColor),
                      ),
                    ),
                  ).expand(),
                  Sz.hSpacingMedium,
                  Opacity(
                    opacity: roomId.value.isNotEmpty && username.value.isNotEmpty ? 1 : 0.5,
                    child: AnimatedButton(
                      isOutline: true,
                      color: Colors.grey.shade300,
                      borderColor: Colors.grey,
                      borderRadius: 32,
                      type: null,
                      width: 160,
                      enabled: roomId.value.isNotEmpty && username.value.isNotEmpty,
                      onTap: () => _connectionButtonPressed(ref, roomId.value, isConnected.value),
                      child: Text(
                        isConnected.value ? 'Disconnect' : 'Connect',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: (value) => username.value = value,
                enabled: !isConnected.value,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Username',
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CT.primaryColor.withOpacity(0.5)),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: CT.primaryColor),
                  ),
                ),
              ),
              Sz.vSpacingLarge,
              Container(
                constraints: BoxConstraints(maxHeight: context.height / 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: Colors.grey.shade800, width: 4),
                ),
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: chats.value?.length ?? 0,
                  separatorBuilder: (_, index) => Sz.vSpacingSmall,
                  itemBuilder: (context, index) {
                    // safely to force non-null because will only called when chats.value is not null
                    return Text(
                      chats.value![index],
                      style: context.textTheme.titleMedium?.copyWith(color: Colors.white, height: 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ).safeArea(),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 4,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send Message',
              style: context.textTheme.titleMedium?.copyWith(color: CT.primaryColor),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    enabled: isConnected.value,
                    maxLines: 3,
                    minLines: 1,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CT.primaryColor.withOpacity(0.5)),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: CT.primaryColor),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  color: CT.primaryColor,
                  disabledColor: CT.primaryColor.withOpacity(0.5),
                  onPressed: isConnected.value ? () {
                    _sendMessage(ref, context, messageController.text, username.value);
                    messageController.clear();
                  } : null,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _connectionButtonPressed(WidgetRef ref, String roomId, bool isConnected) {
    if (isConnected) {
      ref.read(chatsProvider.notifier).disconnect();
    } else {
      ref.read(chatsProvider.notifier).connect(roomId: roomId);
    }
  }

  void _sendMessage(WidgetRef ref, BuildContext context, String message, String username) {
    if (message.isEmpty || username.isEmpty) {
      context.showSnackBar('Message or username cannot be empty');
      return;
    }
    ref.read(chatsProvider.notifier).sendMessage(message: message, username: username);
  }
}
