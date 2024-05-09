import 'package:flutter/material.dart';
import 'package:fluttertodo/components/void.dart';

enum SettingsItemPosition {
  first,
  last,
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.value,
    this.onTap,
    this.onLongPress,
    this.position,
  });

  final String title;
  final IconData icon;
  final String? value;
  final Function()? onTap;
  final Function()? onLongPress;
  final SettingsItemPosition? position;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        right: onTap != null ? 8 : 16,
        left: 16,
      ),
      leading: Icon(icon),
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: position == SettingsItemPosition.first
              ? Radius.circular(8)
              : Radius.zero,
          bottom: position == SettingsItemPosition.last
              ? Radius.circular(8)
              : Radius.zero,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value ?? ''),
          onTap != null ? Icon(Icons.chevron_right_rounded) : Void(),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
