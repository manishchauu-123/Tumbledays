import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class AddressScreen extends StatefulWidget {
  final VoidCallback? onProceedToCart;
  final VoidCallback? onBack;

  const AddressScreen({
    super.key,
    this.onProceedToCart,
    this.onBack,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  void _showAddAddressSheet(BuildContext context) {
    String tag = 'Home';
    final flatController = TextEditingController();
    final streetController = TextEditingController();
    final landmarkController = TextEditingController();
    final pincodeController = TextEditingController(text: '226010');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add New Address',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                const SizedBox(height: 14),

                // Tag Chips
                Row(
                  children: ['Home', 'Office', 'Other'].map((t) {
                    final isSel = tag == t;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t),
                        selected: isSel,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: GoogleFonts.poppins(
                          color: isSel ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (val) {
                          if (val) setSheetState(() => tag = t);
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),
                TextField(
                  controller: flatController,
                  decoration: const InputDecoration(
                    labelText: 'Flat / House / Building Name',
                    hintText: 'e.g. Flat 301, Sunshine Residency',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street / Area / Sector',
                    hintText: 'e.g. Vibhuti Khand, Gomti Nagar',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: landmarkController,
                  decoration: const InputDecoration(
                    labelText: 'Landmark (Optional)',
                    hintText: 'e.g. Near Wave Mall',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    hintText: '226010',
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryCTAButton(
                  text: 'Save & Use This Address',
                  onPressed: () {
                    if (flatController.text.trim().isEmpty || streetController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill flat and street address details')),
                      );
                      return;
                    }

                    final newAddress = AddressModel(
                      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
                      tag: tag,
                      flat: flatController.text.trim(),
                      street: streetController.text.trim(),
                      landmark: landmarkController.text.trim(),
                      city: 'Lucknow',
                      pincode: pincodeController.text.trim(),
                    );

                    context.read<AppState>().addAddress(newAddress);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            context.pop();
          }
        },
        customTitle: Text(
          'Delivery Address',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper Widget: 3 numbered circles "Select Date & Time / Address Details / Confirm"
            const BookingStepperWidget(currentStep: 1),

            const SizedBox(height: 20),

            // Add New Address Secondary CTA
            SecondaryCTAButton(
              text: 'Add New Address in Lucknow',
              icon: Icons.add_location_alt_outlined,
              onPressed: () => _showAddAddressSheet(context),
            ),

            const SizedBox(height: 20),

            Text(
              'Select Saved Address',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Saved Address Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addr = state.addresses[index];
                final isSelected = addr.id == state.currentAddress.id;

                return AppCard(
                  onTap: () => state.selectAddress(addr),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.primaryGreen : AppColors.textGrey,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  addr.tag,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                if (addr.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreenBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'DEFAULT',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              addr.flat,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${addr.street}, ${addr.landmark}',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                            ),
                            Text(
                              '${addr.city} - ${addr.pincode}',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Primary CTA
            PrimaryCTAButton(
              text: 'Proceed to Bag Summary',
              onPressed: () {
                if (widget.onProceedToCart != null) {
                  widget.onProceedToCart!();
                } else {
                  context.push('/cart');
                }
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
