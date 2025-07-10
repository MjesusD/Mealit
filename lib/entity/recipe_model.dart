import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String steps;
  final List<String> ingredients;
  final String imagePath;
  final String listName;

  Recipe({
    String? id,
    required this.name,
    required this.description,
    required this.steps,
    required this.ingredients,
    required this.imagePath,
    required this.listName,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'steps': steps,
        'ingredients': ingredients,
        'imagePath': imagePath,
        'listName': listName,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        steps: json['steps'],
        ingredients: List<String>.from(json['ingredients']),
        imagePath: json['imagePath'],
        listName: json['listName'],
      );
}
