import 'package:flutter/material.dart';

void main() {
  runApp(const ERPAuthApp());
}

class ERPAuthApp extends StatelessWidget {
  const ERPAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ERP Platform',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Clean scaling for mobile
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Crisp Duolingo-styled branding icon
                  const Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: Color(0xFF58CC02), // Duolingo Green
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ERP Portal Authentication",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C3C3C),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Username Input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email or Username",
                      fillColor: const Color(0xFFF7F7F7),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1CB0F6), width: 2), // Duolingo Blue
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: const Color(0xFFF7F7F7),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1CB0F6), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Signature Tactile 3D Button
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF46A302), // Shadow layer
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4), // Reveals the 3D depth
                      decoration: BoxDecoration(
                        color: const Color(0xFF58CC02), // Top surface
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logging in user: ${_emailController.text}'),
                              backgroundColor: const Color(0xFF1CB0F6),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "LOG IN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}