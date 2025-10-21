import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/research_activity.dart';

class ResearchActivityTable extends StatefulWidget {
  final List<ResearchActivity> activities;
  final Function(ResearchActivity)? onEdit;
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final Function(int)? onPageChanged;
  final bool isLoading;

  const ResearchActivityTable({
    super.key,
    required this.activities,
    this.onEdit,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.onPageChanged,
    this.isLoading = false,
  });

  @override
  State<ResearchActivityTable> createState() => ResearchActivityTableState();
}

class ResearchActivityTableState extends State<ResearchActivityTable> {

  // Use API pagination if available, otherwise use local pagination
  List<ResearchActivity> get _paginatedActivities {
    if (widget.currentPage != null) {
      // API pagination - return all activities as they're already paginated
      return widget.activities;
    } else {
      // Local pagination fallback
      final int _currentPage = 1;
      final int _itemsPerPage = 10;
      final startIndex = (_currentPage - 1) * _itemsPerPage;
      final endIndex = startIndex + _itemsPerPage;
      return widget.activities.sublist(
        startIndex,
        endIndex > widget.activities.length ? widget.activities.length : endIndex,
      );
    }
  }

  int get _currentPage => widget.currentPage ?? 1;
  int get _totalPages {
    if (widget.totalPages != null && widget.totalPages! > 0) {
      return widget.totalPages!;
    }
    // Fallback: calculate from activities length
    final calculatedPages = (widget.activities.length / 10).ceil();
    return calculatedPages > 0 ? calculatedPages : 1;
  }
  int get _totalItems => widget.totalItems ?? widget.activities.length;

  void _nextPage() {
    if (_currentPage < _totalPages) {
      if (widget.onPageChanged != null) {
        widget.onPageChanged!(_currentPage + 1);
      } else {
        setState(() {
          // Local pagination fallback
        });
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      if (widget.onPageChanged != null) {
        widget.onPageChanged!(_currentPage - 1);
      } else {
        setState(() {
          // Local pagination fallback
        });
      }
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      if (widget.onPageChanged != null) {
        widget.onPageChanged!(page);
      } else {
        setState(() {
          // Local pagination fallback
        });
      }
    }
  }


  bool _isEdited(String activityId) {
    // Check if activity has been edited from API response (lastupdated and lastupdated_by not null)
    final activity = widget.activities.firstWhere(
      (activity) => activity.id == activityId,
      orElse: () => ResearchActivity(
        id: '',
        title: '',
        category: '',
        status: '',
        location: '',
        locationType: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        description: '',
        isEdited: false,
      ),
    );
    
    return activity.isEdited; // Use isEdited from API response
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientBlue,
                  AppColors.navyBlue,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusMd),
                topRight: Radius.circular(AppSizes.radiusMd),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.table_chart,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        'Data Kegiatan Peneliti',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Total: $_totalItems | Halaman: $_currentPage/$_totalPages',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Table Content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - (AppSizes.md * 2),
              ),
              child: DataTable(
                columnSpacing: AppSizes.md,
                headingRowHeight: 56,
                dataRowMinHeight: 80,
                dataRowMaxHeight: 100,
                headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
               columns: const [
                 DataColumn(
                   label: Text(
                     'No',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Kegiatan',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Kategori',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Status',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Lokasi',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Periode',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Aksi',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
               ],
              rows: _paginatedActivities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final globalIndex = widget.currentPage != null 
                    ? ((_currentPage - 1) * 10) + index + 1
                    : index + 1;
                
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '$globalIndex',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 200,
                        height: 80,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                activity.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (activity.lastUpdated != null) ...[
                              const SizedBox(height: 4),
                              _buildUpdateBadge(activity),
                            ],
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(activity.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getCategoryColor(activity.category),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          activity.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _getCategoryColor(activity.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(activity.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(activity.status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          activity.status,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _getStatusColor(activity.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        activity.location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${_formatDate(activity.startDate)} - ${_formatDate(activity.endDate)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isEdited(activity.id)) ...[
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sudah diedit',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else ...[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                              onPressed: () {
                                if (widget.onEdit != null) {
                                  widget.onEdit!(activity);
                                }
                              },
                              tooltip: 'Edit kegiatan',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
              ),
            ),
          ),
          
          // Pagination Controls - Always show
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.radiusMd),
                bottomRight: Radius.circular(AppSizes.radiusMd),
              ),
            ),
            child: Column(
              children: [
                // Pagination Info
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Column(
                    children: [
                      Text(
                        'Halaman $_currentPage dari $_totalPages',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Menampilkan ${_paginatedActivities.length} dari $_totalItems data',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                  
                  // Pagination Controls
                  Row(
                    children: [
                      // Previous Button
                      IconButton(
                        onPressed: (_currentPage > 1 && !widget.isLoading) ? _previousPage : null,
                        icon: widget.isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.chevron_left, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: (_currentPage > 1 && !widget.isLoading)
                              ? AppColors.primaryBlue 
                              : Colors.grey[300],
                          foregroundColor: (_currentPage > 1 && !widget.isLoading)
                              ? Colors.white 
                              : Colors.grey[600],
                          padding: const EdgeInsets.all(AppSizes.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: AppSizes.md),
                      
                      // Page Numbers
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_totalPages, (index) {
                              final pageNumber = index + 1;
                              final isCurrentPage = pageNumber == _currentPage;
                              
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                child: InkWell(
                                  onTap: () => _goToPage(pageNumber),
                                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isCurrentPage 
                                          ? AppColors.primaryBlue 
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                      border: Border.all(
                                        color: isCurrentPage 
                                            ? AppColors.primaryBlue 
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$pageNumber',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isCurrentPage 
                                              ? Colors.white 
                                              : AppColors.textPrimary,
                                          fontWeight: isCurrentPage 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: AppSizes.md),
                      
                      // Next Button
                      IconButton(
                        onPressed: (_currentPage < _totalPages && !widget.isLoading) ? _nextPage : null,
                        icon: widget.isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.chevron_right, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: (_currentPage < _totalPages && !widget.isLoading)
                              ? AppColors.primaryBlue 
                              : Colors.grey[300],
                          foregroundColor: (_currentPage < _totalPages && !widget.isLoading)
                              ? Colors.white 
                              : Colors.grey[600],
                          padding: const EdgeInsets.all(AppSizes.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Riset':
        return Colors.blue;
      case 'Pengembangan Inkubasi':
        return Colors.green;
      case 'Pelayanan Jasa':
        return Colors.orange;
      case 'Usaha/Produksi':
        return Colors.purple;
      case 'Pemasaran & Penjualan':
        return Colors.red;
      case 'Administrasi Kantor':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Perjalanan Dinas':
        return Colors.blue;
      case 'Kantor':
        return Colors.green;
      case 'Cuti':
        return Colors.orange;
      case 'Lainnya':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatFullDate(DateTime date) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildUpdateBadge(ResearchActivity activity) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            'Edited ${_formatFullDate(activity.lastUpdated!)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
