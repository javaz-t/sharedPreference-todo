import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {




  List<String> todoList = ['kjdfhsjd', 'fjdsfhkjs'];
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }
  _loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = prefs.getStringList('todoList') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {


    _add() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: TextField(

                controller: titleController,
                decoration: InputDecoration(hintText: 'add task',),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async{
                  setState(() {
                    String todo =titleController.text;
                    todoList.add(todo);
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setStringList('todoList', todoList);
                    print(todoList);
                  },
                  child: Text('SAVE'),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Cancel'))
              ],
            );
          });
    }
    _edit(int index) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: TextField(

                controller: titleController,
                decoration: InputDecoration(hintText: 'add task',),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                     todoList[index]=titleController.text;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setStringList('todoList', todoList);
                    print(todoList);
                  },
                  child: Text('SAVE'),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Cancel'))
              ],
            );
          });
    }

    return Scaffold(
      floatingActionButton:
          FloatingActionButton(onPressed: (){ _add(); } , child: Text('Add ')),
      appBar: AppBar(
        title: Text('Todo List '),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(todoList[index].toString()),
                leading: IconButton(onPressed: () {
                  titleController.text = todoList[index].toString();
                  _edit(index);
                }, icon: Icon(Icons.edit)),
                trailing: IconButton(icon: const Icon(Icons.delete),onPressed: () async {
                  setState(() {
                    todoList.removeAt(index);
                  });
                  final prefs = await  SharedPreferences.getInstance();
                  prefs.setStringList('todoList', todoList);
                },),
              ),
            );
          }),
    );
  }
}
