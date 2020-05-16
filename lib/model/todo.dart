class Todo {
  String title;
  bool isCheck;

  Todo({this.title, this.isCheck});

  Todo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isCheck'] = this.isCheck;
    return data;
  }
}
