class Note {
  int? id;
  String name;
  String body;
  String color;

  Note({
    required this.name,
    required this.body,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'body': this.body,
      'color': this.color,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      name: map['name'],
      body: map['body'],
      color: map['color'],
    );
  }
}
