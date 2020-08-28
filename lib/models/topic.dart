import 'package:quizapp/models/quiz.dart';

class Topic {
  String id;
  String title;
  String description;
  String img;
  List<Quiz> quizzes;

  Topic({this.id, this.title, this.description, this.img, this.quizzes});

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      img: data['img'] ?? 'default.png',
      quizzes: (data['quizzes'] as List ?? [])
          .map((m) => Quiz.fromMap(m))
          .toList(), //data['quizzes'],
    );
  }
}
