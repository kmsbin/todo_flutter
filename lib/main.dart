import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/my_database.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.deepPurple),
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
      List<Map <String, dynamic>> allRows = [];
      allRows = await dbHelper.queryAllRows();

      return List.generate(allRows.length, (i) {
        return Todo(
          title: allRows[i]['title'],
          isCheck: allRows[i]['done'],
        );
      });
  }
  Future<List<Todo>> todoList;

  _HomeState() {
    todoList = _query();

  }

  TextEditingController _controllerActionButton = TextEditingController(); 
  void add() { 
    setState(() {
      // todoList.add(Todo(title:_controllerActionButton.text, isCheck: false));
      Navigator.of(context).pop();
      _controllerActionButton.text = ""; 
    });
   }

 bool changeCheckBox(bool checkState) {
   print(!checkState);
   return !checkState;
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: Container(
        child: FutureBuilder(
          future: todoList,

        builder: (context, snapshot) {
          return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: (snapshot.data==[])?0:snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            final item = snapshot.data[index];
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
                if(direction == DismissDirection.endToStart){
                  showDialog(
                    context: context,
                    builder:  (BuildContext context) {

                        TextEditingController _controller = TextEditingController(); 
                      
                        return AlertDialog(
                          title: new Text("Altere o Item"),
                          content: TextField(
                                  controller: _controller,
                                ),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text("Confirmar"),
                              onPressed: (){
                                setState(() {
                                  // todoList[index].title=  _controller.text;
                                  Navigator.of(context).pop();
                                });
                              }
                            ),
                            RaisedButton(
                              child: new Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                    },
                  );
                } else if(direction == DismissDirection.startToEnd){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Swipe to right")));
                  setState(() {
                    // todoList.removeAt(index);
                    print(todoList);
                  });
                }

                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text("${item.title} Removido")));
              },
              child: ListTile(
                title: Text(snapshot.data[index].title),
                onTap: (){
                  setState(() {
                    snapshot.data[index].isCheck = !snapshot.data[index].isCheck;
                  });
                  
                },
                trailing: Checkbox(
                  value: (snapshot.data[index]==null)?snapshot.data[index].isCheck:false,
                  onChanged: null,
                )
              )
            );
            
            
          },
        );
}
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        onPressed: (){
        showDialog(
              context: context,
              builder:  (BuildContext context) {
                
                  return AlertDialog(
                    title: new Text("Adicione um item"),
                    content: TextField(
                            controller: _controllerActionButton,
                          ),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text("Confirmar"),
                        onPressed: add,
                      ),
                      RaisedButton(
                        child: new Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
              },
            );
      }),
    );
  }
}
