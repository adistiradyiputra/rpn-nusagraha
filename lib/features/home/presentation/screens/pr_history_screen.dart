import 'package:flutter/material.dart';
import '../widgets/procurement_history_widget.dart';

class PRHistoryScreen extends StatelessWidget {
  const PRHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementHistoryWidget(
      serviceName: 'PR',
      serviceKey: 'pr',
    );
  }
}
