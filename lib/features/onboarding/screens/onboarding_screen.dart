import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onGetStarted;

  const OnboardingScreen({super.key, this.onGetStarted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> _featureRows = [
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Free Pickup\n& Delivery',
    },
    {
      'icon': Icons.verified_user_outlined,
      'title': 'Trusted\n& Secure',
    },
    {
      'icon': Icons.eco_outlined,
      'title': 'Eco-Friendly\nCleaning',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F2),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFF1F8F2),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Top Right Badge
              Positioned(
                top: 10,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Clean', style: GoogleFonts.caveat(fontSize: 22, color: AppColors.primaryGreen, height: 0.8, fontWeight: FontWeight.bold)),
                        Text('Fresh', style: GoogleFonts.caveat(fontSize: 22, color: AppColors.primaryGreen, height: 0.8, fontWeight: FontWeight.bold)),
                        Text('Confident', style: GoogleFonts.caveat(fontSize: 22, color: AppColors.primaryGreen, height: 0.8, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.eco, color: AppColors.primaryGreen, size: 28),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50), // space for badge

                    // Big Tumbledays Logo + Slogan
                    const TumbledaysLogo(size: 40),
                    const SizedBox(height: 4),
                    Text(
                      'CLEANER CLOTHES. HAPPIER DAYS.',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Headline
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fresh Clothes\nBrighter Days',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          height: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Premium Laundry & Dry Cleaning\nat Your Convenience',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Yellow divider
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.ctaYellow,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Features and Image Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Features
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _featureRows.map((f) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGreenBg,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(f['icon'] as IconData, color: AppColors.primaryGreen, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        f['title'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // Right: Illustration Container
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 220,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(-5, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Placeholder for washing machine
                                Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.local_laundry_service, size: 64, color: Colors.grey),
                                  ),
                                ),
                                // Placeholder for basket
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    width: 70,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreenBg,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.primaryGreen),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.shopping_basket, size: 32, color: AppColors.primaryGreen),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 3 page-indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 8 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.primaryGreen : AppColors.cardBorder,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Yellow "Get Started →" pill button
                    PrimaryCTAButton(
                      text: 'Get Started',
                      onPressed: () => context.go('/auth'),
                    ),

                    const SizedBox(height: 16),

                    // Footer "Powered by Tumbledays"
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                        children: [
                          const TextSpan(text: 'Powered by '),
                          TextSpan(text: 'Tumble', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                          TextSpan(text: 'days', style: TextStyle(color: AppColors.ctaYellow, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
