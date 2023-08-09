import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: "Digital Business Card",
      color: Colors.indigo,
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to Digital Business Card"),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Connect with others",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => context.go("/connect"),
                  child: const Text("View"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
