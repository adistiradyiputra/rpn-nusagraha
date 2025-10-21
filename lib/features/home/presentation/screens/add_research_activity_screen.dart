import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/activity_service.dart';
import '../../domain/models/research_activity.dart';
import '../widgets/searchable_dropdown.dart';
import '../widgets/form_widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AddResearchActivityScreen extends StatefulWidget {
  final Function(ResearchActivity)? onActivityAdded;
  final ResearchActivity? existingActivity;
  
  const AddResearchActivityScreen({
    super.key,
    this.onActivityAdded,
    this.existingActivity,
  });

  @override
  State<AddResearchActivityScreen> createState() => _AddResearchActivityScreenState();
}

class _AddResearchActivityScreenState extends State<AddResearchActivityScreen> {
  List<String> selectedCategories = [];
  String? selectedStatus;
  String? selectedLocationType;
  String? selectedLocation;
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // API data
  List<String> _kotaList = [];
  List<String> _negaraList = [];
  bool _isLoadingLocations = false;

  final List<String> categories = [
    'Riset',
    'Pengembangan Inkubasi',
    'Pelayanan Jasa',
    'Usaha/Produksi',
    'Pemasaran & Penjualan',
    'Administrasi Kantor',
  ];

  final List<String> statuses = [
    'Perjalanan Dinas',
    'Kantor',
    'Cuti',
    'Lainnya',
  ];

  final List<String> locationTypes = [
    'Dalam Negeri',
    'Luar Negeri',
  ];

  List<String> get availableLocations {
    if (selectedLocationType == 'Dalam Negeri') {
      return _kotaList;
    } else if (selectedLocationType == 'Luar Negeri') {
      return _negaraList;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _initializeWithExistingData();
    // Load location data in background without blocking UI
    _loadLocationDataAsync();
  }

  void _initializeWithExistingData() {
    if (widget.existingActivity != null) {
      final activity = widget.existingActivity!;
      _titleController.text = activity.title;
      _descriptionController.text = activity.description;
      // Split category string by comma to create separate tags
      selectedCategories = activity.category.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      selectedStatus = activity.status;
      selectedLocationType = activity.locationType;
      selectedLocation = activity.location;
      startDate = activity.startDate;
      endDate = activity.endDate;
    }
  }

  Future<void> _loadLocationDataAsync() async {
    // Don't show loading immediately, let user interact with other fields first
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!mounted) return;
    
    setState(() {
      _isLoadingLocations = true;
    });

    try {
      final locationData = await LocationService.getKotaDanNegara();
      if (mounted) {
        setState(() {
          _kotaList = locationData['kota'] ?? [];
          _negaraList = locationData['negara'] ?? [];
          _isLoadingLocations = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocations = false;
        });
        // Show error - no fallback data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data lokasi dari server. Silakan coba lagi.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
  

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitActivity() async {
    // Validate form
    if (_titleController.text.isEmpty ||
        selectedCategories.isEmpty ||
        selectedStatus == null ||
        selectedLocationType == null ||
        selectedLocation == null ||
        startDate == null ||
        endDate == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Determine location logic
      String kota;
      int luarNegri;
      
      if (selectedLocationType == 'Luar Negeri') {
        luarNegri = 1; // Foreign activities
        kota = selectedLocation!; // Use selected country for foreign activities
      } else {
        luarNegri = 0; // Domestic activities
        kota = selectedLocation!; // Use selected city for domestic activities
      }

      // Format dates based on mode
      final DateTime now = DateTime.now();
      final String formattedStartDate = "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
      final String formattedEndDate = "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";
      final String formattedCreated = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      // Get user ID from auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Use idKar from user data (saved during login)
      final userId = authProvider.user?.idKar;
      
      if (userId == null) {
        // Close loading dialog
        if (mounted) Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data tidak ditemukan. Silakan login ulang.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Call API - use update or create based on mode
      Map<String, dynamic> result;
      
      if (widget.existingActivity != null) {
        // Update mode
        result = await ActivityService.updateActivity(
          id: widget.existingActivity!.id,
          idKar: userId,
          kategori: selectedCategories,
          keterangan: _titleController.text,
          statusAktivitas: selectedStatus!,
          kota: kota,
          luarNegri: luarNegri,
          created: widget.existingActivity!.created ?? formattedCreated, // Use existing created date or current date
          tglMulai: formattedStartDate,
          tglSelesai: formattedEndDate,
        );
      } else {
        // Create mode
        result = await ActivityService.postActivity(
          idKar: userId,
          kategori: selectedCategories,
          keterangan: _titleController.text, // Use title as keterangan
          statusAktivitas: selectedStatus!,
          kota: kota,
          luarNegri: luarNegri,
          created: formattedCreated,
          tglMulai: formattedStartDate,
          tglSelesai: formattedEndDate,
        );
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (result['success']) {
        // Show success message from API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Call callback to notify parent screen
        if (widget.onActivityAdded != null) {
          if (widget.existingActivity != null) {
            // Update mode - mark as edited
            final updatedActivity = ResearchActivity(
              id: widget.existingActivity!.id,
              title: _titleController.text,
              category: selectedCategories.join(','),
              status: selectedStatus!,
              location: selectedLocation!,
              locationType: selectedLocationType!,
              startDate: startDate!,
              endDate: endDate!,
              description: _descriptionController.text,
              created: widget.existingActivity!.created,
              isEdited: true, // Mark as edited
            );
            widget.onActivityAdded!(updatedActivity);
          } else {
            // Create mode - new activity
            final newActivity = ResearchActivity(
              id: result['data']?['id']?.toString() ?? '',
              title: _titleController.text,
              category: selectedCategories.join(','),
              status: selectedStatus!,
              location: selectedLocation!,
              locationType: selectedLocationType!,
              startDate: startDate!,
              endDate: endDate!,
              description: _descriptionController.text,
            );
            widget.onActivityAdded!(newActivity);
          }
        }

        // Navigate back
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.existingActivity != null ? 'Edit Kegiatan' : 'Tambah Kegiatan',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSizes.lg,
          right: AppSizes.lg,
          top: AppSizes.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.lg,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kegiatan
            FormWidgets.buildTextField(
              label: 'Kegiatan',
              controller: _titleController,
              hintText: 'Masukkan kegiatan peneliti',
              maxLines: 3,
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Kategori Aktivitas (Multiple Select)
            _buildMultipleSelectField(
              label: 'Kategori Aktivitas',
              selectedValues: selectedCategories,
              items: categories,
              onChanged: (values) => setState(() => selectedCategories = values),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Uraian Aktivitas
            FormWidgets.buildTextField(
              label: 'Uraian Aktivitas',
              controller: _descriptionController,
              maxLines: 4,
              hintText: 'Masukkan uraian aktivitas',
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Status Aktivitas
            FormWidgets.buildDropdown(
              label: 'Status Aktivitas',
              selectedValue: selectedStatus,
              items: statuses,
              onChanged: (value) => setState(() => selectedStatus = value),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Tipe Lokasi
            FormWidgets.buildDropdown(
              label: 'Tipe Lokasi',
              selectedValue: selectedLocationType,
              items: locationTypes,
              onChanged: (value) => setState(() {
                selectedLocationType = value;
                selectedLocation = null; // Reset selected location when type changes
              }),
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Lokasi Spesifik
            if (selectedLocationType != null)
              _isLoadingLocations
                  ? Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.inputBorder),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            'Memuat data lokasi...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : availableLocations.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(AppSizes.md),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            color: Colors.red.withOpacity(0.05),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  'Data lokasi tidak tersedia. Silakan refresh atau coba lagi.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SearchableDropdown(
                          label: selectedLocationType == 'Dalam Negeri' ? 'Kota' : 'Negara',
                          selectedValue: selectedLocation,
                          items: availableLocations,
                          onChanged: (value) => setState(() => selectedLocation = value),
                        ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Waktu Aktivitas
            FormWidgets.buildSectionTitle('Waktu Aktivitas'),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: FormWidgets.buildDateField(
                    label: 'Tanggal Mulai',
                    date: startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: FormWidgets.buildDateField(
                    label: 'Tanggal Selesai',
                    date: endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.xxl),
            
            // Action Buttons
            FormWidgets.buildActionButtons(
              onCancel: () => Navigator.pop(context),
              onSubmit: _submitActivity,
              cancelText: 'Batal',
              submitText: widget.existingActivity != null ? 'Update' : 'Submit',
            ),
            
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }


  Widget _buildMultipleSelectField({
    required String label,
    required List<String> selectedValues,
    required List<String> items,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Column(
            children: [
              // Selected values display
              if (selectedValues.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Wrap(
                    spacing: AppSizes.xs,
                    runSpacing: AppSizes.xs,
                    children: selectedValues.map((value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          border: Border.all(color: AppColors.primaryBlue),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            GestureDetector(
                              onTap: () {
                                final newValues = List<String>.from(selectedValues);
                                newValues.remove(value);
                                onChanged(newValues);
                              },
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              
              // Dropdown button
              GestureDetector(
                onTap: () => _showMultipleSelectDialog(items, selectedValues, onChanged),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedValues.isEmpty 
                              ? 'Pilih $label' 
                              : '${selectedValues.length} kategori dipilih',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: selectedValues.isEmpty 
                                ? AppColors.textSecondary 
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMultipleSelectDialog(
    List<String> items,
    List<String> selectedValues,
    Function(List<String>) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelected = List.from(selectedValues);
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              title: Text(
                'Pilih Kategori Aktivitas',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                    final isSelected = tempSelected.contains(item);
                    return CheckboxListTile(
                      title: Text(
                        item,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                      activeColor: AppColors.primaryBlue,
                    );
                  }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onChanged(tempSelected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Pilih',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
