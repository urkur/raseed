import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:raseed/constants.dart';
import 'package:raseed/screens/chat_screen.dart';
import 'package:raseed/screens/budget_analysis_screen.dart';
import 'package:raseed/screens/categorized_expenses_screen.dart';
import 'package:raseed/screens/dashboard_screen.dart';
import 'package:raseed/screens/receipt_capture_screen.dart';
import 'package:raseed/screens/receipt_details_screen.dart';
import 'package:raseed/screens/settings_screen.dart';
import 'package:raseed/widgets/chat_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raseed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) => GlobalChatWrapper(child: child),
      home: const MainScreen(),
    );
  }
}

class GlobalChatWrapper extends StatefulWidget {
  final Widget? child;

  const GlobalChatWrapper({super.key, this.child});

  @override
  State<GlobalChatWrapper> createState() => _GlobalChatWrapperState();
}

class _GlobalChatWrapperState extends State<GlobalChatWrapper> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _showChatButton = true;

  void _updateChatButtonVisibility(Route<dynamic> route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final routeName = route.settings.name;
      final shouldShow = routeName != 'chat';
      if (_showChatButton != shouldShow) {
        setState(() {
          _showChatButton = shouldShow;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case 'chat':
              page = const ChatScreen();
              break;
            case '/':
            default:
              page = widget.child!;
              break;
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
        observers: [SimpleRouteObserver(onNavigate: _updateChatButtonVisibility)],
      ),
      floatingActionButton: _showChatButton
          ? ChatWidget(
              onPressed: () {
                _navigatorKey.currentState?.pushNamed('chat');
              },
            )
          : null,
    );
  }
}

class SimpleRouteObserver extends NavigatorObserver {
  final Function(Route<dynamic>) onNavigate;

  SimpleRouteObserver({required this.onNavigate});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigate(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      onNavigate(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      onNavigate(newRoute);
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    CategorizedExpensesScreen(),
    BudgetAnalysisScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _captureReceipt() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        if (!mounted) return;
        Fluttertoast.showToast(msg: "No image selected");
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptDetailsScreen(
            image: File(image.path),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(msg: "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureReceipt,
        tooltip: 'Capture Receipt',
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}