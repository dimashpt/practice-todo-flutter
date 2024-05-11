import 'package:flutter/material.dart';
import 'package:fluttertodo/components/void.dart';

enum TodoItemPosition {
  first,
  last,
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.description,
    required this.done,
    this.onTap,
    this.onLongPress,
    this.position,
  });

  final String description;
  final bool done;
  final Function()? onTap;
  final Function()? onLongPress;
  final TodoItemPosition? position;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        right: onTap != null ? 8 : 16,
        left: 16,
      ),
      leading: Checkbox(
        value: done,
        onChanged: (_) {},
      ),
      title: Text(description),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: position == TodoItemPosition.first
              ? Radius.circular(8)
              : Radius.zero,
          bottom: position == TodoItemPosition.last
              ? Radius.circular(8)
              : Radius.zero,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          onTap != null ? Icon(Icons.chevron_right_rounded) : Void(),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
