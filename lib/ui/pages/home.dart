import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar_recipe/view_model/recipe_list_view_model.dart';
import 'package:cookie_jar_recipe/ui/widget/empty_state.dart';
import 'package:cookie_jar_recipe/ui/widget/recipe_card.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecipeListViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          TextButton.icon(

            label: Text('Last synced: ${vm.lastSyncedLabel}', style: const TextStyle(color: Colors.white)),
            icon: const Icon(Icons.refresh),
            onPressed: vm.load,

          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _FilterChips(vm: vm),
                Expanded(child: _RecipeList(vm: vm)),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: open the recipe form page
        },
        tooltip: 'Add recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final RecipeListViewModel vm;
  const _FilterChips({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: vm.types.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('All'),
              selected: vm.selectedTypeId == null,
              onSelected: (_) => vm.setFilter(null),
            );
          }
          final type = vm.types[index - 1];
          return ChoiceChip(
            label: Text(type.name),
            selected: vm.selectedTypeId == type.id,
            onSelected: (_) => vm.setFilter(type.id),
          );
        },
      ),
    );
  }
}

class _RecipeList extends StatelessWidget {
  final RecipeListViewModel vm;
  const _RecipeList({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.recipes.isEmpty) {
      return vm.isJarEmpty
          ? EmptyState(
              icon: Icons.cookie,
              message: 'Your cookie jar is empty.\nAdd your first recipe!',
              actionLabel: 'Add recipe',
              onAction: () {
                // TODO: open the recipe form page
              },
            )
          : const EmptyState(
              icon: Icons.search_off,
              message: 'No recipes in this category yet.',
            );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88), // keeps the FAB off the last card
      itemCount: vm.recipes.length,
      itemBuilder: (context, index) {
        final recipe = vm.recipes[index];
        return RecipeCard(
          recipe: recipe,
          typeName: vm.typeName(recipe.typeId),
          onTap: () {
            // TODO: open the detail page
          },
        );
      },
    );
  }
}