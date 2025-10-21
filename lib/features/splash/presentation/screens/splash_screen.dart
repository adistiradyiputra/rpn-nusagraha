import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));


  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      _logoController.forward();
      
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _textController.forward();
      }
      
      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        // Ensure token is loaded before navigation
        await ApiService.loadToken();
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    if (ApiService.token != null) {
      // User is already logged in, check auth status and go to home
      _checkAuthAndNavigate();
    } else {
      // No token, go to login
      context.go('/login');
    }
  }

  void _checkAuthAndNavigate() async {
    // Get AuthProvider and check auth status
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();
    if (mounted) {
      if (authProvider.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: AppSizes.logoLarge,
                    height: AppSizes.logoLarge,
                    
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      child: Image.asset(
                        'assets/images/iconapp.png',
                        fit: BoxFit.contain,
                        width: AppSizes.logoLarge,
                        height: AppSizes.logoLarge,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: AppSizes.logoLarge,
                            height: AppSizes.logoLarge,
                            
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // App Name Animation
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -95 + (10 * _textAnimation.value)),
                  child: Opacity(
                    opacity: _textAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          'One Touch Thousand Growth',
                          style: AppTextStyles.h3.copyWith(
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  AppColors.primaryGreen,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Loading Indicator
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBlue,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
