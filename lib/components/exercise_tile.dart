import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?) onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListTile(
        title: Text(
          exerciseName,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        subtitle: Row(
          children: [
            if (reps.isNotEmpty)
              Chip(
                label: Text(
                  "$reps repetições",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if (sets.isNotEmpty)
              Chip(
                label: Text(
                  "$sets séries",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
          ],
        ),
        trailing: Checkbox(
          activeColor: Colors.grey[900],
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged(value),
        ),
      ),
    );
  }
}
