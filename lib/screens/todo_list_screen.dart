import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/helpers/database_helper.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState(){
    super.initState();
    _updateTaskList();
  }

  _updateTaskList(){
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  _deleteTask(int id){
    setState(() {
      DatabaseHelper.instance.deleteTask(id);
      _updateTaskList();
    });
  }

  Widget _buildTask(Task task){
    return Dismissible(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(task.title, 
                  style: TextStyle(
                      fontSize: 18.0,
                      decoration: task.status == 0 
                            ? TextDecoration.none 
                            : TextDecoration.lineThrough,
                  ),
              ),
              subtitle: Text('${_dateFormatter.format( task.date)} + ${task.priority}',
                      style: TextStyle(
                      fontSize: 15.0,
                      decoration: task.status == 0 
                            ? TextDecoration.none 
                            : TextDecoration.lineThrough,
                  ),
              ),
              trailing: Checkbox( 
                  onChanged: (value){
                        task.status = value ? 1 : 0;
                        DatabaseHelper.instance.updateTask(task);
                        _updateTaskList();
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value:  task.status == 1 ? true : false,
                  ),
                  onTap: ( ) => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                        task: task,
                      ),
                    ),  
                  ),
            ),
            Divider(),
          ],
        ),
      ),
      key: Key(task.title),
      background: Container(
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction) {
              _deleteTask(task.id);
            },
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                    updateTaskList: _updateTaskList,
              ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
              );
          }

          final int completedTaskCount = snapshot.data
              .where((Task task) => task.status == 1)
              .toList()
              .length;

              return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if(index == 0){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      Text(
                        'My Tasks',
                        style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(height: 10.0),
                      Text(
                          '$completedTaskCount of ${snapshot.data.length}', 
                          style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 20.0, 
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                  ],
                ),
              );
            }
            return _buildTask(snapshot.data[index - 1]);
          },
        );
        },
      ),
        
    );
  }
}