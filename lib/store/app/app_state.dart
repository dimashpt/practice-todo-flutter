part of 'app_cubit.dart';

@JsonSerializable()
class AppState extends Equatable {
  final String locale;
  final String theme;

  const AppState({
    required this.locale,
    required this.theme,
  });

  AppState copyWith({
    String? locale,
    String? theme,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [locale, theme];
}
