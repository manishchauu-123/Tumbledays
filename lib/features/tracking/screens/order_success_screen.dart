import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String? orderId;

  const OrderSuccessScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final order = state.activeTrackingOrder;

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: false,
        customTitle: Text(
          'Booking Confirmed',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Confetti + big green check circle
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.lightGreenBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 56, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 14),

            // "Order Placed Successfully!"
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),

            // Order ID with copy icon + placed timestamp + total + "Paid via UPI"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Order ID: ${order.id}',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: AppColors.primaryGreen),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: order.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied ${order.id}')),
                    );
                  },
                ),
              ],
            ),
            Text(
              'Total: ₹${order.totalAmount.toStringAsFixed(0)} • Paid via ${order.paymentMethod}',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
            ),

            const SizedBox(height: 20),

            // 5-step horizontal progress (Order Placed done, rest Pending)
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress Timeline', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _timelineStep('Placed', true, isFirst: true),
                      _timelineStep('Picked', false),
                      _timelineStep('Wash', false),
                      _timelineStep('Out', false),
                      _timelineStep('Delivered', false, isLast: true),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pickup Details + Pickup Address card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup & Delivery Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Text('${order.pickupDate} (${order.pickupSlot})', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(order.address, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // "Sit Back and Relax!" illustration strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.electric_moped, color: AppColors.primaryGreen, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sit Back and Relax!', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                        Text('Our rider will bring tamper-proof eco bags to your doorstep', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Yellow "Track Your Order →" + outlined "Continue Shopping"
            PrimaryCTAButton(
              text: 'Track Your Order',
              onPressed: () => context.go('/tracking/${order.id}'),
            ),

            const SizedBox(height: 12),

            SecondaryCTAButton(
              text: 'Continue Shopping',
              onPressed: () => context.go('/home'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _timelineStep(String label, bool isDone, {bool isFirst = false, bool isLast = false}) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDone ? AppColors.primaryGreen : AppColors.cardBorder,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: isDone ? 14 : 8,
            color: isDone ? Colors.white : AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
            color: isDone ? AppColors.primaryGreen : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
