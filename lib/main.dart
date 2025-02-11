import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_bloc.dart';
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
      child: BlocProvider(
        create: (context) => GameBloc(context.read<PuzzleService>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple Sudoku Game',
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
