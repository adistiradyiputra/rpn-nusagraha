import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../../core/services/forum_service.dart';
import '../../domain/models/research_activity.dart';
import '../../domain/models/activity_response.dart';
import '../../data/services/activity_data_service.dart';
import '../widgets/research_activity_table.dart';
import '../widgets/activity_search_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'add_research_activity_screen.dart';

class ExpertSystemScreen extends StatefulWidget {
  const ExpertSystemScreen({super.key});

  @override
  State<ExpertSystemScreen> createState() => _ExpertSystemScreenState();
}

class _ExpertSystemScreenState extends State<ExpertSystemScreen> {
  List<ResearchActivity> _researchActivities = [];
  final GlobalKey<ResearchActivityTableState> _tableKey = GlobalKey<ResearchActivityTableState>();
  
  // API related state
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadResearchActivities();
  }

  Future<void> _loadResearchActivities({bool isRefresh = false}) async {
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.idKar;
    
    if (userId == null) {
      setState(() {
        _errorMessage = 'User data tidak ditemukan. Silakan login ulang.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (isRefresh) {
        _currentPage = 1;
      }
    });

    try {
      final result = await ActivityDataService.getActivitiesByUser(
        userId: userId,
        page: _currentPage,
        limit: 10,
        search: _searchQuery,
        sortBy: 'created_real',
        sortOrder: 'DESC',
      );

      if (mounted) {
        if (result['success'] == true) {
          final data = result['data'];
          final List<ActivityResponse> activities = data['items'];
          
           setState(() {
             _researchActivities = activities.map((activity) => activity.toResearchActivity()).toList();
             
             
             // Use pagination data from API response
             _totalItems = data['total'] ?? activities.length;
             _totalPages = data['totalPages'] ?? 1;
             _currentPage = data['page'] ?? 1;
             
             _isLoading = false;
             _errorMessage = null;
           });
          
        } else {
          setState(() {
            _errorMessage = result['message'] ?? 'Gagal memuat data aktivitas';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });
    
    await _loadResearchActivities(isRefresh: true);
    
    if (mounted) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _onPageChanged(int page) async {
    setState(() {
      _currentPage = page;
    });
    
    await _loadResearchActivities();
  }

  void _addNewActivity(ResearchActivity newActivity) {
    // Reset to page 1 and clear search to show new data at the top
    setState(() {
      _currentPage = 1;
      _searchQuery = '';
    });
    
    // Refresh the list to get updated data from API
    _loadResearchActivities(isRefresh: true);
  }

  void _addResearchActivity() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddResearchActivityScreen(
          onActivityAdded: _addNewActivity,
        ),
      ),
    );
    
    // If a new activity was added, it's already added via callback
    // No need to refresh the entire list
  }

  Future<void> _openForumDiskusi() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final idKar = authProvider.user?.idKar;
    
    if (idKar == null || idKar.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID Kar tidak ditemukan. Silakan login ulang.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );

    try {
      // Get forum link dari API
      final forumLink = await ForumService.getForumLink(idKar);
      
      // Tutup loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Navigate ke webview dengan link forum
      if (mounted) {
        context.push('/webview', extra: forumLink);
      }
    } catch (e) {
      // Tutup loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Tampilkan error dengan detail
      if (mounted) {
        String errorMessage = 'Gagal membuka forum';
        
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceAll('Exception:', '').trim();
        } else {
          errorMessage = 'Gagal membuka forum: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Tutup',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  void _editResearchActivity(ResearchActivity activity) async {
    // Navigate to edit screen (reuse AddResearchActivityScreen with edit mode)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddResearchActivityScreen(
          onActivityAdded: _updateActivity,
          existingActivity: activity,
        ),
      ),
    );
  }

  void _updateActivity(ResearchActivity updatedActivity) {
    // Refresh the list to get updated data from API (isEdited will be set from API response)
    _loadResearchActivities(isRefresh: true);
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
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.psychology,
                color: AppColors.primaryBlue,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            const Expanded(
              child: Text(
                'Expert System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action Buttons Row
              Row(
                children: [
                  // Add Research Activity Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _addResearchActivity,
                      child: GradientContainer(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.lg,
                            horizontal: AppSizes.md,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Flexible(
                                child: Text(
                                  'Tambah Kegiatan\nPeneliti',
                                  style: AppTextStyles.buttonMedium.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppSizes.md),
                  
                  // Forum Diskusi Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _openForumDiskusi,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.lg,
                            horizontal: AppSizes.md,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.forum,
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Flexible(
                                child: Text(
                                  'Forum Diskusi',
                                  style: AppTextStyles.buttonMedium.copyWith(
                                    fontSize: 14,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Search Bar
              ActivitySearchBar(
                onSearchChanged: _onSearchChanged,
                isLoading: _isSearching,
                hintText: 'Cari kegiatan penelitian...',
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Research Activity Table or Loading/Error States
              if ((_isLoading || _isSearching) && _researchActivities.isEmpty) ...[
                _buildLoadingState(),
              ] else if (_errorMessage != null) ...[
                _buildErrorState(),
              ] else if (_researchActivities.isNotEmpty && !_isSearching) ...[
                ResearchActivityTable(
                  key: _tableKey,
                  activities: _researchActivities,
                  onEdit: _editResearchActivity,
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  totalItems: _totalItems,
                  onPageChanged: _onPageChanged,
                  isLoading: _isLoading,
                ),
              ] else if (_isSearching && _researchActivities.isNotEmpty) ...[
                // Show skeleton when searching with existing data
                _buildLoadingState(),
                // Extra padding untuk mencegah bottom overflow
                const SizedBox(height: AppSizes.xl),
              ] else
                _buildEmptyState(),
              // Bottom padding untuk memastikan tidak ada overflow
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          // Skeleton for search bar
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Skeleton for activity table
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  // Table header
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container(height: 20, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 8),
                      Expanded(flex: 1, child: Container(height: 20, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 8),
                      Expanded(flex: 1, child: Container(height: 20, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 8),
                      Container(height: 20, width: 60, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  // Skeleton rows
                  ...List.generate(5, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Container(height: 16, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                        const SizedBox(width: 8),
                        Expanded(flex: 1, child: Container(height: 16, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                        const SizedBox(width: 8),
                        Expanded(flex: 1, child: Container(height: 16, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                        const SizedBox(width: 8),
                        Container(height: 16, width: 60, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Gagal Memuat Data',
              style: AppTextStyles.h3.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              _errorMessage ?? 'Terjadi kesalahan yang tidak diketahui',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            ElevatedButton.icon(
              onPressed: () => _loadResearchActivities(isRefresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Belum Ada Kegiatan',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Tidak ada kegiatan yang sesuai dengan pencarian "$_searchQuery"'
                  : 'Belum ada kegiatan peneliti yang tercatat',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              ElevatedButton.icon(
                onPressed: () => _onSearchChanged(''),
                icon: const Icon(Icons.clear),
                label: const Text('Hapus Pencarian'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
