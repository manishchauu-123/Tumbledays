import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const AuthScreen({super.key, this.onLoginSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9415012345');
  final TextEditingController _nameController = TextEditingController(text: 'Abhinav Saxena');
  final TextEditingController _emailController = TextEditingController(text: 'abhinav@tumbledays.com');
  bool _isLoading = false;

  void _handleSubmit() {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        final state = context.read<AppState>();
        state.setPendingPhone(phone);
        state.updateUserProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
        state.verifyOtp('1234');
        setState(() => _isLoading = false);

        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!();
        } else {
          context.go('/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // White logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TumbledaysLogo(size: 24, isWhite: true),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // "Welcome Back" + "Let's get you started"
                Text(
                  'Welcome Back',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's get you started",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 24),

                // White rounded fields: phone with India flag + +91 prefix
                Text(
                  'Mobile Number',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.cardBorder)),
                        ),
                        child: Row(
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Text(
                              '+91',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            counterText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Full Name field
                Text(
                  'Full Name',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Abhinav Saxena',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Email Address field
                Text(
                  'Email Address',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'e.g. name@example.com',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Yellow "Submit →" button
                PrimaryCTAButton(
                  text: 'Submit',
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ),

                const SizedBox(height: 20),

                // "OR" divider
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: Colors.white24)),
                  ],
                ),

                const SizedBox(height: 20),

                // White "Continue with Google" button
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.g_mobiledata, size: 28, color: AppColors.textDark),
                    label: Text(
                      'Continue with Google',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // T&C + Privacy Policy links
                Center(
                  child: Text(
                    'By signing up, you agree to our Terms & Conditions and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 28),

                // Bottom illustration of folded towels with script tagline
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.ctaYellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.layers, color: AppColors.textDark, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScriptTaglineBadge(),
                            SizedBox(height: 2),
                            Text(
                              'Doorstep pickup across Lucknow',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
