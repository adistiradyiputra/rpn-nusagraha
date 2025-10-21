import 'package:flutter/material.dart';
import '../widgets/procurement_history_widget.dart';

class PPABHistoryScreen extends StatelessWidget {
  const PPABHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementHistoryWidget(
      serviceName: 'PPAB',
      serviceKey: 'ppab',
    );
  }
}
