import 'package:flutter/material.dart';
import 'dart:convert';

class BudgetAnalysisScreen extends StatefulWidget {
  const BudgetAnalysisScreen({super.key});

  @override
  State<BudgetAnalysisScreen> createState() => _BudgetAnalysisScreenState();
}

class _BudgetAnalysisScreenState extends State<BudgetAnalysisScreen> {
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
        title: const Text('Budget Analysis'),
      ),
      body: _receiptData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // View Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('By Amount')),
                      const SizedBox(width: 16.0),
                      OutlinedButton(onPressed: () {}, child: const Text('By Frequency')),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Budget Donut Chart
                  _buildDonutChart(),
                  const SizedBox(height: 24.0),

                  // Suggestion Card
                  _buildSuggestionCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: double.parse(_receiptData['total_amount']) / 5000, // Example budget of 5000
              strokeWidth: 20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total Spent', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${_receiptData["total_amount"]}', style: const TextStyle(fontSize: 24.0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.savings, size: 40.0, color: Colors.green),
        title: const Text('Suggestion', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('You have spent a significant amount on your last purchase. Consider reviewing your budget.'),
      ),
    );
  }
}