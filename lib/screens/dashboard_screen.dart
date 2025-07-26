import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:raseed/screens/transaction_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _receiptData = {};

  @override
  void initState() {
    super.initState();
    _loadReceiptData();
  }

  Future<void> _loadReceiptData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/receipt_data.json");
    setState(() {
      _receiptData = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: _receiptData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Summary Cards
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSummaryCard('Daily Spend', '₹25.50'),
                      _buildSummaryCard('Week-to-Date', '₹175.20'),
                      _buildSummaryCard('Month-to-Date', '₹${_receiptData["total_amount"]}'),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Spending Chart
                _buildSpendingChart(),
                const SizedBox(height: 24.0),

                // Information Panels
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                    );
                  },
                  child: _buildInfoPanel(
                    icon: Icons.receipt_long,
                    title: 'Recent Expenses',
                    subtitle: 'Last transaction: ₹${_receiptData["total_amount"]} at ${_receiptData["location"]}',
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInfoPanel(
                  icon: Icons.pie_chart,
                  title: 'Spending Breakdown',
                  subtitle: 'Top category: Groceries',
                ),
                const SizedBox(height: 16.0),
                _buildInfoPanel(
                  icon: Icons.warning_amber_rounded,
                  title: 'Budget Limit',
                  subtitle: 'You are approaching your budget limit for this month.',
                  backgroundColor: Colors.orange[100],
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryCard(String title, String amount) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(amount, style: const TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Spending Trends', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            // Placeholder for the chart
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('Chart Placeholder')),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('7d')),
                TextButton(onPressed: () {}, child: const Text('30d')),
                TextButton(onPressed: () {}, child: const Text('90d')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? backgroundColor,
  }) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
