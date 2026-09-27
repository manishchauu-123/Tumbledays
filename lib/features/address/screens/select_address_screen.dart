import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Select Address',
          style: AppTheme.cardTitle.copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Two tabs "Pickup Address | Delivery Address"
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryGreen,
              indicatorWeight: 3,
              labelColor: AppColors.primaryGreen,
              unselectedLabelColor: AppColors.textGrey,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(text: 'Pickup Address'),
                Tab(text: 'Delivery Address'),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: AppTheme.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reusable AddressCard widgets
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppTheme.gapBetweenCards),
                    itemBuilder: (context, index) {
                      final addr = state.addresses[index];
                      final isSel = addr.id == state.currentAddress.id;

                      return AddressCard(
                        tag: addr.tag,
                        flat: addr.flat,
                        street: addr.street,
                        city: addr.city,
                        pincode: addr.pincode,
                        isSelected: isSel,
                        isDefault: addr.isDefault,
                        onTap: () => state.selectAddress(addr),
                        onEdit: () => context.push('/address-form'),
                        onDelete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address deleted')),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.gapBetweenCards),

                  // Dashed "+ Add New Address" card
                  InkWell(
                    onTap: () => context.push('/address-form'),
                    borderRadius: AppTheme.cardRadius,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppTheme.cardRadius,
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '+ Add New Address',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.gapBetweenCards),

                  // Reusable InfoStrip
                  const InfoStrip(
                    icon: Icons.done_all,
                    title: 'Hassle-Free Doorstep Delivery',
                    subtitle: 'Our executive collects laundry in tagged tamper-proof bags',
                  ),

                  const SizedBox(height: 24),

                  // Reusable PrimaryButton
                  PrimaryButton(
                    text: 'Proceed to Pickup Date & Time',
                    onPressed: () => context.push('/schedule'),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
