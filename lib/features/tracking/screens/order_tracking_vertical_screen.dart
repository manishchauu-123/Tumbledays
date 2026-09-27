import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class OrderTrackingVerticalScreen extends StatelessWidget {
  final String? orderId;

  const OrderTrackingVerticalScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final order = state.activeTrackingOrder;

    final steps = [
      {'title': 'Order Placed', 'time': 'Today, 09:30 AM', 'done': true},
      {'title': 'Picked Up', 'time': 'Today, 11:15 AM', 'done': true},
      {'title': 'In Process', 'time': 'Today, 02:45 PM', 'done': true},
      {'title': 'Out for Delivery (Current)', 'time': 'Estimated Today, 06:00 PM', 'done': true, 'current': true},
      {'title': 'Delivered', 'time': 'Pending', 'done': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.go('/home'),
        customTitle: Text(
          'Track Order',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + "Refresh" chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Order Status',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                ActionChip(
                  avatar: const Icon(Icons.refresh, size: 14, color: AppColors.primaryGreen),
                  label: Text('Refresh', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                  backgroundColor: AppColors.lightGreenBg,
                  side: BorderSide.none,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Status refreshed')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order ID card with Estimated Delivery
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${order.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      Text('Service: ${order.itemsSummary}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Estimated Delivery', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
                      Text(order.deliveryDate ?? 'Within 24h', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Vertical timeline with icon bubbles —
            // Order Placed, Picked Up, In Process, Out for Delivery (current, highlighted row), Delivered (pending grey)
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wash Lifecycle', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final s = steps[index];
                      final isDone = s['done'] as bool;
                      final isCurrent = s['current'] == true;
                      final isLast = index == steps.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? AppColors.ctaYellow
                                        : isDone
                                            ? AppColors.primaryGreen
                                            : const Color(0xFFE0E5E2),
                                    shape: BoxShape.circle,
                                    border: isCurrent ? Border.all(color: AppColors.textDark, width: 2) : null,
                                  ),
                                  child: Icon(
                                    isDone ? Icons.check : Icons.circle,
                                    size: 14,
                                    color: isCurrent ? AppColors.textDark : Colors.white,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: isDone && !isCurrent ? AppColors.primaryGreen : AppColors.cardBorder,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                                child: Container(
                                  padding: isCurrent ? const EdgeInsets.all(10) : EdgeInsets.zero,
                                  decoration: isCurrent
                                      ? BoxDecoration(
                                          color: AppColors.lightGreenBg,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.primaryGreen),
                                        )
                                      : null,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s['title'] as String,
                                        style: GoogleFonts.poppins(
                                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                                          fontSize: 13,
                                          color: isDone ? AppColors.textDark : AppColors.textGrey,
                                        ),
                                      ),
                                      Text(
                                        s['time'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: isCurrent ? AppColors.primaryGreen : AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
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

            const SizedBox(height: 16),

            // Delivery Partner card with avatar, name, rating, Call + WhatsApp circular buttons
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightGreenBg,
                    child: Icon(Icons.person, color: AppColors.primaryGreen, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.partnerName, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text('${order.partnerRating} Rating', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.call, color: Colors.white, size: 16),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${order.partnerPhone}')),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF2E7D32), shape: BoxShape.circle),
                      child: const Icon(Icons.chat, color: Colors.white, size: 16),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp with partner...')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // "Need Help? Contact Support" yellow strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.ctaYellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.headset_mic, color: AppColors.textDark, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Need Help? Contact Support',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.push('/contact'),
                    child: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textDark),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Thank-you brand strip
            Center(
              child: Text(
                'Thank you for trusting Tumbledays with your garments!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
