import 'package:flutter/material.dart';
import '../widgets/procurement_menu_widget.dart';

class HPSMenuScreen extends StatelessWidget {
  const HPSMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementMenuWidget(
      serviceName: 'HPS',
      serviceKey: 'hps',
    );
  }
}
