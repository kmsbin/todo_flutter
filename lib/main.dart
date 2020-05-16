import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';

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
    var todoList = new List<Todo>();
  _HomeState(){
    todoList = [];
    todoList.add(Todo(title: "comprar cleitin", isCheck: false));
    todoList.add(Todo(title: "comprar wlejgt", isCheck: false));
    todoList.add(Todo(title: "comprar çwg", isCheck: false));
    todoList.add(Todo(title: "comprar ]ekgp", isCheck: false));
    todoList.add(Todo(title: "comprar dmnefgwpnycex", isCheck: false));


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
          itemCount: todoList.length,
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
                                  todoList[index].title=  _controller.text;
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
                    todoList.removeAt(index);
                    print(todoList);
                  });
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
                  value: todoList[index].isCheck,
                  onChanged: null,
                )
              )
            );
            
            
          },
        ),
      ),
    );
  }
}

