import 'package:admin_farmalider/pages/alerts/AlertsPage.dart';
import 'package:admin_farmalider/pages/billing/cart_page.dart';
import 'package:admin_farmalider/pages/edit/list_screen.dart';
import 'package:admin_farmalider/pages/inventory/InventoryPage.dart';
import 'package:admin_farmalider/widgets/nav_bottom.dart' show BottomNavBar;

import 'package:flutter/material.dart';

void main() {
  runApp(const FarmaciaApp());
}

class FarmaciaApp extends StatefulWidget {
  const FarmaciaApp({Key? key}) : super(key: key);

  @override
  State<FarmaciaApp> createState() => _FarmaciaAppState();
}

class _FarmaciaAppState extends State<FarmaciaApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    InventoryPage(),
    AlertsPage(),
    ProductListScreen(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmacia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF9FFF9),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


