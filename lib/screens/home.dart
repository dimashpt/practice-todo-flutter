import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertodo/components/settings_section.dart';
import 'package:fluttertodo/store/todo/todo_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerField = TextEditingController();
  late Todo? _activeTodo;
  final FocusNode _focusNode = FocusNode();

  void _addTodo() {
    final todo = BlocProvider.of<TodoCubit>(context);
    final generatedId = DateTime.now().millisecondsSinceEpoch.toString();

    todo.addTodo(
      Todo(
        id: generatedId,
        description: _controllerField.text,
        done: false,
      ),
    );
    _formKey.currentState!.reset();
    _controllerField.clear();
  }

  void _updateTodo() {
    final todo = BlocProvider.of<TodoCubit>(context);

    todo.updatedTodo(
      _activeTodo!.copyWith(description: _controllerField.text),
    );

    setState(() {
      _activeTodo = null;
    });

    _formKey.currentState!.reset();
    _controllerField.clear();
  }

  void _onEdit(Todo todo) {
    _controllerField.text = todo.description;
    // set focus to the text field
    FocusScope.of(context).requestFocus(_focusNode);

    setState(() {
      _activeTodo = todo;
    });
  }

  void _onSubmit(String value) {
    if (_formKey.currentState!.validate()) {
      if (_activeTodo != null) return _updateTodo();

      return _addTodo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo = BlocProvider.of<TodoCubit>(context);

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('home_screen.title').tr(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controllerField,
                    focusNode: _focusNode,
                    onFieldSubmitted: _onSubmit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'home_screen.input_placeholder'.tr(),
                      suffixIcon: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('home_screen.description').tr(),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    SettingsSection(
                      items: [
                        ...state.todos.map(
                          (item) => Slidable(
                            key: Key(item.id),
                            endActionPane: ActionPane(
                              motion: DrawerMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () => todo.removeTodo(item),
                              ),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => _onEdit(item),
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                ),
                                SlidableAction(
                                  onPressed: (_) => todo.removeTodo(item),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              title: Text(item.description),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: item.done,
                              onChanged: (value) => todo.toggleDoneTodo(item),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
