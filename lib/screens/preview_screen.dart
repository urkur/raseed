import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;

  const PreviewScreen({super.key, required this.imageFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('images/${DateTime.now()}.jpg');
      await imagesRef.putFile(widget.imageFile);
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Image upload failed due to network error. Please try again. ${e.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.file(widget.imageFile),
            ),
          ),
          if (_isUploading)
            const CircularProgressIndicator()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                IconButton(
                  onPressed: _uploadImage,
                  icon: const Icon(Icons.check, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
