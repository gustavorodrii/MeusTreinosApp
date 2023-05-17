import 'package:flutter/material.dart';
import 'package:gym_project/data/workout_data.dart';
import 'package:gym_project/pages/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

late Box box;

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox("workout_database1");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
