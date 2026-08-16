import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeFetchResult {
  final List<Recipe> recipes;
  final int total;

  RecipeFetchResult({required this.recipes, required this.total});
}

class RecipeRepository {
  final ApiService _apiService = ApiService();

  Future<RecipeFetchResult> getRecipes({
    required int page,
    required int limit,
  }) async {
    final skip = page * limit;
    final data = await _apiService.fetchRecipes(skip: skip, limit: limit);

    final List<dynamic> recipeListJson = data['recipes'] ?? [];
    final int total = data['total'] ?? 0;

    final recipes = recipeListJson
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();

    return RecipeFetchResult(recipes: recipes, total: total);
  }
}