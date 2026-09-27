import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class PickupScheduledScreen extends StatelessWidget {
  const PickupScheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final order = state.activeTrackingOrder;

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: false,
        customTitle: Text(
          'Pickup Scheduled',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Stepper all green (step 2 completed)
            const BookingStepperWidget(currentStep: 2),

            const SizedBox(height: 20),

            // Confetti check, "Pickup Scheduled!"
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.lightGreenBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 52, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              'Pickup Scheduled!',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            Text(
              'Our executive is assigned to your slot in Lucknow',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
            ),

            const SizedBox(height: 20),

            // Booking Details card with #order id and rows Service / Pickup Date / Pickup Time / Pickup Address
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                      Text(order.id, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const Divider(height: 18, color: AppColors.cardBorder),
                  _detailRow('Service', state.selectedService.title),
                  const SizedBox(height: 8),
                  _detailRow('Pickup Date', order.pickupDate),
                  const SizedBox(height: 8),
                  _detailRow('Pickup Time', order.pickupSlot),
                  const SizedBox(height: 8),
                  _detailRow('Pickup Address', order.address),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // "Sit back and relax" van illustration strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 36, color: AppColors.primaryGreen),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Sit back and relax while our certified rider comes to collect your laundry.',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Yellow "Track Your Order →"
            PrimaryCTAButton(
              text: 'Track Your Order',
              onPressed: () => context.go('/tracking/${order.id}'),
            ),

            const SizedBox(height: 12),

            // Two outlined buttons "Chat on WhatsApp" and "Call Us"
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp care...')),
                      );
                    },
                    icon: const Icon(Icons.chat, color: AppColors.primaryGreen, size: 18),
                    label: Text('WhatsApp', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dialing +91 80099 22000...')),
                      );
                    },
                    icon: const Icon(Icons.phone, color: AppColors.primaryGreen, size: 18),
                    label: Text('Call Us', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
