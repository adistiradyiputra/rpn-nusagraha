import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/approval_history_models.dart';
import 'approval_content_sections.dart';
import 'approval_status_widgets.dart';
import 'document_action_buttons.dart';
import '../utils/approval_utils.dart';

class ProcurementHistoryWidget extends StatefulWidget {
  final String serviceName;
  final String serviceKey;

  const ProcurementHistoryWidget({
    super.key,
    required this.serviceName,
    required this.serviceKey,
  });

  @override
  State<ProcurementHistoryWidget> createState() => _ProcurementHistoryWidgetState();
}

class _ProcurementHistoryWidgetState extends State<ProcurementHistoryWidget> {

  @override
  Widget build(BuildContext context) {
    // Sample data - replace with actual data from API
    final historyItems = _getSampleData();

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
        title: Row(
          children: [
            const SizedBox(width: AppSizes.sm),
            Text(
              _getTitle(),
              style: AppTextStyles.h3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: _buildSubmissionWidget(historyItems),
      ),
    );
  }

  String _getTitle() {
    switch (widget.serviceKey) {
      case 'spp':
        return 'SPP Pengajuan Saya';
      case 'pr':
        return 'Permohonan Saya PR & PPAB';
      case 'ppab':
        return 'Permohonan Saya PR & PPAB';
      case 'hps':
        return 'Permohonan Saya ${widget.serviceName}';
      case 'pengadaan':
        return 'Permohonan Saya ${widget.serviceName}';
      default:
        return 'Permohonan Saya ${widget.serviceName}';
    }
  }

  Widget _buildSubmissionWidget(List<ApprovalHistoryItem> items) {
    return Column(
      children: [
        // Header with search and pagination
        _buildHeader(items.length),
        
        const SizedBox(height: AppSizes.md),
        
        // Submission list
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSubmissionCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(int itemCount) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari permohonan...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Pagination info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menampilkan $itemCount dari $itemCount entri',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  '10 per halaman',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard(ApprovalHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with number and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.number.isNotEmpty ? item.number : 'Draft',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                ApprovalStatusWidgets.buildStatusChip(item.status),
              ],
            ),
            
            const SizedBox(height: AppSizes.sm),
            
            // Approval time with status icons
            Row(
              children: [
                Text(
                  ApprovalUtils.formatDateTime(item.approvalTime),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                ApprovalStatusWidgets.buildStatusIcons(item.status),
              ],
            ),
            
            const SizedBox(height: AppSizes.md),
            
            // Description - All "Permohonan Saya" only show Perihal (no Pembuat)
            _buildSubmissionDescriptionSection(item.description),
            
            const SizedBox(height: AppSizes.sm),
            
            // Item
            ApprovalContentSections.buildItemSection(item.item),
            
            const SizedBox(height: AppSizes.sm),
            
            // Total amount and PDF buttons
            Row(
              children: [
                Expanded(
                  child: ApprovalContentSections.buildTotalSection(item.total),
                ),
                const SizedBox(width: AppSizes.sm),
                DocumentActionButtons(item: item, serviceType: widget.serviceKey),
              ],
            ),
            
            // No authorities section for all "Permohonan Saya" (user's own submissions)
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionDescriptionSection(String description) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                'Perihal',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  List<ApprovalHistoryItem> _getSampleData() {
    // Sample data with authorities for timeline display
      return [
        ApprovalHistoryItem(
          id: '1',
          approvalTime: DateTime(2025, 9, 12, 8, 15, 2),
          number: widget.serviceKey == 'spp' ? '2158/SPP/010301/09/2025' : '2158/PR/010301/09/2025',
          description: widget.serviceKey == 'spp' 
            ? '48607 CP 3 SPP V3 Pengeluaran Penerimaan'
            : 'CP 3 PR V3 Pengeluaran Penerimaan',
          item: widget.serviceKey == 'spp' 
            ? 'CP 3 SPP V3 Pengeluaran;'
            : 'CP 3 PR V3 Pengeluaran;',
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
          number: widget.serviceKey == 'spp' ? '2157/SPP/010301/09/2025' : '2157/PR/010301/09/2025',
          description: widget.serviceKey == 'spp' 
            ? '48606 CP 2 SPP V3 Pengeluaran'
            : 'CP 2 PR V2 Pembelian',
          item: widget.serviceKey == 'spp' 
            ? 'CP 2 SPP V3 Pengeluaran;'
            : 'CP 2 PR V2 Pembelian;',
          total: 15000000,
          status: ApprovalStatus.pending,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Siti Nurhaliza',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 11, 14, 30, 15),
              actionTime: DateTime(2025, 9, 11, 14, 32, 0),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Siti Nurhaliza',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 11, 14, 32, 0),
              actionTime: DateTime(2025, 9, 11, 14, 33, 30),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Ahmad Wijaya',
              isCompleted: false,
              receivedTime: DateTime(2025, 9, 11, 14, 33, 30),
              actionTime: null,
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Budi Santoso',
              isCompleted: false,
              receivedTime: DateTime(2025, 9, 11, 14, 33, 30),
              actionTime: null,
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '3',
          approvalTime: DateTime(2025, 9, 10, 10, 45, 30),
          number: widget.serviceKey == 'spp' ? '2156/SPP/010301/09/2025' : '2156/PR/010301/09/2025',
          description: widget.serviceKey == 'spp' 
            ? '48422 Pengujian 10 SPP V3'
            : 'CP 1 PR V1 Perbaikan',
          item: widget.serviceKey == 'spp' 
            ? 'Pengujian 10 SPP V3;'
            : 'CP 1 PR V1 Perbaikan;',
          total: 25000000,
          status: ApprovalStatus.rejected,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'Rizki Pratama',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 10, 10, 45, 30),
              actionTime: DateTime(2025, 9, 10, 10, 47, 0),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'Rizki Pratama',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 10, 10, 47, 0),
              actionTime: DateTime(2025, 9, 10, 10, 48, 15),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Eko Prasetyo',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 10, 10, 48, 15),
              actionTime: DateTime(2025, 9, 10, 10, 50, 0),
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Sari Indah',
              isRejected: true,
              receivedTime: DateTime(2025, 9, 10, 10, 50, 0),
              actionTime: DateTime(2025, 9, 10, 10, 52, 30),
            ),
          ],
        ),
        ApprovalHistoryItem(
          id: '4',
          approvalTime: DateTime(2025, 9, 9, 16, 10, 0),
          number: '', // Draft
          description: widget.serviceKey == 'spp' 
            ? '48421 Pengujian 9 SPP V3'
            : 'Meeting di Jakarta',
          item: widget.serviceKey == 'spp' 
            ? 'Pengujian 9 SPP V3;'
            : 'Meeting Jakarta;',
          total: 11000000,
          status: ApprovalStatus.pending,
          authorities: [], // Draft items have no authorities yet
        ),
        ApprovalHistoryItem(
          id: '5',
          approvalTime: DateTime(2025, 9, 8, 11, 20, 45),
          number: widget.serviceKey == 'spp' ? '2141/SPP/010301/09/2025' : '2141/PR/010301/09/2025',
          description: widget.serviceKey == 'spp' 
            ? '48049 Pengujian 2 SPP V3'
            : 'Training Karyawan',
          item: widget.serviceKey == 'spp' 
            ? 'Pengujian 2 SPP V3;'
            : 'Training Karyawan;',
          total: 39999999,
          status: ApprovalStatus.approved,
          authorities: [
            ApprovalAuthority(
              role: 'Paraf Pemohon',
              name: 'John Doe',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 8, 11, 20, 45),
              actionTime: DateTime(2025, 9, 8, 11, 22, 0),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Pemohon',
              name: 'John Doe',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 8, 11, 22, 0),
              actionTime: DateTime(2025, 9, 8, 11, 23, 30),
            ),
            ApprovalAuthority(
              role: 'Tandatangan Mengetahui',
              name: 'Jane Smith',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 8, 11, 23, 30),
              actionTime: DateTime(2025, 9, 8, 11, 25, 0),
            ),
            ApprovalAuthority(
              role: 'Paraf Menyetujui',
              name: 'Bob Johnson',
              isCompleted: true,
              receivedTime: DateTime(2025, 9, 8, 11, 25, 0),
              actionTime: DateTime(2025, 9, 8, 11, 27, 15),
            ),
          ],
        ),
      ];
  }
}
