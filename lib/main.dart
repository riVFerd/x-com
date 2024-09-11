import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:s_template/app.dart';
import 'package:s_template/injection.dart';

void main() async {
  await dotenv.load();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'x-com_channel_group',
          channelKey: 'x-com_channel',
          channelName: 'X-Com Channel',
          channelDescription: 'Notification channel for X-Com apps',
          ledColor: Colors.white,
        )
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  runApp(const ProviderScope(child: App()));
}
