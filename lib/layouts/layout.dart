import 'package:flutter/material.dart';
import 'package:translation_app/constants/languages.dart';
import 'package:translation_app/constants/pageTabs.dart';
import 'package:translation_app/database.dart';
import 'package:translation_app/pages/favorite.dart';
import 'package:translation_app/pages/history.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, PageTab? initPage});

  PageTab? get initPage => homePageTab("", languages[0], languages[1]);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  PageTab? _initPage;
  final List<PageTab> _pageTabs = [];

  @override
  void initState() {
    super.initState();

    _pageTabs.addAll([
      homePageTab("", languages[0], languages[1]),
      cameraPageTab(_navigateToHome),
      logoPageTab(),
    ]);

    _initPage = widget.initPage;
    _selectedIndex = _initPage!.key;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }

    if (_selectedIndex == index) return;

    (context as Element).markNeedsBuild();

    _setSelectedIndex(index);
  }

  void _navigateToHome(
      String sourceText, Language sourceLanguage, Language targetLanguage) {
    setState(() {
      _pageTabs[0] = homePageTab(sourceText, sourceLanguage, targetLanguage);
      _selectedIndex = 0;
    });
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(selectedIndex: _selectedIndex),
      body: IndexedStack(
        index: _selectedIndex == 3 || _selectedIndex == 4 ? 3 : _selectedIndex,
        children: [
          ..._pageTabs.map((tab) => tab.page),
          if (_selectedIndex == 3) const HistoryPage(),
          if (_selectedIndex == 4) const FavoritePage(),
        ],
      ),
      bottomNavigationBar: Container(
          height: 70,
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
                      label: 'Favorite',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.black,
                  showUnselectedLabels: true,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 26,
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

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa tất cả lịch sử?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                DBProvider.db.deleteAllTranslations();
                Navigator.of(context).pop();
              },
              child: const Text('Xóa tất cả'),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return AppBar(
          title: const Text('Translation App'),
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
          leading: null,
        );
      case 1:
        return AppBar(
          title: const Text('Camera'),
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
        );
      case 3:
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
                  _showClearAllDialog(context);
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
      case 4:
        return AppBar(
          backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favorite',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          automaticallyImplyLeading: false,
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
    return _buildAppBar(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
