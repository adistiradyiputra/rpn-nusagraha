import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/approval_history_widget.dart';
import '../models/approval_history_models.dart';

class PRApprovalHistoryScreen extends StatefulWidget {
  const PRApprovalHistoryScreen({super.key});

  @override
  State<PRApprovalHistoryScreen> createState() => _PRApprovalHistoryScreenState();
}

class _PRApprovalHistoryScreenState extends State<PRApprovalHistoryScreen> {
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
          approvalTime: DateTime(2025, 9, 12, 8, 15, 2),
          number: '2158/PR/010301/09/2025',
          description: 'Pembuat: Tri Aditya Darmadi\nPerihal: CP 3 PR V3 Pengeluaran Penerimaan',
          item: 'Items: CP 3 PR V3 Pengeluaran',
          total: 20000000,
          status: ApprovalStatus.approved,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Tri Aditya Darmadi',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 12, 8, 15, 2),
              actionTime: DateTime(2025, 9, 12, 8, 15, 16),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Tri Aditya Darmadi',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 12, 8, 15, 16),
              actionTime: DateTime(2025, 9, 12, 8, 15, 34),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Tri Aditya Darmadi',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 12, 8, 15, 34),
              actionTime: DateTime(2025, 9, 12, 8, 16, 12),
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Zulfikri Dahlan Lubis',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 12, 8, 16, 12),
              actionTime: DateTime(2025, 9, 12, 8, 21, 1),
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Yuni Lestari',
              isCompleted: false,
              receivedTime: DateTime(2025, 9, 12, 8, 20, 55),
              actionTime: null,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Rio Rianto',
              isCompleted: false,
              receivedTime: DateTime(2025, 9, 12, 8, 20, 58),
              actionTime: null,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '2',
          approvalTime: DateTime(2025, 9, 11, 14, 30, 15),
          number: '2157/PR/010301/09/2025',
          description:'Pembuat: John Doe\nPerihal: CP 3 PR V3 Pengeluaran Penerimaan',
          item: 'CP 2 PR V2 Pembelian;',
          total: 15000000,
          status: ApprovalStatus.inProgress,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Siti Nurhaliza',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Siti Nurhaliza',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Ahmad Wijaya',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Budi Santoso',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Dewi Kartika',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Ahmad Wijaya',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Budi Santoso',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Eko Prasetyo',
              isCompleted: false,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '3',
          approvalTime: DateTime(2025, 9, 10, 10, 45, 30),
          number: '2156/PR/010301/09/2025',
          description: 'Pembuat: Drogba \nPerihal: CP 3 PR V3 Pengeluaran Penerimaan',
          item: 'CP 1 PR V1 Perbaikan;',
          total: 25000000,
          status: ApprovalStatus.rejected,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Rizki Pratama',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Rizki Pratama',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Eko Prasetyo',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Sari Indah',
              isRejected: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Bambang Sutrisno',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Eko Prasetyo',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Sari Indah',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Maya Sari',
              isCompleted: false,
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
          'Riwayat Approval PR & PPAB',
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
            serviceName: 'PR',
            serviceType: 'pr',
            items: _approvalItems,
          ),
        ),
      ),
    );
  }
}
