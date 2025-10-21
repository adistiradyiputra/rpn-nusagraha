import 'package:flutter/material.dart';
import '../widgets/procurement_menu_widget.dart';

class PRMenuScreen extends StatelessWidget {
  const PRMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProcurementMenuWidget(
      serviceName: 'PR & PPAB',
      serviceKey: 'pr',
    );
  }
}
