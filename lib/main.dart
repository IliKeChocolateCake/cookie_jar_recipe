
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model_adapter.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_repo.dart';
import 'package:cookie_jar_recipe/ui/pages/home.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_api.dart';
import 'package:cookie_jar_recipe/view_model/recipe_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_type_api.dart';
import 'package:cookie_jar_recipe/ui/pages/login_page.dart';
import 'package:cookie_jar_recipe/view_model/auth_view_model.dart';
import 'package:cookie_jar_recipe/data/repository/auth.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();   // required before async work

  await Hive.initFlutter();                    // 1. start Hive
  Hive.registerAdapter(RecipeModelAdapter());  // 2. register the adapter
  await Hive.openBox<RecipeModel>('recipes'); 
  final settings = await Hive.openBox('settings');

if (settings.get('seeded', defaultValue: false) == false) {
  final samples = await RecipeApi().load();
  await RecipeRepository(Hive.box<RecipeModel>('recipes')).seed(samples);
  await settings.put('seeded', true);
  debugPrint('Seeded ${samples.length} recipes');
}
 runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RecipeListViewModel(
          RecipeRepository(Hive.box<RecipeModel>('recipes')),
          RecipeTypeApi(),
        )..load(),
      ),
      ChangeNotifierProvider(
    create: (_) => AuthViewModel(AuthRepository())..init(),
  ),
    ],
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CookieJarRecipes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const AuthGate(),   // the gate lives inside MaterialApp
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    if (auth.isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isLoggedIn
        ? const MyHomePage(title: 'Cookie Jar Recipes')
        : const LoginPage();
  }
}

