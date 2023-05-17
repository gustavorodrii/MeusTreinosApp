import 'package:gym_project/datetime/date_time.dart';
import 'package:gym_project/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise.dart';

class HiveDataBase {
  final _myBox = Hive.box("workout_database1");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  void saveToDataBase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  List<Workout> readFromDataBase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exerciseInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            reps: exerciseDetails[i][j][1],
            sets: exerciseDetails[i][j][2],
            isCompleted: exerciseDetails[i][j][3] == "true" ? true : false,
          ),
        );
      }

      Workout workout = Workout(
        name: workoutNames[i],
        exercises: exerciseInEachWorkout,
      );
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  List<String> convertObjectToWorkoutList(List<Workout> workouts) {
    List<String> workoutList = [];

    for (int i = 0; i < workouts.length; i++) {
      workoutList.add(
        workouts[i].name,
      );
    }
    return workoutList;
  }

  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
    List<List<List<String>>> exerciseList = [];

    for (int i = 0; i < workouts.length; i++) {
      List<Exercise> exercisesInWorkout = workouts[i].exercises;

      List<List<String>> indiviualWorkout = [];

      for (int j = 0; j < exercisesInWorkout.length; j++) {
        List<String> individualExercise = [];

        individualExercise.addAll(
          [
            exercisesInWorkout[j].name,
            exercisesInWorkout[j].reps,
            exercisesInWorkout[j].sets,
            exercisesInWorkout[j].isCompleted.toString(),
          ],
        );
        indiviualWorkout.add(individualExercise);
      }
      exerciseList.add(indiviualWorkout);
    }

    return exerciseList;
  }
}
