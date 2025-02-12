import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_bloc.dart';
import 'bloc/provider/provider_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'core/theme.dart';
import 'services/puzzle_service.dart';
import 'services/save_service.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => PuzzleService()),
        RepositoryProvider(create: (context) => SaveService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GameBloc(context.read<PuzzleService>())),
          BlocProvider(create: (context) => ProviderBloc(context.read<SaveService>())),
          BlocProvider(create: (context) => ThemeBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Simple Sudoku Game',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
