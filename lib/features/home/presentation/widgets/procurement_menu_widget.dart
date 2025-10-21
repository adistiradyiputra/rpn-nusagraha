import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../screens/pr_history_screen.dart';
import '../screens/ppab_history_screen.dart';
import '../screens/hps_history_screen.dart';
import '../screens/pengadaan_history_screen.dart';
import '../screens/pr_approval_history_screen.dart';
import '../screens/ppab_approval_history_screen.dart';
import '../screens/hps_approval_history_screen.dart';
import '../screens/pengadaan_approval_history_screen.dart';
import '../screens/approval_screen.dart';
import 'procurement_history_widget.dart';
import 'under_development_widget.dart';

class MenuItem {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class ProcurementMenuWidget extends StatelessWidget {
  final String serviceName;
  final String serviceKey;

  const ProcurementMenuWidget({
    super.key,
    required this.serviceName,
    required this.serviceKey,
  });

  @override
  Widget build(BuildContext context) {
    // Get the appropriate icon based on service
    IconData serviceIcon;
    switch (serviceKey) {
      case 'pr':
        serviceIcon = Icons.request_page;
        break;
      case 'ppab':
        serviceIcon = Icons.assessment;
        break;
      case 'hps':
        serviceIcon = Icons.calculate;
        break;
      case 'pengadaan':
        serviceIcon = Icons.shopping_cart;
        break;
      case 'spp':
        serviceIcon = Icons.payment;
        break;
      default:
        serviceIcon = Icons.work;
    }

    final menuItems = [
      MenuItem(
        icon: Icons.check_circle,
        iconColor: Colors.orange,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        title: 'Perlu Approval',
        subtitle: 'Setujui pengajuan',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApprovalScreen(),
            ),
          );
        },
      ),
      MenuItem(
        icon: Icons.assignment,
        iconColor: Colors.purple,
        backgroundColor: Colors.purple.withValues(alpha: 0.1),
        title: 'Riwayat Approval',
        subtitle: 'Riwayat persetujuan',
        onTap: () {
          // Navigate to approval history screen
          Widget approvalHistoryScreen;
          switch (serviceKey) {
            case 'pr':
              approvalHistoryScreen = const PRApprovalHistoryScreen();
              break;
            case 'ppab':
              approvalHistoryScreen = const PPABApprovalHistoryScreen();
              break;
            case 'hps':
              approvalHistoryScreen = const HPSApprovalHistoryScreen();
              break;
            case 'pengadaan':
              approvalHistoryScreen = const PengadaanApprovalHistoryScreen();
              break;
            default:
              approvalHistoryScreen = Scaffold(
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
                    'Riwayat Approval $serviceName',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: const UnderDevelopmentWidget(),
              );
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => approvalHistoryScreen),
          );
        },
      ),
      MenuItem(
        icon: Icons.history,
        iconColor: Colors.blue,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        title: 'Permohonan Saya',
        subtitle: 'Lihat permohonan saya',
        onTap: () {
          // Navigate to history screen
          Widget historyScreen;
          switch (serviceKey) {
            case 'pr':
              historyScreen = const PRHistoryScreen();
              break;
            case 'ppab':
              historyScreen = const PPABHistoryScreen();
              break;
            case 'hps':
              historyScreen = const HPSHistoryScreen();
              break;
            case 'pengadaan':
              historyScreen = const PengadaanHistoryScreen();
              break;
            case 'spp':
              historyScreen = const ProcurementHistoryWidget(
                serviceName: 'SPP',
                serviceKey: 'spp',
              );
              break;
            default:
              historyScreen = Scaffold(
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
                    'Permohonan Saya $serviceName',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: const UnderDevelopmentWidget(),
              );
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => historyScreen),
          );
        },
      ),
    ];

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
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(serviceIcon, color: Colors.white),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Menu $serviceName',
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: AppSizes.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.backgroundColor,
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: item.onTap,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
