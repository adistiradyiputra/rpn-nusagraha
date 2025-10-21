import 'package:flutter/material.dart';
import '../widgets/procurement_history_widget.dart';

class HPSHistoryScreen extends StatelessWidget {
  const HPSHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementHistoryWidget(
      serviceName: 'HPS',
      serviceKey: 'hps',
    );
  }
}
