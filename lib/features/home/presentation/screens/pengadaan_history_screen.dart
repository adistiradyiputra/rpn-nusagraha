import 'package:flutter/material.dart';
import '../widgets/procurement_history_widget.dart';

class PengadaanHistoryScreen extends StatelessWidget {
  const PengadaanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementHistoryWidget(
      serviceName: 'Pengadaan',
      serviceKey: 'pengadaan',
    );
  }
}
