import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_sudoku_flutter/bloc/shop/shop_bloc.dart';
import 'package:simple_sudoku_flutter/services/shop_service.dart';
import 'package:simple_sudoku_flutter/ui/screens/home_screen.dart';
import 'package:simple_sudoku_flutter/ui/screens/splash_screen.dart';
import 'bloc/game/game_bloc.dart';
import 'bloc/provider/provider_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'core/theme/theme.dart';
import 'services/puzzle_service.dart';
import 'services/save_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => PuzzleService()),
        RepositoryProvider(create: (context) => SaveService()),
        RepositoryProvider(create: (context) => ShopService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GameBloc(context.read<PuzzleService>())),
          BlocProvider(create: (context) => ProviderBloc(context.read<SaveService>())),
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(create: (context) => ShopBloc(context.read<ShopService>())),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Simple Sudoku Game',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              // home: const SplashScreen(),
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
