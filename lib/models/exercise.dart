class Exercise {
  final String name;
  final String reps;
  final String sets;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.reps,
    required this.sets,
    this.isCompleted = false,
  });
}
