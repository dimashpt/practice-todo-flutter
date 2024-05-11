import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_state.dart';
part 'todo_cubit.g.dart';

class TodoCubit extends HydratedCubit<TodoState> {
  TodoCubit() : super(const TodoState(todos: []));

  @override
  TodoState fromJson(Map<String, dynamic> json) => _$TodoStateFromJson(json);

  @override
  Map<String, dynamic> toJson(TodoState state) => _$TodoStateToJson(state);

  void addTodo(Todo todo) {
    emit(state.copyWith(todos: [todo, ...state.todos]));
  }

  void toggleDoneTodo(Todo todo) {
    final updatedTodo = todo.copyWith(done: !todo.done);
    final filteredTodos =
        state.todos.where((todo) => todo.id != updatedTodo.id);
    final doneTodos = filteredTodos.where((todo) => todo.done);
    final undoneTodos = filteredTodos.where((todo) => !todo.done);

    emit(
      state.copyWith(
        todos: updatedTodo.done
            ? [...undoneTodos, updatedTodo, ...doneTodos]
            : [updatedTodo, ...undoneTodos, ...doneTodos],
      ),
    );
  }

  void removeTodo(Todo todo) {
    final filteredTodos =
        state.todos.where((item) => item.id != todo.id).toList();

    emit(state.copyWith(todos: filteredTodos));
  }

  void updatedTodo(Todo todo) {
    final updatedTodos = state.todos
        .map((element) => element.id == todo.id ? todo : element)
        .toList();

    emit(state.copyWith(todos: updatedTodos));
  }
}
