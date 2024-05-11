import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/store/app/app_cubit.dart';
import 'package:fluttertodo/store/todo/todo_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider<AppCubit>.value(value: AppCubit()),
  BlocProvider<TodoCubit>.value(value: TodoCubit())
];
