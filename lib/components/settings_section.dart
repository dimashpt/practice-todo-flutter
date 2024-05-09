import 'package:flutter/material.dart';
import 'package:fluttertodo/components/void.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.items,
    this.title = '',
  });

  final List<Widget> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isNotEmpty
            ? Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              )
            : Void(),
        SizedBox(height: 8),
        Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}
