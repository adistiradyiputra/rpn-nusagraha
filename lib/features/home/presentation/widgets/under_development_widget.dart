import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class UnderDevelopmentWidget extends StatelessWidget {
  const UnderDevelopmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/lottie/icon-maintenence.json',
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(height: AppSizes.xl),
          
          // Text
          Text(
            'Sedang Dalam Pengembangan',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
