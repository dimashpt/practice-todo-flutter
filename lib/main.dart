import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:fluttertodo/store/app/app_cubit.dart';
import 'package:fluttertodo/store/providers.dart';
import 'package:fluttertodo/utils/notification.dart';
import 'package:fluttertodo/utils/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Library initialization
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize HydratedBloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Add Google Fonts license
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Initialize push notification
  NotificationController.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  ThemeMode _getThemeMode(String theme) {
    if (theme == 'light') return ThemeMode.light;
    if (theme == 'dark') return ThemeMode.dark;

    return ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (_, state) => EasyLocalization(
          supportedLocales: [
            Locale('en', ''),
            Locale('id', ''),
          ],
          path: 'lib/locales',
          fallbackLocale: Locale(state.locale, ''),
          child: Builder(
            builder: (context) {
              return MaterialApp.router(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: router,
                themeMode: _getThemeMode(state.theme),
                theme: ThemeData(
                  textTheme: GoogleFonts.poppinsTextTheme(ThemeData().textTheme),
                  scaffoldBackgroundColor: Colors.grey[200],
                  splashColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: Brightness.light,
                  ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
                  scaffoldBackgroundColor: Colors.black,
                  splashColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: Brightness.dark,
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
