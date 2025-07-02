import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
      ),
      body: Center(
        child: Text('Ini halaman detail task.'),
      ),
    );
  }
} 