class Todo {
  String title;
  bool isCheck;
  int id;

  Todo({this.title, this.isCheck, this.id});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['title'] = this.title;
    data['isCheck'] = this.isCheck;
    return data;
  }
}
