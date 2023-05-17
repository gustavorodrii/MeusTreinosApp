import 'package:flutter/material.dart';
import 'package:gym_project/data/workout_data.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Hive.openBox("workout_database1");

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        title: Center(
          child: Text(
            "Crie um novo treino",
            style: TextStyle(fontSize: 24, color: Colors.grey[900]),
          ),
        ),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: save,
                child: Text(
                  "Salvar",
                  style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                ),
              ),
              MaterialButton(
                onPressed: cancel,
                child: Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text.trim();

    if (newWorkoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha o nome do treino',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          elevation: 4,
          title: const Text(
            'Meus treinos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(right: 10),
          child: FloatingActionButton(
            elevation: 2,
            backgroundColor: Colors.grey[700],
            onPressed: createNewWorkout,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => Dismissible(
              key: Key(value.getWorkoutList()[index].name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                Provider.of<WorkoutData>(context, listen: false)
                    .deleteWorkout(index);
              },
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  color: Colors.grey[900],
                  child: Center(
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        value.getWorkoutList()[index].name.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            goToWorkoutPage(value.getWorkoutList()[index].name),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
