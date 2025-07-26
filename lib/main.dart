import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raseed/screens/chat_screen.dart';
import 'package:raseed/screens/budget_analysis_screen.dart';
import 'package:raseed/screens/categorized_expenses_screen.dart';
import 'package:raseed/screens/dashboard_screen.dart';
import 'package:raseed/screens/receipt_capture_screen.dart';
import 'package:raseed/screens/settings_screen.dart';
import 'package:raseed/widgets/chat_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:raseed/screens/preview_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raseed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) => GlobalChatWrapper(child: child),
      import 'package:firebase_auth/firebase_auth.dart';
import 'package:raseed/screens/login_screen.dart';

// ...

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _showChatButton = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return widget.child!;
              },
            );
          },
        ),
        if (_showChatButton)
          Positioned(
            bottom: 90,
            right: 16,
            child: ChatWidget(navigatorKey: navigatorKey),
          ),
      ],
    );
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

  void _captureReceipt() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imageFile: File(image.path)),
        ),
      );
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
