import 'package:flutter/material.dart';
import 'dart:convert';

class CategorizedExpensesScreen extends StatefulWidget {
  const CategorizedExpensesScreen({super.key});

  @override
  State<CategorizedExpensesScreen> createState() => _CategorizedExpensesScreenState();
}

class _CategorizedExpensesScreenState extends State<CategorizedExpensesScreen> {
  Map<String, dynamic> _receiptData = {};
  Map<String, double> _categoryTotals = {};

  @override
  void initState() {
    super.initState();
    _loadReceiptData();
  }

  Future<void> _loadReceiptData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/receipt_data.json");
    setState(() {
      _receiptData = json.decode(data);
      _calculateCategoryTotals();
    });
  }

  void _calculateCategoryTotals() {
    Map<String, double> categoryTotals = {};
    for (var item in _receiptData['items']) {
      String category = _getCategoryForItem(item['name']);
      double price = double.parse(item['price']);
      categoryTotals[category] = (categoryTotals[category] ?? 0) + price;
    }
    setState(() {
      _categoryTotals = categoryTotals;
    });
  }

  String _getCategoryForItem(String itemName) {
    if (itemName.toLowerCase().contains('chx') || itemName.toLowerCase().contains('polpat')) {
      return 'Groceries';
    }
    if (itemName.toLowerCase().contains('spoon') || itemName.toLowerCase().contains('glass')) {
      return 'Utensils';
    }
    if (itemName.toLowerCase().contains('duster') || itemName.toLowerCase().contains('scrub')) {
      return 'Household';
    }
    return 'Other';
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Utensils':
        return Icons.local_dining;
      case 'Household':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorized Expenses'),
      ),
      body: _receiptData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              children: _categoryTotals.entries.map((entry) {
                return _buildCategoryCard(
                  icon: _getIconForCategory(entry.key),
                  category: entry.key,
                  amount: '₹${entry.value.toStringAsFixed(2)}',
                  progress: entry.value / double.parse(_receiptData['total_amount']),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String category,
    required String amount,
    required double progress,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0),
            const SizedBox(height: 8.0),
            Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Text(amount),
            const SizedBox(height: 8.0),
            CircularProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}