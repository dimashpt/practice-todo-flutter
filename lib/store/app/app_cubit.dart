import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.dart';
part 'app_cubit.g.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit() : super(const AppState(locale: 'en', theme: 'light'));

  @override
  AppState fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  @override
  Map<String, dynamic> toJson(AppState state) => _$AppStateToJson(state);

  void setLocale(String locale) {
    emit(state.copyWith(locale: locale));
  }

  void setTheme(String theme) {
    emit(state.copyWith(theme: theme));
  }
}
