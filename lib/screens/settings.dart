import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertodo/components/settings_item.dart';
import 'package:fluttertodo/components/settings_section.dart';
import 'package:fluttertodo/store/app/app_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void onLanguageTap(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    final state = appCubit.state;

    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      expand: false,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...['en', 'id'].map((locale) {
            return ListTile(
              title: Text('languages.$locale').tr(),
              trailing:
                  state.locale == locale ? Icon(Icons.check_rounded) : null,
              onTap: () {
                context.setLocale(Locale(locale));
                appCubit.setLocale(locale);
                Navigator.pop(_);
              },
            );
          }),
        ],
      ),
    );
  }

  void onThemeTap(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    final state = appCubit.state;

    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      expand: false,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...['light', 'dark', 'system'].map((theme) {
            return ListTile(
              title: Text('general.$theme').tr(),
              trailing: state.theme == theme ? Icon(Icons.check_rounded) : null,
              onTap: () {
                appCubit.setTheme(theme);
                Navigator.pop(_);
              },
            );
          }),
        ],
      ),
    );
  }

  void _onNotificationTap() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void _onNotificationLongPress() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'default_channel',
            actionType: ActionType.Default,
            title: 'Hello World!',
            body: 'This is my first notification!',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('settings_screen.title').tr(),
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              SettingsSection(
                title: 'settings_screen.application'.tr(),
                items: [
                  SettingsItem(
                    title: 'settings_screen.language'.tr(),
                    icon: Icons.language,
                    value: 'languages.${state.locale}'.tr(),
                    onTap: () => onLanguageTap(context),
                    position: SettingsItemPosition.first,
                  ),
                  SettingsItem(
                    title: 'settings_screen.theme'.tr(),
                    icon: Icons.sunny,
                    value: 'general.${state.theme}'.tr(),
                    onTap: () => onThemeTap(context),
                  ),
                  FutureBuilder(
                    future: AwesomeNotifications().isNotificationAllowed(),
                    builder: (_, AsyncSnapshot<bool> snapshot) {
                      return SettingsItem(
                        title: 'settings_screen.notifications'.tr(),
                        icon: Icons.notifications_active,
                        value: snapshot.data == true
                            ? 'general.enabled'.tr()
                            : 'general.disabled'.tr(),
                        position: SettingsItemPosition.last,
                        onTap: _onNotificationTap,
                        onLongPress: _onNotificationLongPress,
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                items: [
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
                      return SettingsItem(
                        title: 'settings_screen.version'.tr(),
                        icon: Icons.verified_outlined,
                        value: snapshot.data?.version,
                        position: SettingsItemPosition.first,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
