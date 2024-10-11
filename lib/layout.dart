import 'package:flutter/material.dart';
import 'package:translation_app/camera.dart';
import 'package:translation_app/favorite.dart';
import 'package:translation_app/history.dart';
import 'package:translation_app/home.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  // List of pages corresponding to the bottom navigation items
  final List<Widget> _pages = [
    const HomePage(),
    const CameraPage(),
    const SizedBox(),
    const HistoryPage(),
    const FavoritePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }

    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation App'),
        backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
        titleTextStyle: const TextStyle(color: Colors.white),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: 'Chat',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  // Không làm gì ở đây
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.translate, color: Colors.white),
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favourite',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: _onItemTapped, // Sử dụng phương thức cập nhật
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
