import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/my_database.dart';
import 'package:todo_list/widgets/widgets.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.grey),
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbHelper = DatabaseHelper.instance;
  Future<List<Todo>> _query() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> allRows = [];
    allRows = await db.queryAllRows();

    return List.generate(allRows.length, (i) {
      return Todo(
        id: allRows[i]['_id'],
        title: allRows[i]['title'],
        isCheck: (allRows[i]['done'] == 0) ? false : true,
      );
    });
  }

  List<Todo> todoList;

  _setTodo(value) {
    todoList = value;
  }

  _HomeState() {
    _query().then((value) {
      setState(() {
        _setTodo(value);
      });
    });
  }
  void _update({num id, String title, bool isChecked}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnIsChecked: (isChecked) ? 1 : 0
    };
    await dbHelper.update(row, id).then((gs) {
      _query().then((value) {
        setState(() {
          _setTodo(value);
        });
      });
    });
  }

  _delete(int id) async {
    final db = DatabaseHelper.instance;
    await db.delete(id);
  }


  void add({String title, bool isChecked}) {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnIsChecked: 0
    };
    dbHelper.insert(row).then((gs) {
      _query().then((value) {
        setState(() {
          _setTodo(value);
        });
      });
    });

    Navigator.of(context).pop();
  }

  bool changeCheckBox(bool checkState) {
    return !checkState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Todo List")),
        body: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: (todoList == null) ? 0 : todoList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = todoList[index];
              return Dismissible(
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    color: Colors.redAccent,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    color: Colors.orangeAccent,
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Alertdialog(
                            todoList: todoList,
                            query: _query,
                            update: _update,
                            setTodo: _setTodo,
                            index: index,
                          );
                        },
                      );
                      _query().then((gs) => setState((){_setTodo(gs);}));
                    
                    } else if (direction == DismissDirection.startToEnd) {

                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("item ${item.title} deletado")
                      )
                      );
                      _delete(todoList[index].id);
                    }
                  },

                  child: CardList(
                    todoList: todoList,
                    index: index,
                  )

                  );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogAdd(add: add,);
                },
              );
            }));
  }
}

