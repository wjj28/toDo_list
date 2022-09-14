import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  Todo? completedTodo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo list '),
          centerTitle: true,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 18.0),
          //     child: IconButton(
          //       icon: const Icon(Icons.task_sharp),
          //       onPressed: () {
          //         // Navigator.push(
          //         //   context,
          //         //   MaterialPageRoute(
          //         //     builder: (context) {
          //         //       return  CompletedTodosPage(todo: todos);
          //         //     },
          //         //   ),
          //         // );
          //       },
          //     ),
          //   ),
          // ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adding new tasks
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          hintText: 'What are the ToDos for today?',
                          border: OutlineInputBorder(),
                        ),
                        // onSubmitted: onSubmitted,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: newTodo,
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.lightBlueAccent,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // new task
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                          onComplete: onComplete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Bottom widget
                Row(
                  children: [
                    Expanded(
                      child: Text('You have ${todos.length} pending tasks'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showDeleteAllConfirmationDialog();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        // fixedSize: const Size(10,55)
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                      ),
                      child: const Text('Clear all'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void newTodo() {
    String task = todoController.text;
    setState(() {
      Todo newTodo = Todo(title: task, date: DateTime.now());
      todos.add(newTodo);
    });
    todoController.clear();
  }

  void onComplete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      // todos.add(deletedTodo!);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task ${todo.title} was completed! Well done!',
        ),
        action: SnackBarAction(
          label: 'Oops, not done? ',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task ${todo.title} was deleted!',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Delete all
  void showDeleteAllConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all?'),
        content: const Text('You are about to delete all the todos'),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAll();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
  }

  void deleteAll() {
    setState(() {
      todos.clear();
    });
  }
}
