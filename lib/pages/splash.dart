import 'package:flutter/material.dart';
import 'package:translation_app/components/eclipse.dart';

void main() => runApp(const SplashPage());

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10.0).animate(_controller);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/appLayout');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Opacity(
              opacity: 0.5,
              child: EllipseWidget(
                size: Size(446, 410),
                color: Color.fromRGBO(0, 122, 245, 1),
                left: -205,
                top: -151,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.5,
              child: EllipseWidget(
                size: Size(446, 410),
                color: Color.fromRGBO(242, 135, 57, 1),
                left: 157,
                top: -248,
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.translate, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'TRANSLATE ON THE GO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Stack(
              alignment: Alignment.center, // Căn giữa theo chiều ngang
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: MediaQuery.of(context).size.width / 2 -
                          25 +
                          _animation.value,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Colors.blueAccent, // Màu sắc hình tròn đầu tiên
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: MediaQuery.of(context).size.width / 2 -
                          25 -
                          _animation.value,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .lightBlueAccent, // Màu sắc hình tròn thứ hai
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
