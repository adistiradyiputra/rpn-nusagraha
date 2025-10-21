import 'package:flutter/material.dart';
import '../services/feature_service.dart';
import '../../features/home/presentation/screens/expert_system_screen.dart';
import '../../features/home/presentation/widgets/under_development_widget.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NavigationHelper {
  static final FeatureService _featureService = FeatureService();

  /// Navigasi dinamis berdasarkan status fitur
  static void navigateToFeature(
    BuildContext context,
    String featureKey,
    String featureTitle,
  ) {
    if (_featureService.isFeatureAvailable(featureKey)) {
      // Fitur tersedia, navigasi ke halaman fitur
      _navigateToFeaturePage(context, featureKey);
    } else {
      // Fitur belum tersedia, tampilkan maintenance page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.navyBlue,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                featureTitle,
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 0,
            ),
            body: const UnderDevelopmentWidget(),
          ),
        ),
      );
    }
  }

  /// Navigasi ke halaman fitur yang spesifik
  static void _navigateToFeaturePage(BuildContext context, String featureKey) {
    switch (featureKey) {
      case 'expert_system':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExpertSystemScreen(),
          ),
        );
        break;
      // Tambahkan case lain untuk fitur yang sudah tersedia
      default:
        // Fallback ke maintenance page jika tidak ada handler
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.navyBlue,
                leading: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Fitur',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                elevation: 0,
              ),
              body: const UnderDevelopmentWidget(),
            ),
          ),
        );
    }
  }

  /// Mengecek status fitur
  static bool isFeatureAvailable(String featureKey) {
    return _featureService.isFeatureAvailable(featureKey);
  }
}
