import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  String _selectedFilter = 'Popular';
  final List<String> _filters = ['Popular', 'Wash & Fold', 'Dry Clean', 'Special Care'];

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'Everyday Casuals Wash',
      'tagline': 'Hygienic disinfectant wash & soft fold',
      'price': '₹69',
      'unit': '/kg',
      'ribbon': 'Most Popular',
      'features': ['Free antiseptic rinse', 'Fabric softener included', 'Separate individual drum'],
    },
    {
      'name': 'Executive Steam Iron',
      'tagline': 'High pressure industrial steam press',
      'price': '₹15',
      'unit': '/piece',
      'ribbon': 'Great Value',
      'features': ['Crisp collar & cuff pressing', 'Hanger / fold packing', 'Crease protection'],
    },
    {
      'name': 'Dry Clean Premium Care',
      'tagline': 'Suits, sarees, blazers & delicate fabrics',
      'price': '₹199',
      'unit': '/piece',
      'ribbon': 'Special Care',
      'features': ['Eco-solvent German chemicals', 'Stain spot treatment', 'Moth-proof packaging'],
    },
    {
      'name': 'Sneaker & Shoe Spa',
      'tagline': 'Deep scrubbing, deodorizing & sanitization',
      'price': '₹199',
      'unit': '/pair',
      'ribbon': 'Trending',
      'features': ['Sole & lace restoration', 'Anti-bacterial ozone spray', 'Shape retaining inserts'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Our Packages',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green promo banner "Clean More Save More" with "UP TO 30% OFF" badge and yellow "View Offers →"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(20),
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
                            'UP TO 30% OFF',
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Clean More Save More',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Subscribe to bulk monthly plans for max savings',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/offers'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaYellow,
                      foregroundColor: AppColors.textDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Offers', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 11)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Filter chips Popular / Wash & Fold / Dry Clean / Special Care
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

            // 2x2 package cards with corner ribbons "Most Popular" / "Great Value",
            // name, tagline, 3 green-check features, price, green "Select" button
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final p = _packages[index];

                return AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      // Corner Ribbon
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.ctaYellow,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p['ribbon'] as String,
                            style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.lightGreenBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.local_laundry_service, color: AppColors.primaryGreen, size: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            p['name'] as String,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p['tagline'] as String,
                            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          ...((p['features'] as List<String>).map((feat) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.check, size: 12, color: AppColors.primaryGreen),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textDark),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                p['price'] as String,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primaryGreen),
                              ),
                              Text(
                                p['unit'] as String,
                                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => context.push('/catalog'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text('Select', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Footer row "Free Pickup & Delivery on orders above ₹299"
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, color: AppColors.primaryGreen, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Free Doorstep Pickup & Delivery on all orders above ₹299 across Lucknow',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                    ),
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
}
