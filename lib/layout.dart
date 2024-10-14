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
      appBar: _AppBar(selectedIndex: _selectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomNavigationBar(
                  backgroundColor: const Color.fromRGBO(255, 251, 254, 1),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.mic),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.camera),
                      label: 'Camera',
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 32,
                        height: 32,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
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
              GestureDetector(
                onTap: () {
                  // Handle tap event
                },
                child: const CircleAvatar(
                  radius: 26, // Adjust the radius as needed
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.translate,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;

  const _AppBar({required this.selectedIndex});

  PreferredSizeWidget _buildAppBar() {
    switch (selectedIndex) {
      case 0: // Home Page
        return AppBar(
          title: const Text('Translation App'),
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
          leading: null,
        );
      case 1: // Camera Page
        return AppBar(
          title: const Text('Camera'),
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings button
              },
            ),
          ],
        );
      case 3: // History Page
        return AppBar(
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  // Handle clear all action
                  print("Clear all history");
                },
                child: const Text(
                  'Clear all',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        );
      case 4: // Favorite Page
        return AppBar(
          title: const Text('Favorites'),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
        );
      default:
        return AppBar(
          title: const Text('Translation App'),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
