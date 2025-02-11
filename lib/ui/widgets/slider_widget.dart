import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double min;
  final double max;
  final int divisions;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const SliderWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.divisions,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double selectedValue = initialValue.toDouble(); // Keep local state for slider

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                value: selectedValue,
                min: min,
                max: max,
                divisions: divisions,
                label: "${selectedValue.toInt()}",
                onChanged: (value) {
                  setState(() => selectedValue = value);
                },
                onChangeEnd: (value) {
                  onChanged(value.toInt()); // Calls the callback when released
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
