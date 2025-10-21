import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../widgets/welcome_card_content.dart';
import '../widgets/search_bar.dart';
import '../widgets/service_section.dart';
import '../widgets/bottom_navigation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'pr_menu_screen.dart';
import 'hps_menu_screen.dart';
import 'pengadaan_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Reset to home tab when screen is initialized
    _selectedIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset to home tab when returning from other screens
    if (mounted) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  void _launchHelpdesk() async {
    final Uri url = Uri.parse('https://helpdesk.rpn.co.id/');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void _checkAccessAndNavigate(BuildContext context, String feature, String title) {
    final authProvider = context.read<AuthProvider>();
    final userType = authProvider.user?.type;

    // Check if user is non-peneliti trying to access nusariset features
    if (userType == 'non_peneliti' && 
        (feature == 'expert_system' || feature == 'e_proposal' || feature == 'e_monev')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Akses Ditolak'),
          content: const Text('Anda tidak memiliki akses ke NUSARISET. Fitur ini hanya tersedia untuk peneliti.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      NavigationHelper.navigateToFeature(context, feature, title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Combined Search Bar and Welcome Card
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientBlue,
                  AppColors.navyBlue,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.radiusXl),
                bottomRight: Radius.circular(AppSizes.radiusXl),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      AppSizes.lg,
                      AppSizes.md,
                      AppSizes.lg,
                    ),
                    child: CustomSearchBar(),
                  ),
                  
                  // Welcome Card Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      0,
                      AppSizes.xl,
                      AppSizes.lg,
                    ),
                    child: WelcomeCardContent(),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.md,
                AppSizes.md,
                AppSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NUSAGRAHA Logo
                  Image.asset(
                    'assets/images/iconapp.png',
                    height: 29,
                    fit: BoxFit.contain,
                  ),
                  
                  SizedBox(height: AppSizes.xl),
                  
                  ServiceSection(
                    title: 'NUSARISET',
                    icon: 'assets/images/icon-nusariset.png',
                    description: 'Expert System, E-Proposal, E-Monev',
                    services: [
                      ServiceItem(
                        icon: Icons.psychology,
                        title: 'Expert System',
                        subtitle: 'Kegiatan Riset',
                        onTap: () {
                          _checkAccessAndNavigate(
                            context,
                            'expert_system',
                            'Expert System',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.description,
                        title: 'E-Proposal',
                        subtitle: 'Proposal Riset',
                        onTap: () {
                          _checkAccessAndNavigate(
                            context,
                            'e_proposal',
                            'E-Proposal',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.analytics,
                        title: 'E-Monev',
                        subtitle: 'Monev Riset',
                        onTap: () {
                          _checkAccessAndNavigate(
                            context,
                            'e_monev',
                            'E-Monev',
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppSizes.sm),
                  
                  // Service Sections
                  ServiceSection(
                    title: 'NUSAHUMA',
                    icon: 'assets/images/icon-nusahuma.png',
                    description: 'SPPD, Cuti, Presensi, Pelatihan, Pengobatan',
                    services: [
                      ServiceItem(
                        icon: Icons.flight,
                        title: 'SPPD',
                        subtitle: 'Perjalanan Dinas',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'sppd',
                            'SPPD',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.event_available,
                        title: 'Cuti',
                        subtitle: 'Permohonan Cuti',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'cuti',
                            'Cuti',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.schedule,
                        title: 'Presensi',
                        subtitle: 'Kehadiran Pegawai',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'presensi',
                            'Presensi',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.school,
                        title: 'Pelatihan',
                        subtitle: 'Permohonan Pelatihan',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'pelatihan',
                            'Pelatihan',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.medical_services,
                        title: 'Pengobatan',
                        subtitle: 'Permohonan Medical',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'pengobatan',
                            'Pengobatan',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.sm),
                  ServiceSection(
                    title: 'NUSAREKA',
                    icon: 'assets/images/icon-nusareka.png',
                    description: 'Surat masuk, Koreksi Surat, Kotak Keluar, Disposisi, Filing',
                    services: [
                      ServiceItem(
                        icon: Icons.inbox,
                        title: 'Surat masuk',
                        subtitle: 'Surat Masuk',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'surat masuk',
                            'Surat Masuk',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.edit,
                        title: 'Koreksi Surat',
                        subtitle: 'Koreksi Surat',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'koreksi surat',
                            'Koreksi SUrat',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.outbox,
                        title: 'Surat Keluar',
                        subtitle: 'Surat Keluar',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'surat keluar',
                            'Surat Keluar',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.forward,
                        title: 'Disposisi',
                        subtitle: 'Disposisi',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'disposisi',
                            'Disposisi',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.folder,
                        title: 'Filing',
                        subtitle: 'Pengarsipan',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'pengarsipan',
                            'Filing',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.sm),

                  ServiceSection(
                    title: 'NUSAPROC',
                    icon: 'assets/images/icon-nusaproc.png',
                    description: 'PR & PPAB, HPS, Pengadaan',
                    services: [
                      ServiceItem(
                        icon: Icons.request_page,
                        title: 'PR & PPAB',
                        subtitle: 'Processing Request & PPAB',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PRMenuScreen(),
                            ),
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.calculate,
                        title: 'HPS',
                        subtitle: 'Harga Perkiraan Sendiri',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HPSMenuScreen(),
                            ),
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.shopping_cart,
                        title: 'Pengadaan',
                        subtitle: 'Pengadaan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PengadaanMenuScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.sm),
                  
                  ServiceSection(
                    title: 'NUSAFINA',
                    icon: 'assets/images/icon-nusafina.png',
                    description: 'SPP, Voucher, Register',
                    services: [
                      ServiceItem(
                        icon: Icons.payment,
                        title: 'SPP',
                        subtitle: 'SPP',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'spp',
                            'SPP',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.confirmation_number,
                        title: 'Voucher',
                        subtitle: 'Voucher',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'voucher',
                            'Voucher',
                          );
                        },
                      ),
                      ServiceItem(
                        icon: Icons.app_registration,
                        title: 'Register',
                        subtitle: 'Register',
                        onTap: () {
                          NavigationHelper.navigateToFeature(
                            context,
                            'register',
                            'Register',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.xl),
                  
                  // Extra spacing for FAB
                  SizedBox(height: AppSizes.xl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Navigate to profile screen when profile tab is selected
          if (index == 3) {
            context.push('/profile');
          }
        },
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 39, 228, 109),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              _launchHelpdesk();
            },
            child: const Center(
              child: Icon(
                Icons.headset_mic,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

