import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  final File image;

  const ReceiptDetailsScreen({super.key, required this.image});

  @override
  State<ReceiptDetailsScreen> createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
  String? _extractedData;
  bool _isLoading = true;
  late FlutterGemma _gemma;

  @override
  void initState() {
    super.initState();
    _initializeAndRunGemma();
  }

  Future<void> _initializeAndRunGemma() async {
    try {
      _gemma = FlutterGemma();
      await _gemma.loadModel('assets/gemma-2b-it-cpu.bin');
      final imageBytes = await widget.image.readAsBytes();
      final prompt = "Extract the vendor name, date, and total amount from this receipt. Provide the output in JSON format.";
      final result = await _gemma.run(prompt, images: [imageBytes]);
      setState(() {
        _extractedData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _extractedData = "An error occurred: $e";
        _isLoading = false;
      });
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
                            child: Text(_extractedData ?? 'No data extracted'),
                          ),
                  ),
                  const SizedBox(width: 16.0),
                  // 'Add to Wallet' Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
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
