import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Green gradient header with avatar, "Login Required / Sign in to explore more" + chevron
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                context.push('/auth');
              },
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login Required',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Sign in to explore more',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),

          // White list with green icons:
          // Home, Promotion & Offers, Request Pickup, Price List, Contact Us, About Us, Call Us, Share App, Settings, Log In
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerItem(context, Icons.home_outlined, 'Home', () => context.go('/home')),
                _drawerItem(context, Icons.local_offer_outlined, 'Promotion & Offers', () => context.push('/offers')),
                _drawerItem(context, Icons.local_shipping_outlined, 'Request Pickup', () => context.push('/schedule')),
                _drawerItem(context, Icons.category_outlined, 'Price List / Packages', () => context.push('/packages')),
                _drawerItem(context, Icons.headset_mic_outlined, 'Contact Us', () => context.push('/contact')),
                _drawerItem(context, Icons.info_outline, 'About Us', () => context.push('/about')),
                _drawerItem(context, Icons.phone_outlined, 'Call Us (+91 80099 22000)', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialing +91 80099 22000...')),
                  );
                }),
                _drawerItem(context, Icons.share_outlined, 'Share App', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied to clipboard!')),
                  );
                }),
                _drawerItem(context, Icons.settings_outlined, 'Settings', () => context.push('/settings')),
                const Divider(height: 16, color: AppColors.cardBorder),
                _drawerItem(context, Icons.login, 'Log In / Register', () => context.push('/auth'), isGreen: true),
              ],
            ),
          ),

          // Bottom promo card "Clean Fresh Happier Days — Your Trusted Laundry Partner" & "Version: 1.0.0 (1)"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.lightGreenBg,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const TumbledaysLogo(size: 16),
                    const Spacer(),
                    Text(
                      'v1.0.0 (1)',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Clean Fresh Happier Days — Your Trusted Laundry Partner in Lucknow',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isGreen = false}) {
    return ListTile(
      leading: Icon(icon, color: isGreen ? AppColors.primaryGreen : AppColors.primaryGreen, size: 22),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: isGreen ? FontWeight.w700 : FontWeight.w500,
          color: isGreen ? AppColors.primaryGreen : AppColors.textDark,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      dense: true,
    );
  }
}
