import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar_recipe/ui/pages/recipe_form_page.dart';
import 'package:cookie_jar_recipe/view_model/recipe_list_view_model.dart';
import 'package:cookie_jar_recipe/ui/widget/recipe_image.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeId;
  const RecipeDetailPage({super.key, required this.recipeId});

  Future<void> _confirmDelete(BuildContext context, String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('"$title" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<RecipeListViewModel>().delete(recipeId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecipeListViewModel>();
    final recipe = vm.recipeById(recipeId);

    // deleted or missing: show nothing instead of crashing
    if (recipe == null) return const Scaffold(body: SizedBox.shrink());

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeFormPage(recipe: recipe), // edit mode
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, recipe.title),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RecipeImage(path: recipe.imagePath),
                ),
              ),
              const SizedBox(height: 16),
              Chip(label: Text(vm.typeName(recipe.typeId))),
              const SizedBox(height: 16),
              Text('Ingredients', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final i in recipe.ingredients)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $i'),
                ),
              const SizedBox(height: 24),
              Text('Steps', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (int n = 0; n < recipe.steps.length; n++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${n + 1}. ${recipe.steps[n]}'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}