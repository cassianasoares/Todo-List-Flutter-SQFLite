import 'package:flutter/material.dart';
import 'package:todolist/screens/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      debugShowCheckedModeBanner:  false,
      theme: ThemeData(
      
        primarySwatch: Colors.red,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
    );
  }
}

