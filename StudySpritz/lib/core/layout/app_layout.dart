import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("StudySpritz"),
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}