import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/approval_history_widget.dart';
import '../models/approval_history_models.dart';

class PengadaanApprovalHistoryScreen extends StatefulWidget {
  const PengadaanApprovalHistoryScreen({super.key});

  @override
  State<PengadaanApprovalHistoryScreen> createState() => _PengadaanApprovalHistoryScreenState();
}

class _PengadaanApprovalHistoryScreenState extends State<PengadaanApprovalHistoryScreen> {
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
          approvalTime: DateTime(2025, 9, 12, 11, 30, 15),
          number: '2158/PENGADAAN/010301/09/2025',
          description: 'Pembuat: Fitri Rahayu\nPerihal: CP 3 PENGADAAN V3 Proses Tender',
          item: 'Items: CP 3 PENGADAAN V3 Tender',
          total: 35000000,
          status: ApprovalStatus.approved,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Fitri Rahayu',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Fitri Rahayu',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Hendra Kurniawan',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
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
              role: 'Paraf',
              name: 'Rizki Pratama',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Dewi Kartika',
              isCompleted: true,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '2',
          approvalTime: DateTime(2025, 9, 11, 14, 15, 40),
          number: '2157/PENGADAAN/010301/09/2025',
          description: 'Pembuat: Rizki Pratama CP 2 PENGADAAN V2 Evaluasi Vendor',
          item: 'CP 2 PENGADAAN V2 Evaluasi;',
          total: 19000000,
          status: ApprovalStatus.inProgress,
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
              name: 'Sari Dewi',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Fajar Nugroho',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Eko Prasetyo',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Dina Wulandari',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Nina Rahayu',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Menyetujui',
              name: 'Dina Wulandari',
              isCompleted: false,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '3',
          approvalTime: DateTime(2025, 9, 10, 9, 20, 55),
          number: '2156/PENGADAAN/010301/09/2025',
          description: 'Pembuat: Dina Wulandari CP 1 PENGADAAN V1 Seleksi Penyedia',
          item: 'CP 1 PENGADAAN V1 Seleksi;',
          total: 42000000,
          status: ApprovalStatus.pending,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Dina Wulandari',
              isCompleted: true,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Dina Wulandari',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Nina Rahayu',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Eko Prasetyo',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Rizki Pratama',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Sari Dewi',
              isCompleted: false,
            ),
            ApprovalAuthority(
              role: 'Paraf',
              name: 'Fajar Nugroho',
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
          'Riwayat Approval Pengadaan',
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
            serviceName: 'Pengadaan',
            serviceType: 'pengadaan',
            items: _approvalItems,
          ),
        ),
      ),
    );
  }
}
