import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar_recipe/view_model/auth_view_model.dart';
import 'package:cookie_jar_recipe/constant/text_style.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
void dispose() {
  _usernameController.dispose();
  _passwordController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    final auth = context.watch<AuthViewModel>();
    
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Image.asset(
  'asset/cookie_logo.png',
  height: 100,
  errorBuilder: (_, __, ___) => const Icon(Icons.cookie, size: 80),
),

const SizedBox(height: 8),
Text(
  'Cookie Jar Recipes',
  style: AppTextStyles.appBarTitle.copyWith(fontSize: 24),
),
const SizedBox(height: 24),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username',
              border: OutlineInputBorder()
              
              ),
              textInputAction: TextInputAction.next
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password',
              border: OutlineInputBorder()
              ),
              obscureText: true,
             
            ),
            const SizedBox(height: 20),
           if (auth.error != null)
  Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
  ),
FilledButton(
  onPressed: () => context.read<AuthViewModel>().login(
        _usernameController.text,
        _passwordController.text,
      ),
  child: const Text('Login'),
),
          ],
        ),
      ),
    );
  }
}