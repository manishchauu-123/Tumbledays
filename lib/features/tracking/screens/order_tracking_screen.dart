import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String? orderId;
  final VoidCallback? onBackToHome;
  final VoidCallback? onOpenHistory;

  const OrderTrackingScreen({
    super.key,
    this.orderId,
    this.onBackToHome,
    this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    if (orderId != null && orderId != state.activeTrackingOrder.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.setActiveTrackingOrderById(orderId!);
      });
    }

    final order = state.activeTrackingOrder;
    final currentStep = order.status.stepIndex;

    final steps = [
      {'title': 'Booked', 'desc': 'Pickup slot reserved & assigned', 'icon': Icons.check_circle},
      {'title': 'Picked Up', 'desc': 'Garments safely collected in eco bag', 'icon': Icons.local_shipping},
      {'title': 'In Process', 'desc': 'Eco-washing, steam press & quality inspection', 'icon': Icons.local_laundry_service},
      {'title': 'Out for Delivery', 'desc': 'Executive on the way to your doorstep', 'icon': Icons.delivery_dining},
      {'title': 'Delivered', 'desc': 'Fresh garments delivered to your hands', 'icon': Icons.task_alt},
    ];

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () {
          if (onBackToHome != null) {
            onBackToHome!();
          } else {
            context.go('/home');
          }
        },
        customTitle: Text(
          'Track Order ${order.id}',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Success Header Banner with Leaf Motif
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.done_all, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ${order.status.displayName}',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estimated Delivery: ${order.deliveryDate ?? 'Within 48 hours'}',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live 5-Step Vertical Stepper
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Wash Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 18),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final s = steps[index];
                      final isCompleted = index <= currentStep;
                      final isCurrent = index == currentStep;
                      final isLast = index == steps.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isCompleted ? AppColors.primaryGreen : const Color(0xFFE0E5E2),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      if (isCurrent)
                                        BoxShadow(
                                          color: AppColors.primaryGreen.withOpacity(0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Icon(
                                    s['icon'] as IconData,
                                    size: 16,
                                    color: isCompleted ? Colors.white : AppColors.textGrey,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: isCompleted && index < currentStep ? AppColors.primaryGreen : AppColors.cardBorder,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          s['title'] as String,
                                          style: GoogleFonts.poppins(
                                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                                            fontSize: 14,
                                            color: isCompleted ? AppColors.textDark : AppColors.textGrey,
                                          ),
                                        ),
                                        if (isCurrent) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.ctaYellow,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text('CURRENT', style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s['desc'] as String,
                                      style: GoogleFonts.poppins(fontSize: 11, color: isCompleted ? AppColors.textGrey : const Color(0xFF9EABA3)),
                                    ),
                                  ],
                                ),
                              ),
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

            // Assigned Rider & Partner Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightGreenBg,
                    child: Icon(Icons.delivery_dining, color: AppColors.primaryGreen, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.partnerName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${order.partnerRating} (Verified Rider)',
                              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling rider at ${order.partnerPhone}')),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.call, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Booking Overview AppCard
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Overview', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Text('Items: ${order.itemsSummary}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, height: 1.4)),
                  const Divider(height: 16, color: AppColors.cardBorder),
                  Text('Pickup: ${order.pickupDate} (${order.pickupSlot})', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 4),
                  Text('Address: ${order.address}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  const Divider(height: 16, color: AppColors.cardBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount Paid (${order.paymentMethod})', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      Text('₹${order.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Secondary CTA: Back to Home
            SecondaryCTAButton(
              text: 'Back to Home',
              icon: Icons.home_outlined,
              onPressed: () => context.go('/home'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
