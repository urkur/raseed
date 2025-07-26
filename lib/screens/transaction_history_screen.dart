import 'package:flutter/material.dart';
import 'dart:convert';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
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
        title: const Text('Transaction History'),
      ),
      body: _receiptData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _receiptData['items'].length,
              itemBuilder: (context, index) {
                var item = _receiptData['items'][index];
                return ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text(item['name']),
                  trailing: Text('₹${item["price"]}'),
                );
              },
            ),
    );
  }
}
