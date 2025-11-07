import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/features/settings/logic/setting_bloc.dart';
import 'package:mobile_concert/src/router/router.dart';
import 'package:mobile_concert/src/theme/screen.dart';
import 'package:mobile_concert/src/theme/themes.dart';
import 'package:mobile_concert/src/localization/localization_utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreens.mediaQuery = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingBloc()),
        BlocProvider(lazy: false, create: (_) => GetIt.I<HomeCubit>()),
      ],
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return MaterialApp.router(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            onGenerateTitle: (context) => S.of(context).common_appTitle,
            builder: BotToastInit(),
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            routerConfig: GetIt.I<AppRouter>().router,
          );
        },
      ),
    );
  }
}
