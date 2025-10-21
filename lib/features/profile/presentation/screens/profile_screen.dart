import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/device_info.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _deviceName = 'Loading...';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }
  
  Future<void> _loadDeviceInfo() async {
    try {
      // Use the proper DeviceInfo utility to get the device name
      final deviceName = await DeviceInfo.getDeviceName();
      
      if (kDebugMode) {
        print('Device name from DeviceInfo: "$deviceName"');
      }
      
      setState(() {
        _deviceName = deviceName;
      });
      
    } catch (e) {
      if (kDebugMode) {
        print('Profile screen device info error: $e');
      }
      setState(() {
        _deviceName = 'Unknown Device';
      });
    }
  }
  

  void _showEditPhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          title: Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppSizes.sm),
              const Text(
                'Edit Foto Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Pilih sumber foto untuk profil Anda',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _selectFromGallery();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  const Text(
                    'Galeri',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _takePhoto();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  const Text(
                    'Kamera',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diubah'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diambil'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        title: const Row(
          children: [
            Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                'Profile',
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
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            children: [
              // Profile Header Card
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Photo
                      GestureDetector(
                        onTap: _showEditPhotoDialog,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientBlue,
                                AppColors.navyBlue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Profile Image or Default Icon
                              ClipOval(
                                child: _profileImage != null
                                    ? Image.file(
                                        _profileImage!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Consumer<AuthProvider>(
                                        builder: (context, authProvider, child) {
                                          return authProvider.user?.foto != null
                                              ? Image.network(
                                                  authProvider.user!.foto!,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [
                                                            AppColors.gradientBlue,
                                                            AppColors.navyBlue,
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.person,
                                                        size: 40,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [
                                                        AppColors.gradientBlue,
                                                        AppColors.navyBlue,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                );
                                        },
                                      ),
                              ),
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: Container(
                              //     width: 24,
                              //     height: 24,
                              //     decoration: BoxDecoration(
                              //       color: AppColors.primaryBlue,
                              //       shape: BoxShape.circle,
                              //       border: Border.all(
                              //         color: Colors.white,
                              //         width: 2,
                              //       ),
                              //     ),
                              //     child: const Icon(
                              //       Icons.camera_alt,
                              //       size: 12,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.lg),
                      
                      // Name and Position
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            // Tentukan jabatan fungsional yang akan ditampilkan
                            // Prioritas: gunakan lastFung.fungJab jika ada, jika tidak ada gunakan jabFung
                            String displayJabFung = authProvider.user?.lastFung?.fungJab ?? authProvider.user?.jabFung ?? '';
                            
                            // Jika nilainya "Calon Peneliti" (dari mana pun sumbernya), ganti dengan "Peneliti Mula"
                            if (displayJabFung == 'Calon Peneliti') {
                              displayJabFung = 'Peneliti Mula';
                            }
                            
                            // Tentukan spacing berdasarkan type
                            final isNonPeneliti = authProvider.user?.type == 'non_peneliti';
                            final spacing = isNonPeneliti ? 2.0 : AppSizes.xs;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.user?.fullName ?? 'User',
                                  style: AppTextStyles.h4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  authProvider.user?.nik ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                // Tampilkan Golongan setelah NIK jika type = non_peneliti
                                if (isNonPeneliti) ...[
                                  SizedBox(height: spacing),
                                  Text(
                                    authProvider.user?.lastGol?.levelGolongan ?? '',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    authProvider.user?.jabStruk ?? '',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Text(
                                    displayJabFung,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (authProvider.user?.kepakaran != null) ...[
                                    SizedBox(height: spacing),
                                    Text(
                                      '(${authProvider.user!.kepakaran})',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ] else ...[
                                  SizedBox(height: spacing),
                                  Text(
                                    displayJabFung,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (authProvider.user?.kepakaran != null) ...[
                                    SizedBox(height: spacing),
                                    Text(
                                      '(${authProvider.user!.kepakaran})',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: spacing),
                                  Text(
                                    authProvider.user?.jabStruk ?? '',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Professional Metrics Card - hanya untuk peneliti
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  // Sembunyikan card jika type = non_peneliti
                  if (authProvider.user?.type == 'non_peneliti') {
                    return const SizedBox.shrink();
                  }
                  
                  return Column(
                    children: [
                      const SizedBox(height: AppSizes.lg),
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (authProvider.user?.type != 'non_peneliti') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _buildMetricItem(
                                        label: 'Angka Kredit',
                                        value: authProvider.user?.lastFung?.ak ?? '-',
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildMetricItem(
                                        label: 'Golongan',
                                        value: authProvider.user?.lastGol?.levelGolongan ?? '-',
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.lg),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildMetricItem(
                                      label: 'Google Scholar',
                                      value: authProvider.user?.jmlGSchoolar?.toString() ?? '-',
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildMetricItem(
                                      label: 'Publikasi',
                                      value: authProvider.user?.jmlPublikasi?.toString() ?? '-',
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.lg),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildMetricItem(
                                      label: 'HKI',
                                      value: authProvider.user?.jmlHki?.toString() ?? '-',
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(), // Empty space for alignment
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Contact Information Card
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: authProvider.user?.email ?? '-',
                          ),
                          const SizedBox(height: AppSizes.md),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'WhatsApp',
                            value: authProvider.user?.noHp ?? '-',
                          ),
                          const SizedBox(height: AppSizes.md),
                          _buildInfoRow(
                            icon: Icons.phone_android_outlined,
                            label: 'Perangkat Terhubung',
                            value: _deviceName,
                          ),
                          const SizedBox(height: AppSizes.md),
                          _buildInfoRow(
                            icon: Icons.info_outline,
                            label: 'Versi',
                            value: '1.0.0 (0)',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Account Settings Card
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.lock_outline,
                        title: 'Edit Password',
                        onTap: () => _navigateToEditPassword(context),
                      ),
                      const Divider(height: AppSizes.xl),
                      _buildMenuItem(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () => _showLogoutDialog(context),
                        isLogout: true,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final iconColor = isLogout ? Colors.red : AppColors.primaryBlue;
    final textColor = isLogout ? Colors.red : AppColors.textPrimary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        splashColor: isLogout 
            ? Colors.red.withOpacity(0.1) 
            : AppColors.primaryBlue.withOpacity(0.1),
        highlightColor: isLogout 
            ? Colors.red.withOpacity(0.05) 
            : AppColors.primaryBlue.withOpacity(0.05),
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _navigateToEditPassword(BuildContext context) {
    context.push('/edit-password');
  }

  void _showLogoutDialog(BuildContext context) {
    _performLogout(context);
  }

  Future<void> _performLogout(BuildContext context) async {
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
      // Get AuthProvider and logout
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      
      // Tutup loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Navigate to login screen after logout
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      // Tutup loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Tampilkan error jika ada
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

