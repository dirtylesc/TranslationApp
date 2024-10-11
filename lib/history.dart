import 'package:flutter/material.dart';

void main() => runApp(const HistoryPage());

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('History Screen'),
      ),
    );
  }
}
