import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class OffersScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onGoToCart;

  const OffersScreen({
    super.key,
    this.onBack,
    this.onGoToCart,
  });

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String _selectedFilter = 'All Offers';
  final List<String> _filters = ['All Offers', 'First Order', 'Combo Offers', 'Seasonal', 'Refer & Earn'];

  final List<Map<String, dynamic>> _allOffers = [
    {
      'code': 'WELCOME30',
      'title': 'Flat 30% OFF on First Booking',
      'cond': 'Valid on orders above ₹299. Maximum discount ₹150.',
      'badge': 'First Order',
      'isYellow': true,
      'icon': Icons.local_offer,
    },
    {
      'code': 'TUMBLE20',
      'title': '20% OFF on Dry Clean & Ironing',
      'cond': 'Valid on all premium garment care above ₹399.',
      'badge': 'Popular',
      'isYellow': false,
      'icon': Icons.dry_cleaning,
    },
    {
      'code': 'FREESHIP',
      'title': 'Free Express Doorstep Delivery',
      'cond': 'Instant waiver of ₹49 doorstep delivery fee.',
      'badge': 'Seasonal',
      'isYellow': true,
      'icon': Icons.local_shipping,
    },
    {
      'code': 'CLEAN50',
      'title': 'Flat ₹50 OFF on Shoe Cleaning',
      'cond': 'Deep scrub and sanitization for sports/leather shoes.',
      'badge': 'Special',
      'isYellow': false,
      'icon': Icons.roller_skating,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Offers & Discounts',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green hero "Get Flat 30% OFF — Use Code WELCOME30" with white "Book Now →"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.ctaYellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SPECIAL DEAL',
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get Flat 30% OFF',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Use Code: WELCOME30',
                          style: GoogleFonts.poppins(color: AppColors.ctaYellow, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/catalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Book Now', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Filter chips All Offers, First Order, Combo Offers, Seasonal, Refer & Earn
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isSel = f == _selectedFilter;

                  return ChoiceChip(
                    label: Text(f),
                    selected: isSel,
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: GoogleFonts.poppins(
                      color: isSel ? Colors.white : AppColors.textDark,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSel ? AppColors.primaryGreen : AppColors.cardBorder),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = f);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Offer rows alternating light-green/light-yellow backgrounds, each with circular icon,
            // title, condition line, copyable code chip, green "Apply" button, optional badge
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allOffers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final o = _allOffers[index];
                final isYellow = o['isYellow'] as bool;
                final isApplied = state.appliedCoupon?.code == o['code'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isYellow ? const Color(0xFFFFFDE7) : AppColors.lightGreenBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isYellow ? AppColors.ctaYellow.withOpacity(0.5) : AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: Icon(o['icon'] as IconData, color: AppColors.primaryGreen, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                o['title'] as String,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              o['badge'] as String,
                              style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        o['cond'] as String,
                        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                      ),
                      const Divider(height: 16, color: AppColors.cardBorder),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: o['code'] as String));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Code ${o['code']} copied!')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryGreen),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    o['code'] as String,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primaryGreen),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.copy, size: 14, color: AppColors.primaryGreen),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              state.applyCoupon(o['code'] as String);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Applied ${o['code']}!'), backgroundColor: AppColors.primaryGreen),
                              );
                              context.push('/cart');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApplied ? AppColors.primaryGreen : AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              elevation: 0,
                            ),
                            child: Text(
                              isApplied ? 'Applied' : 'Apply',
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
