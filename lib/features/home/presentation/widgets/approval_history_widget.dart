import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/approval_history_models.dart';
import 'approval_content_sections.dart';
import 'approval_status_widgets.dart';
import 'approval_authorities_widget.dart';
import 'document_action_buttons.dart';
import '../utils/approval_utils.dart';

class ApprovalHistoryWidget extends StatefulWidget {
  final String serviceName;
  final String? serviceType;
  final List<ApprovalHistoryItem> items;

  const ApprovalHistoryWidget({
    super.key,
    required this.serviceName,
    this.serviceType,
    required this.items,
  });

  @override
  State<ApprovalHistoryWidget> createState() => _ApprovalHistoryWidgetState();
}

class _ApprovalHistoryWidgetState extends State<ApprovalHistoryWidget> {
  final Map<String, bool> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with search and pagination
        _buildHeader(),
        
        const SizedBox(height: AppSizes.md),
        
        // Approval history list
        Expanded(
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _buildApprovalCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
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
              hintText: 'Cari riwayat approval...',
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
                'Menampilkan ${widget.items.length} dari ${widget.items.length} entri',
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

  Widget _buildApprovalCard(ApprovalHistoryItem item) {
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
                    item.number,
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
            
            // Description - Split into Pembuat and Perihal
            ApprovalContentSections.buildDescriptionSection(item.description),
            
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
                DocumentActionButtons(item: item, serviceType: widget.serviceType),
              ],
            ),
            
            const SizedBox(height: AppSizes.md),
            
            // Authorities section - Collapsible
            _buildAuthoritiesSection(item),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthoritiesSection(ApprovalHistoryItem item) {
    return Column(
      children: [
        // Collapsible header
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedItems[item.id] = !(_expandedItems[item.id] ?? false);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Kewenangan (6 tahap)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  _expandedItems[item.id] == true 
                      ? Icons.expand_less 
                      : Icons.expand_more,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        
        // Authorities list - Collapsible content
        if (_expandedItems[item.id] == true) ...[
          const SizedBox(height: AppSizes.sm),
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: ApprovalAuthoritiesWidget(authorities: item.authorities),
          ),
        ],
      ],
    );
  }
}
