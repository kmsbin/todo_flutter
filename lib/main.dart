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
    final db = DatabaseHelper.instance;
      List<Map <String, dynamic>> allRows = [];
      allRows = await db.queryAllRows();

      return List.generate(allRows.length, (i) {
        print(allRows);
        return Todo(
          id: allRows[i]['_id'],
          title: allRows[i]['title'],
          isCheck: allRows[i]['done'],
        );
      });
  }
  List<Todo> todoList;
  _setTodo (value){
    todoList = value;
    print(" lista -------- $todoList");
  } 
  _HomeState() {
    _query().then((value) {
      setState((){
      _setTodo(value);
      });
    });

  }
  _delete(int id) async{
    final db = DatabaseHelper.instance;
    await db.delete(id);
    // .then((value) {
    //   print(value);
    //   setState(() {
    //     _query().then((value) {
    //       setState(() {
    //         _setTodo(value);
    //       });
    //       });
    //   });
    // });
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
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: (todoList==null)?0:todoList.length,
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
                    _delete(todoList[index].id);
                }

                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text("${item.title} Removido")));
              },
              child: ListTile(
                title: Text(todoList[index].title),
                onTap: (){
                  setState(() {
                    todoList[index].isCheck = !todoList[index].isCheck;
                  });
                  
                },
                trailing: Checkbox(
                  value: (todoList[index]==null)?todoList[index].isCheck:false,
                  onChanged: null,
                )
              )
            );
            
            
          },
        )));
}
        
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add_circle),
//         onPressed: (){
//         showDialog(
//               context: context,
//               builder:  (BuildContext context) {
                
//                   return AlertDialog(
//                     title: new Text("Adicione um item"),
//                     content: TextField(
//                             controller: _controllerActionButton,
//                           ),
//                     actions: <Widget>[
//                       RaisedButton(
//                         child: Text("Confirmar"),
//                         onPressed: add,
//                       ),
//                       RaisedButton(
//                         child: new Text("Cancelar"),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//               },
//             );
//       }),
//     );
//   }
  }
