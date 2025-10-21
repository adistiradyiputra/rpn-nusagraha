import 'package:flutter/material.dart';
import '../widgets/procurement_menu_widget.dart';

class PengadaanMenuScreen extends StatelessWidget {
  const PengadaanMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementMenuWidget(
      serviceName: 'Pengadaan',
      serviceKey: 'pengadaan',
    );
  }
}
