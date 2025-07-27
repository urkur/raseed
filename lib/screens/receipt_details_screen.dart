import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raseed/constants.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  final File image;

  const ReceiptDetailsScreen({super.key, required this.image});

  @override
  State<ReceiptDetailsScreen> createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
  String? _responseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  Future<void> _uploadImage() async {
    try {
      final imageBytes = await widget.image.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final url = Uri.parse(ApiConstants.chatUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": "Hi",
          "files": [base64Image],
          "session_id": "test_session_123",
          "user_id": "test_user_456"
        }),
      );

      if (mounted) {
        setState(() {
          _responseData = response.body;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _responseData = "An error occurred: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Details'),
      ),
      body: Column(
        children: [
          // Image Container
          Container(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.file(widget.image, fit: BoxFit.cover),
          ),
          // Details and Action Button
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scrollable Text Section
                  Expanded(
                    flex: 2,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Text(_responseData ?? 'No response'),
                          ),
                  ),
                  const SizedBox(width: 16.0),
                  // 'Add to Wallet' Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement 'Add to Wallet' functionality
                      },
                      child: const Text('Add to Wallet'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}