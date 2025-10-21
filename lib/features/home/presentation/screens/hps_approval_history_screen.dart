import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/approval_history_widget.dart';
import '../models/approval_history_models.dart';

class HPSApprovalHistoryScreen extends StatefulWidget {
  const HPSApprovalHistoryScreen({super.key});

  @override
  State<HPSApprovalHistoryScreen> createState() => _HPSApprovalHistoryScreenState();
}

class _HPSApprovalHistoryScreenState extends State<HPSApprovalHistoryScreen> {
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
          approvalTime: DateTime(2025, 9, 12, 10, 15, 30),
          number: '2158/HPS/010301/09/2025',
          description: 'Pembuat: Agus Setiawan\nPerihal: CP 3 HPS V3 Perhitungan Harga Satuan',
          item: 'Items: CP 3 HPS V3 Perhitungan',
          total: 22000000,
          status: ApprovalStatus.approved,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Agus Setiawan',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Agus Setiawan',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Rina Melati',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Joko Widodo',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Sri Mulyani',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Budi Santoso',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Ahmad Wijaya',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Sari Indah',
              isCompleted: true,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '2',
          approvalTime: DateTime(2025, 9, 11, 13, 20, 10),
          number: '2157/HPS/010301/09/2025',
          description: 'Pembuat: Tuti Handayani CP 2 HPS V2 Analisis Biaya Material',
          item: 'CP 2 HPS V2 Analisis;',
          total: 16000000,
          status: ApprovalStatus.inProgress,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Tuti Handayani',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Tuti Handayani',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Budi Santoso',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Sari Indah',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Ahmad Wijaya',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Dewi Kartika',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Sari Indah',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Dewi Kartika',
              isCompleted: false,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '3',
          approvalTime: DateTime(2025, 9, 10, 15, 45, 25),
          number: '2156/HPS/010301/09/2025',
          description: 'Pembuat: Eko Prasetyo CP 1 HPS V1 Estimasi Proyek',
          item: 'CP 1 HPS V1 Estimasi;',
          total: 28000000,
          status: ApprovalStatus.rejected,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Eko Prasetyo',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Eko Prasetyo',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Dewi Kartika',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Ahmad Wijaya',
              isRejected: true,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Budi Santoso',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Eko Prasetyo',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Maya Sari',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Rina Melati',
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
          'Riwayat Approval HPS',
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
            serviceName: 'HPS',
            serviceType: 'hps',
            items: _approvalItems,
          ),
        ),
      ),
    );
  }
}
