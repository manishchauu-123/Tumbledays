import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onOpenAddresses;
  final VoidCallback? onOpenOffers;
  final VoidCallback? onOpenSupport;
  final VoidCallback? onOpenOrders;
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    this.onOpenAddresses,
    this.onOpenOffers,
    this.onOpenSupport,
    this.onOpenOrders,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: false,
        customTitle: Text(
          'Profile',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Avatar with camera badge, name, phone, email, "Edit Profile" chip
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.lightGreenBg,
                        child: Text(
                          state.user.name.substring(0, 1),
                          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user.name,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark),
                        ),
                        Text(
                          state.user.phone,
                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                        ),
                        Text(
                          state.user.email,
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  ActionChip(
                    label: Text('Edit', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    backgroundColor: AppColors.lightGreenBg,
                    side: BorderSide.none,
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // "Tumbledays Plus — Gold Member" membership card with crown icon and 4 benefit icons
            // (Free Pickup & Delivery, Exclusive Discounts, Priority Service, Special Offers)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium, color: AppColors.ctaYellow, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Tumbledays Plus — Gold Member',
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.ctaYellow, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'ACTIVE',
                          style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _benefitItem(Icons.local_shipping, 'Free\nDelivery'),
                      _benefitItem(Icons.percent, 'Exclusive\nDiscounts'),
                      _benefitItem(Icons.bolt, 'Priority\nService'),
                      _benefitItem(Icons.card_giftcard, 'Special\nOffers'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // List rows with icon + title + subtitle + chevron:
            // My Orders, My Addresses, Payment Methods, My Coupons, Refer & Earn, Help & Support, Settings
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _navRow(Icons.receipt_long_outlined, 'My Orders', 'View all active & past laundry', () => context.go('/orders')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.location_on_outlined, 'My Addresses', 'Manage home and office spots', () => context.push('/select-address')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.credit_card_outlined, 'Payment Methods', 'Saved UPI, cards and wallets', () => context.push('/payment')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.local_offer_outlined, 'My Coupons', 'Available discounts & vouchers', () => context.push('/offers')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.share_outlined, 'Refer & Earn', 'Earn ₹100 for every friend joined', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral code TUMB77 copied!')),
                    );
                  }),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.headset_mic_outlined, 'Help & Support', 'WhatsApp chat & live resolution', () => context.push('/contact')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _navRow(Icons.settings_outlined, 'Settings', 'Preferences & account security', () => context.push('/settings')),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Green brand promo card
            const InfoStripCard(
              icon: Icons.eco,
              title: 'Clean Fresh Happier Days',
              subtitle: 'Lucknow’s first eco-conscious smart laundry platform',
            ),

            const SizedBox(height: 20),

            // Red outlined "Logout"
            SizedBox(
              height: 52,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  state.logout();
                  context.go('/auth');
                },
                icon: const Icon(Icons.logout, color: AppColors.statusRed, size: 18),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(color: AppColors.statusRed, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.statusRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.ctaYellow, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500, height: 1.1),
        ),
      ],
    );
  }

  Widget _navRow(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
      subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textGrey),
      onTap: onTap,
    );
  }
}
