import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/approval_history_widget.dart';
import '../models/approval_history_models.dart';

class PPABApprovalHistoryScreen extends StatefulWidget {
  const PPABApprovalHistoryScreen({super.key});

  @override
  State<PPABApprovalHistoryScreen> createState() => _PPABApprovalHistoryScreenState();
}

class _PPABApprovalHistoryScreenState extends State<PPABApprovalHistoryScreen> {
  List<ApprovalHistoryItem> _approvalItems = [];

  @override
  void initState() {
    super.initState();
    _loadApprovalHistory();
  }

  void _loadApprovalHistory() {
    // Sample data - replace with actual API call
    setState(() {
      _approvalItems = [
        ApprovalHistoryItem(
          id: '1',
          approvalTime: DateTime(2025, 9, 12, 9, 20, 5),
          number: '2158/PPAB/010301/09/2025',
          description: 'Pembuat: Andi Susanto\nPerihal: CP 3 PPAB V3 Analisis Biaya',
          item: 'Items: CP 3 PPAB V3 Analisis',
          total: 18000000,
          status: ApprovalStatus.approved,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Andi Susanto',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Andi Susanto',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Lisa Permata',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Hendra Kurniawan',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Maya Sari',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Bambang Sutrisno',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Eko Prasetyo',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Fajar Nugroho',
              isCompleted: true,
            ),
          ],
        ),
        
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientBlue,
                AppColors.navyBlue,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat Approval PPAB',
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: ApprovalHistoryWidget(
            serviceName: 'PPAB',
            serviceType: 'ppab',
            items: _approvalItems,
          ),
        ),
      ),
    );
  }
}
