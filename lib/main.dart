import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_bloc.dart';
import 'services/puzzle_service.dart';
import 'ui/screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => PuzzleService()), // Inject PuzzleService
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GameBloc(context.read<PuzzleService>())), // Inject GameBloc
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nonogram Game',
          home: const GameScreen(),
        ),
      ),
    );
  }
}
