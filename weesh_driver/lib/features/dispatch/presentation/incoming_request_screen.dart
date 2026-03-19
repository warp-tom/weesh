import 'package:flutter/material.dart';

class IncomingRequestScreen extends StatelessWidget {
  final String weeshId;
  const IncomingRequestScreen({super.key, required this.weeshId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Request')),
      body: Center(
        child: Text('Incoming Request $weeshId'),
      ),
    );
  }
}
