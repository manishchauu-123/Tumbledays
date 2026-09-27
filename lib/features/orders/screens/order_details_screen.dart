import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String? orderId;

  const OrderDetailsScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final order = state.activeTrackingOrder;

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Order Details',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID card with status pill + estimated delivery
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.id, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreenBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status.displayName,
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Estimated Delivery: ${order.deliveryDate ?? 'Within 48 hours'}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Horizontal 5-node stepper with timestamps
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _timeStep('Placed', '09:00 AM', true),
                  _timeStep('Picked', '11:15 AM', true),
                  _timeStep('Wash', '02:30 PM', true),
                  _timeStep('Iron', '--:--', false),
                  _timeStep('Delivery', '--:--', false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Items list with thumbnails/service/qty/price + "View All"
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                      Text('View All', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.dry_cleaning, color: AppColors.primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.itemsSummary, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('Service: Dry Clean & Steam Press', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Text('₹${order.subtotal.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pickup & Delivery Details card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup & Delivery Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Text('Pickup Date: ${order.pickupDate} (${order.pickupSlot})', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 4),
                  Text('Address: ${order.address}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Details card with method + paid-on + total + "Payment Successful" badge
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'Payment Successful',
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Method: ${order.paymentMethod}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  Text('Total Paid: ₹${order.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Special Instructions strip
            const InfoStripCard(
              icon: Icons.note_alt_outlined,
              title: 'Special Instructions',
              subtitle: 'Handle silk saree with extra steam press; hang blazers in dust covers',
            ),

            const SizedBox(height: 24),

            // Bottom actions: "Download Invoice", "Reorder", green "Need Help?"
            Row(
              children: [
                Expanded(
                  child: SecondaryCTAButton(
                    text: 'Invoice',
                    icon: Icons.download,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tax invoice downloaded!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryCTAButton(
                    text: 'Reorder',
                    onPressed: () => context.push('/catalog'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: () => context.push('/contact'),
                icon: const Icon(Icons.help_outline, color: AppColors.primaryGreen, size: 18),
                label: Text(
                  'Need Help with this Order?',
                  style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _timeStep(String name, String time, bool isDone) {
    return Column(
      children: [
        Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? AppColors.primaryGreen : AppColors.textGrey, size: 18),
        const SizedBox(height: 2),
        Text(name, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: isDone ? AppColors.textDark : AppColors.textGrey)),
        Text(time, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textGrey)),
      ],
    );
  }
}
