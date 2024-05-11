part of 'todo_cubit.dart';

@JsonSerializable()
class TodoState extends Equatable {
  final List<Todo> todos;

  const TodoState({required this.todos});

  @override
  List<Object?> get props => [todos];

  TodoState copyWith({
    required List<Todo> todos,
  }) => TodoState(
      todos: todos,
  );
}

@JsonSerializable()
class Todo {
  final String id;
  final String description;
  final bool done;

  Todo({
    required this.id,
    required this.description,
    required this.done,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    String? id,
    String? description,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }
}
