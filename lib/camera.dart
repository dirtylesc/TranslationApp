import 'package:flutter/material.dart';

void main() => runApp(const CameraPage());

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Camera Screen'),
    ));
  }
}
