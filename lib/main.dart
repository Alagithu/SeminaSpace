import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/profilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: Login(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentPage = 0;

  final List<Widget> _pages = [HomePage(), ProfilePage()];

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getPageColor(int index) {
    switch (index) {
      case 0:
        return Colors.purple.shade50;
      case 1:
        return Colors.pink.shade50;
      case 2:
        return Colors.blue.shade50;
      case 3:
        return Colors.green.shade50;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SeminaSpace",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: _getPageColor(_currentPage),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(index: _currentPage, children: _pages),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentPage,
        backgroundColor: _getPageColor(_currentPage),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined, color: Colors.purple),
            label: "Home",
          ),

          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity, color: Colors.purple),
            label: "Profile",
          ),
        ],
        onTap: _onPageChanged,
      ),
    );
  }
}
