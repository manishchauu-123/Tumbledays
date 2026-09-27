import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group 1: "App Preferences" (Notifications toggle ON, Dark Mode toggle OFF, Language → English, Location → Lucknow)
            Text(
              'App Preferences',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Push Notifications', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Pickup reminders and order progress', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                    value: true,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (val) {},
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  SwitchListTile(
                    title: Text('Dark Mode', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Switch app color theme', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                    value: state.isDarkMode,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (val) => state.toggleDarkMode(),
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  ListTile(
                    title: Text('App Language', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: Text('English ▾', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  ListTile(
                    title: Text('Service City', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: Text('Lucknow ▾', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Group 2: "Account Settings" (Edit Profile, Change Password, Saved Addresses, Payment Methods, Delete Account in red)
            Text(
              'Account Settings',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _settingTile(Icons.person_outline, 'Edit Profile', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile sheet opened')),
                    );
                  }),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _settingTile(Icons.lock_outline, 'Change Password', () {}),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _settingTile(Icons.location_on_outlined, 'Saved Addresses', () => context.push('/select-address')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _settingTile(Icons.credit_card_outlined, 'Payment Methods', () => context.push('/payment')),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: AppColors.statusRed, size: 20),
                    title: Text('Delete Account', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.statusRed)),
                    trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.statusRed),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Delete Account?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.statusRed)),
                          content: Text(
                            'Are you sure you want to permanently delete your Tumbledays account? All history and passes will be removed.',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusRed, foregroundColor: Colors.white),
                              onPressed: () {
                                Navigator.pop(ctx);
                                state.logout();
                                context.go('/auth');
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Group 3: "Support & Legal" (Privacy Policy, Terms & Conditions, About App v1.0.0)
            Text(
              'Support & Legal',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _settingTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _settingTile(Icons.description_outlined, 'Terms & Conditions', () {}),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _settingTile(Icons.info_outline, 'About App (v1.0.0)', () => context.push('/about')),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Light green "Logout" button
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  state.logout();
                  context.go('/auth');
                },
                icon: const Icon(Icons.logout, color: AppColors.primaryGreen, size: 18),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGreenBg,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen, size: 20),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textGrey),
      onTap: onTap,
    );
  }
}
