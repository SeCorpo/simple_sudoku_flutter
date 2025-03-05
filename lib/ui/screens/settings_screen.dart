import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../core/theme/button_styles.dart';
import '../widgets/confirmation_dialog_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Theme Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                bool isDarkMode = state.themeMode == ThemeMode.dark;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Dark Mode", style: TextStyle(fontSize: 16)),
                        Switch(
                          value: isDarkMode,
                          onChanged: (bool value) {
                            context.read<ThemeBloc>().add(ToggleTheme());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "Current Theme: ${state.themeMode.toString().split('.').last}",
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Reset Progress Button
            const Text("Game Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ElevatedButton(
              style: AppButtonStyles.redButtonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialogWidget(
                    title: "Reset Progress",
                    content: "Are you sure you want to reset all progress? This action cannot be undone.",
                    onConfirm: () {
                      context.read<ProviderBloc>().add(ResetProgress());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Progress has been reset!")),
                      );
                    },
                  ),
                );
              },
              child: const Text("Reset Progress"),
            ),
          ],
        ),
      ),
    );
  }
}
