import 'package:flutter/material.dart';

class ParcelCameraScreen extends StatelessWidget {
  const ParcelCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proof of Delivery')),
      body: const Center(
        child: Text('Camera View'),
      ),
    );
  }
}
