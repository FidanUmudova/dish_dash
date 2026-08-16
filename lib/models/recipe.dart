class Recipe {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String cuisine;
  final List ingredients;
  final List instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.cuisine,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map json) {
    return Recipe(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Untitled Recipe',
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      cuisine: json['cuisine'] as String? ?? 'General',
      ingredients: (json['ingredients'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      instructions: (json['instructions'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}