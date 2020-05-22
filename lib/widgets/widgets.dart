import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';

class Alertdialog extends StatefulWidget {
  Function setTodo;
  Function query;
  Function update;
  int index;
  Alertdialog({
    Key key,
    @required this.index,
    @required this.update,
    @required this.setTodo,
    @required this.query,
    @required this.todoList,
  }) : super(key: key);

  final List<Todo> todoList;

  @override
  _AlertDialogState createState() => _AlertDialogState();
}

class _AlertDialogState extends State<Alertdialog> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Altere o Item"),
      content: TextField(
        decoration: InputDecoration(
          labelText: "Crie um novo item",
          fillColor: Colors.black38,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: new BorderSide(),
          ),
        ),
        controller: _controller,
      ),
      actions: <Widget>[
        RaisedButton(
            child: Text("Confirmar"),
            onPressed: () {
              print("o Texto é -------$_controller");
              this.widget.update(
                  title: _controller.text,
                  id: widget.todoList[this.widget.index].id,
                  isChecked: this.widget.todoList[this.widget.index].isCheck);
              Navigator.of(context).pop();
            }),
        RaisedButton(
          child: new Text("Cancelar"),
          onPressed: () {
            this.widget.query().then((value) {
              this.widget.setTodo(value);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AlertDialogAdd extends StatelessWidget {
  Function add;
  AlertDialogAdd({
    this.add,
    Key key,
  }) : super(key: key);


  TextEditingController _controllerActionButton = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Adicione um item"),
      content: TextField(
        controller: _controllerActionButton,
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text("Confirmar"),
          onPressed: () {
            add(
                title: _controllerActionButton.text,
                isChecked: false
              );
          },
        ),
        RaisedButton(
          child: new Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


class CardList extends StatefulWidget {
  CardList({
    Key key,
    @required this.index,
    @required this.todoList,
  }) : super(key: key);

  int index;
  List<Todo> todoList;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(color: Colors.black12),
        child: ListTile(
          title: Text(widget.todoList[widget.index].title),
          onTap: () {
            setState(() {
              widget.todoList[widget.index].isCheck =
                  !widget.todoList[widget.index].isCheck;
            });
          },
          trailing: Checkbox(
            value: widget.todoList[widget.index].isCheck,
            onChanged: null,
          )
        )
      )
    );
  }
}

