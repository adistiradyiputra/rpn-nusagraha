import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/warning_dialog.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/login_request.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _showWarningDialogIfNeeded();
  }

  void _showWarningDialogIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenWarning = prefs.getBool('has_seen_warning') ?? false;
    
    if (!hasSeenWarning) {
      // Delay to ensure the screen is fully loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          WarningDialog.show(context);
          // Mark as seen
          prefs.setBool('has_seen_warning', true);
        }
      });
    }
  }
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final request = LoginRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      final success = await context.read<AuthProvider>().login(request);
      
      if (success && mounted) {
        context.go('/home');
      } else if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<AuthProvider>().errorMessage ?? 'Login gagal',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [                
                // Logo and Graphics combined
                _buildLogoAndGraphicsSection(),
                
                SizedBox(height: AppSizes.xs),
                
                // Welcome Message
                _buildWelcomeSection(),
                
                SizedBox(height: AppSizes.xs),
                
                // Login Form
                _buildLoginForm(),
                
                SizedBox(height: AppSizes.xs),
                
                // Remember Me and Forgot Password
                _buildOptionsSection(),
                
                SizedBox(height: AppSizes.xs),
                
                // Login Button
                _buildLoginButton(),
                
                // Copyright
                _buildCopyrightSection(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndGraphicsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        Container(
          width: AppSizes.loginLogo,
          height: AppSizes.loginLogo,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Image.asset(
              'assets/images/iconapp.png',
              fit: BoxFit.contain,
              width: AppSizes.loginLogo,
              height: AppSizes.loginLogo,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: AppSizes.loginLogo,
                  height: AppSizes.loginLogo,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: Icon(
                    Icons.image,
                    size: AppSizes.loginLogo * 0.5,
                    color: AppColors.primaryBlue,
                  ),
                );
              },
            ),
          ),
        ),
        // Graphics - benar-benar mepet dengan logo
        Transform.translate(
          offset: Offset(0, -50), // Tarik ke atas 10 pixel
          child: Container(
            width: double.infinity,
            height: 180,
            child: Image.asset(
              'assets/images/grafis-login.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Text(
          'Selamat Datang',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.xs),
        Text(
          'Silakan masuk untuk melanjutkan',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.md),
      ],
    );
  }
  

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _usernameController,
          labelText: 'Username',
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Username tidak boleh kosong';
            }
            return null;
          },
        ),
        SizedBox(height: AppSizes.lg),
        CustomTextField(
          controller: _passwordController,
          labelText: 'Password',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppColors.primaryBlue,
            ),
            Text(
              'Ingat saya',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to forgot password
          },
          child: Text(
            'Lupa Password?',
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return CustomButton(
          onPressed: authProvider.isLoading ? null : _handleLogin,
          text: authProvider.isLoading ? 'Memproses...' : 'Masuk',
          isLoading: authProvider.isLoading,
          width: double.infinity,
          height: 56,
        );
      },
    );
  }

  Widget _buildCopyrightSection() {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.sm, bottom: AppSizes.sm),
      child: Center(
        child: Text(
          'Copyright © 2023 PT Riset Perkebunan Nusantara',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
