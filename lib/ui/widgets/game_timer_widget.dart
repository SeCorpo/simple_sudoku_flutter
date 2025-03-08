import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/timer/timer_bloc.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        String timerText;

        if (state is TimerRunInProgress) {
          timerText = "${state.duration}s";
        } else if (state is TimerRunComplete) {
          timerText = "Time's up!";
        } else {
          timerText = "";
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            timerText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        );
      },
    );
  }
}
