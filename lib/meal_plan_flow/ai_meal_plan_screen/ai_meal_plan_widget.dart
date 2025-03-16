import 'package:flutter/material.dart';

class AIMealPlanWidget extends StatelessWidget {
  const AIMealPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thực đơn AI"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildAIMealPlanUI(),
    );
  }

  Widget _buildAIMealPlanUI() {
    // UI hiển thị danh sách thực đơn mẫu
    return Center(
      child: Text("Danh sách thực đơn AI sẽ hiển thị ở đây"),
    );
  }
}
