import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';
import 'package:cookie_jar_recipe/view_model/recipe_list_view_model.dart';

class RecipeFormPage extends StatefulWidget {
  final RecipeModel? recipe; // null = create, set = edit
  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _ingredientsCtrl;
  late final TextEditingController _stepsCtrl;
  int? _typeId;
  String? _imagePath;

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    _titleCtrl = TextEditingController(text: r?.title ?? '');
    _ingredientsCtrl = TextEditingController(text: r?.ingredients.join('\n') ?? '');
    _stepsCtrl = TextEditingController(text: r?.steps.join('\n') ?? '');
    _typeId = r?.typeId;
    _imagePath = r?.imagePath;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _ingredientsCtrl.dispose();
    _stepsCtrl.dispose();
    super.dispose();
  }

  List<String> _lines(String text) =>
      text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final recipe = RecipeModel(
      id: widget.recipe?.id ?? const Uuid().v4(), // reuse id when editing
      title: _titleCtrl.text.trim(),
      typeId: _typeId!,
      imagePath: _imagePath,
      ingredients: _lines(_ingredientsCtrl.text),
      steps: _lines(_stepsCtrl.text),
    );

    await context.read<RecipeListViewModel>().save(recipe);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecipeListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'New Recipe'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _typeId,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final t in vm.types)
                      DropdownMenuItem(value: t.id, child: Text(t.name)),
                  ],
                  onChanged: (v) => setState(() => _typeId = v),
                  validator: (v) => v == null ? 'Choose a type' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ingredientsCtrl,
                  minLines: 4,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients (one per line)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _lines(v ?? '').isEmpty
                      ? 'Add at least one ingredient'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stepsCtrl,
                  minLines: 4,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Steps (one per line)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      _lines(v ?? '').isEmpty ? 'Add at least one step' : null,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save changes' : 'Add recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}