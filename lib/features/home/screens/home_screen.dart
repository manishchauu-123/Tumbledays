import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/app_drawer.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  final Function(ServiceItem)? onSelectService;
  final VoidCallback? onOpenAddress;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenOffers;

  const HomeScreen({
    super.key,
    this.onSelectService,
    this.onOpenAddress,
    this.onOpenCart,
    this.onOpenOffers,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.mintTint,
      drawer: const AppDrawer(),
      appBar: AppHeader(
        showBack: false,
        onMenu: () => scaffoldKey.currentState?.openDrawer(),
        onNotification: () => context.push('/offers'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location selector "Lucknow ▾" with pin icon
              InkWell(
                onTap: () => context.push('/select-address'),
                borderRadius: AppTheme.cardRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTheme.cardRadius,
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Lucknow ▾',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${state.currentAddress.tag} (${state.currentAddress.street})',
                          style: AppTheme.cardBody.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'CHANGE',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.gapBetweenCards),

              // Reusable HeroBannerStack with CustomPaint leaf/wave background
              HeroBannerStack(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 78,
                        height: 78,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.ctaYellow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'FLAT 20% OFF\nOn First Order',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ONE-STOP SOLUTION FOR\nALL YOUR LAUNDRY NEEDS',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _bannerFeatureLine(Icons.dry_cleaning, 'Expert Dry Cleaning & Organic Care'),
                            const SizedBox(height: 4),
                            _bannerFeatureLine(Icons.local_laundry_service, 'Wash, Fold & Steam Ironing'),
                            const SizedBox(height: 4),
                            _bannerFeatureLine(Icons.roller_skating, 'Shoe Deep Scrub & Sanitization'),
                            const SizedBox(height: 4),
                            _bannerFeatureLine(Icons.bed, 'Curtain & Home Linen Care'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.push('/schedule'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(borderRadius: AppTheme.pillRadius),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Book a Pickup',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 5 dots indicator for banner carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == 0 ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == 0 ? AppColors.primaryGreen : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.gapBetweenCards),

              // Reusable SectionTitle
              SectionTitle(
                title: 'Select Service',
                actionText: 'View All',
                onActionTap: () => context.push('/select-service'),
              ),

              // 3x2 grid of service tiles
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  final isSelected = state.selectedService.id == service.id;

                  return InkWell(
                    onTap: () {
                      state.selectService(service);
                      context.push('/catalog/${service.id}');
                    },
                    borderRadius: AppTheme.cardRadius,
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.cardPadding),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.lightGreenBg : Colors.white,
                        borderRadius: AppTheme.cardRadius,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3), width: 1.5),
                                  color: AppColors.lightGreenBg,
                                ),
                                child: Icon(service.icon, color: AppColors.primaryGreen, size: 22),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 18),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            service.title,
                            style: AppTheme.cardTitle.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.startingPrice,
                            style: AppTheme.priceStyle.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppTheme.gapBetweenCards),

              // Reusable FeatureRow
              const FeatureRow(),

              const SizedBox(height: AppTheme.gapBetweenCards),

              // Yellow Special Offer banner
              GestureDetector(
                onTap: () => context.push('/offers'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.ctaYellow,
                    borderRadius: AppTheme.cardRadius,
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_offer, color: AppColors.textDark, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Special Offer — Get 20% OFF',
                              style: AppTheme.cardTitle,
                            ),
                            Text(
                              'Use code: TUMBLE20 on your booking',
                              style: AppTheme.cardBody.copyWith(fontSize: 11, color: AppColors.textDark),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textDark),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerFeatureLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.ctaYellow),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
