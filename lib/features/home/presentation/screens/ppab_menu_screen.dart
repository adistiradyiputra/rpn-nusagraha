import 'package:flutter/material.dart';
import '../widgets/procurement_menu_widget.dart';

class PPABMenuScreen extends StatelessWidget {
  const PPABMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementMenuWidget(
      serviceName: 'PPAB',
      serviceKey: 'ppab',
    );
  }
}
