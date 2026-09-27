import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'About Us',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Cleaner Clothes. Happier Days." subtitle
            Text(
              'About Tumbledays',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            Text(
              'Cleaner Clothes. Happier Days.',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
            ),

            const SizedBox(height: 16),

            // Logo hero card with leaves and "Fresh Clothes. A Better You."
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: Icon(Icons.eco, size: 100, color: Colors.white.withOpacity(0.08)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TumbledaysLogo(size: 24, isWhite: true),
                      const SizedBox(height: 12),
                      Text(
                        'Fresh Clothes. A Better You.',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Redefining everyday fabric care with zero-compromise hygiene and environmental sustainability.',
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Intro paragraph
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tumbledays is Lucknow’s leading tech-driven doorstep laundry and dry-cleaning service. Built with love for garment longevity, our centralized facility utilizes eco-friendly organic solvents, hypo-allergenic formulas, and precise automated steam presses to ensure your clothing looks brand new every single wash.',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, height: 1.5),
              ),
            ),

            const SizedBox(height: 16),

            // Three cards: Our Mission / Our Vision / Our Values (values as green check list)
            _pillarCard(
              Icons.flag_outlined,
              'Our Mission',
              'To deliver immaculate laundry and dry cleaning to every doorstep in Lucknow with speed, integrity, and transparent per-item pricing.',
            ),
            const SizedBox(height: 12),
            _pillarCard(
              Icons.visibility_outlined,
              'Our Vision',
              'To become northern India’s most trusted household laundry partner through eco-friendly processing and seamless digital booking.',
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
                        child: const Icon(Icons.verified_outlined, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text('Our Values', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _checkValue('100% Individual Batch Hygiene (Never mixed with other laundry)'),
                  const SizedBox(height: 6),
                  _checkValue('Eco-Solvent Technology with Zero Toxic Discharge'),
                  const SizedBox(height: 6),
                  _checkValue('Up to 10x Garment Care Guarantee on every booking'),
                  const SizedBox(height: 6),
                  _checkValue('Punctual Doorstep Pickup & Fast 24-48h Return'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Closing strip "Together for a Cleaner, Greener Tomorrow."
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  'Together for a Cleaner, Greener Tomorrow.',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Copyright + Version 1.0.0
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2026 Tumbledays Laundry Services Pvt Ltd',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                  ),
                  Text(
                    'Version 1.0.0 (Build 1)',
                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _pillarCard(IconData icon, String title, String desc) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
                child: Icon(icon, color: AppColors.primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, height: 1.4)),
        ],
      ),
    );
  }

  Widget _checkValue(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 16, color: AppColors.primaryGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textDark)),
        ),
      ],
    );
  }
}
