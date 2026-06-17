import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Home Screen"),

          ElevatedButton(
            onPressed: () => context.go('/library'),
            child: const Text("Go Library"),
          ),

          ElevatedButton(
            onPressed: () => context.go('/favorites'),
            child: const Text("Go Favorites"),
          ),
        ],
      ),
    );
  }
}