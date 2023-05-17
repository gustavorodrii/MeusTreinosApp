import 'package:flutter/material.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/models/workout.dart';
import 'hive_database.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDataBase();

  List<Workout> workoutList = [];

  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDataBase();
    } else {
      db.saveToDataBase(workoutList);
    }
  }

  void deleteWorkout(int index) {
    workoutList.removeAt(index);
    notifyListeners();
    db.saveToDataBase(workoutList);
  }

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
    db.saveToDataBase(workoutList);
  }

  void addExercise(
      String workoutName, String exerciseName, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        reps: reps,
        sets: sets,
      ),
    );
    notifyListeners();
    db.saveToDataBase(workoutList);
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    db.saveToDataBase(workoutList);
  }

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
