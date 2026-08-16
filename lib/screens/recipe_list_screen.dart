import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../repositories/recipe_repository.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeRepository _repository = RecipeRepository();
  final ScrollController _scrollController = ScrollController();

  final List<dynamic> _recipes = [];
  final int _limit = 10;

  int _page = 1;
  int _totalRecipes = 0;
  bool _isLoading = true;
  bool _isFetchingMore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _page = 1; // Səhifə 1-dən başlayır
    });

    try {
      final result = await _repository.getRecipes(page: 1, limit: _limit);
      setState(() {
        _recipes.clear();
        _recipes.addAll(result.recipes);
        _totalRecipes = result.total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Siyahının sonuna 100 piksel qalmış yeni məlumatları tetiklə
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 100) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    // Əgər artıq yüklənirsə və ya bütün reseptlər çəkilibsə dayandır
    if (_isFetchingMore || (_totalRecipes > 0 && _recipes.length >= _totalRecipes)) {
      return;
    }

    setState(() => _isFetchingMore = true);

    try {
      final nextPage = _page + 1;
      final result = await _repository.getRecipes(page: nextPage, limit: _limit);

      setState(() {
        _page = nextPage;
        _recipes.addAll(result.recipes);
        _isFetchingMore = false;
      });
    } catch (e) {
      debugPrint("Pagination xətası: $e");
      setState(() => _isFetchingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadInitialData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_recipes.isEmpty) {
      return const Center(child: Text('No recipes available.'));
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _recipes.length + (_isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _recipes.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final recipe = _recipes[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: recipe.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              ),
            ),
            title: Text(
              recipe.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${recipe.cuisine} • ⭐ ${recipe.rating}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}