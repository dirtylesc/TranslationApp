import 'package:flutter/material.dart';

void main() => runApp(const FavoritePage());

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Favorite Screen'),
    ));
  }
}
