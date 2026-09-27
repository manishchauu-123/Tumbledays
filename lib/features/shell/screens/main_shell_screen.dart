import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../state/app_state.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/orders') || location.startsWith('/tracking')) return 1;
    if (location.startsWith('/contact')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.push('/contact');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final currentPath = GoRouterState.of(context).uri.path;
    final state = context.watch<AppState>();

    // Comprehensive list of all 21 screens for testing/demo preview
    final quickJumpScreens = [
      {'path': '/onboarding', 'label': '1. Onboarding / Splash'},
      {'path': '/auth', 'label': '2. Login / Signup'},
      {'path': '/home', 'label': '3. Home (Banner, 3x2, FAB)'},
      {'path': '/select-service', 'label': '5. Select Service (2x3)'},
      {'path': '/schedule', 'label': '6. Schedule Pickup (2x2 slots)'},
      {'path': '/address-form', 'label': '7. Pickup Address (Form)'},
      {'path': '/select-address', 'label': '8. Select Address (2 Tabs)'},
      {'path': '/cart', 'label': '9. Cart & Breakdown'},
      {'path': '/payment', 'label': '10. Payment (UPI/Cards)'},
      {'path': '/order-success/TD-8921', 'label': '11. Order Success (Confetti)'},
      {'path': '/pickup-scheduled', 'label': '12. Pickup Scheduled (Confirm)'},
      {'path': '/tracking-vertical/TD-8921', 'label': '13. Tracking (Vertical)'},
      {'path': '/tracking-horizontal/TD-8921', 'label': '14. Tracking (Map & Scooter)'},
      {'path': '/order-details/TD-8921', 'label': '15. Order Details'},
      {'path': '/packages', 'label': '16. Packages (2x2 ribbons)'},
      {'path': '/offers', 'label': '17. Offers & Discounts'},
      {'path': '/profile', 'label': '18. Profile (Gold Member)'},
      {'path': '/settings', 'label': '19. Settings (3 Groups)'},
      {'path': '/contact', 'label': '20. Contact Us (4 Tiles)'},
      {'path': '/about', 'label': '21. About Us (Pillars)'},
    ];

    final matchedItem = quickJumpScreens.firstWhere(
      (item) => item['path'] == currentPath,
      orElse: () => quickJumpScreens[2],
    );

    final isHomeScreen = currentPath == '/home';

    return Scaffold(
      body: Column(
        children: [
          // Developer / Showcase Quick Navigation Switcher Banner
          Container(
            color: const Color(0xFF132B1B),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: AppColors.ctaYellow, size: 15),
                  const SizedBox(width: 6),
                  const Text(
                    'Preview Screen:',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: matchedItem['path'],
                        isDense: true,
                        dropdownColor: const Color(0xFF132B1B),
                        style: const TextStyle(
                          color: AppColors.ctaYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.ctaYellow, size: 18),
                        items: quickJumpScreens.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['path'],
                            child: Text(item['label']!),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) context.go(val);
                        },
                      ),
                    ),
                  ),
                  if (state.cartCount > 0)
                    InkWell(
                      onTap: () => context.push('/cart'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.ctaYellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag, size: 13, color: AppColors.textDark),
                            const SizedBox(width: 4),
                            Text(
                              '${state.cartCount}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),

      // Centered raised circular yellow FAB labeled "Book" overlapping the bottom bar on Home
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isHomeScreen
          ? Container(
              margin: const EdgeInsets.only(top: 24),
              height: 64,
              width: 64,
              child: FloatingActionButton(
                onPressed: () => context.push('/select-service'),
                backgroundColor: AppColors.ctaYellow,
                elevation: 4,
                shape: const CircleBorder(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_shopping_cart, color: AppColors.textDark, size: 22),
                    Text(
                      'Book',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,

      // Navigation: Bottom nav 4 items (Home, Orders, WhatsApp, Profile), active item primaryGreen, inactive grey
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: isHomeScreen ? const CircularNotchedRectangle() : null,
          notchMargin: 8,
          color: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => _onItemTapped(0, context),
              ),
              _buildNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Orders',
                isSelected: selectedIndex == 1,
                onTap: () => _onItemTapped(1, context),
              ),
              if (isHomeScreen) const SizedBox(width: 48), // gap for centered FAB
              _buildNavItem(
                icon: Icons.chat_outlined,
                activeIcon: Icons.chat,
                label: 'WhatsApp',
                isSelected: selectedIndex == 2,
                onTap: () => _onItemTapped(2, context),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isSelected: selectedIndex == 3,
                onTap: () => _onItemTapped(3, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppColors.primaryGreen : AppColors.textGrey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
