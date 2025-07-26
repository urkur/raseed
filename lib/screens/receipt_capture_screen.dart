import 'package:flutter/material.dart';

class ReceiptCaptureScreen extends StatelessWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Capture'),
      ),
      body: Stack(
        children: [
          // Placeholder for receipt image
          Center(
            child: Image.asset('assets/WhatsApp Image 2025-07-18 at 15.11.27.jpeg'), // Add a placeholder image to your assets
          ),
          // Overlay with extracted details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Extracted Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    _buildDetailRow('Vendor', 'STORE'),
                    _buildDetailRow('Date', '04/22/2024'),
                    _buildDetailRow('Amount', '₹17.27'),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CONFIRM'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
