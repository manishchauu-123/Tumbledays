import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class OrderTrackingHorizontalScreen extends StatelessWidget {
  final String? orderId;

  const OrderTrackingHorizontalScreen({super.key, this.orderId});

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
          'Live Tracking',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status pill "Picked Up"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Picked Up',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 5-node horizontal stepper with dates/times
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _node('Placed', '09:00', true),
                      _node('Picked', '11:15', true),
                      _node('Facility', '12:30', false, isCurrent: true),
                      _node('Wash', '--:--', false),
                      _node('Out', '--:--', false),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Green illustration strip "Your items have been picked up!"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your items have been picked up! On the way to our Lucknow Central Processing Unit.',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Static map card with route from "Your Location" to "Tumbledays Center"
            // and a scooter marker labeled "On the way to Processing Center"
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Live Rider Route', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                      Text('ETA: 18 mins', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2EFE0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        // Map grid lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MapRoutePainter(),
                          ),
                        ),
                        // Start: Your Location
                        Positioned(
                          left: 20,
                          bottom: 25,
                          child: Row(
                            children: [
                              const Icon(Icons.my_location, color: AppColors.primaryGreen, size: 18),
                              const SizedBox(width: 4),
                              Text('Your Location', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                            ],
                          ),
                        ),
                        // Scooter Marker
                        Positioned(
                          left: 120,
                          top: 40,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.ctaYellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'On the way to Processing Center',
                                  style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textDark),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                                child: const Icon(Icons.moped, color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ),
                        // Destination: Tumbledays Center
                        Positioned(
                          right: 20,
                          top: 25,
                          child: Row(
                            children: [
                              const Icon(Icons.business, color: Color(0xFF1B5E20), size: 18),
                              const SizedBox(width: 4),
                              Text('Tumbledays Center', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Partner card with rating
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.lightGreenBg,
                    child: Icon(Icons.person, color: AppColors.primaryGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.partnerName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
                        Text('Rider Partner • ⭐ ${order.partnerRating}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Outlined "Reschedule" + yellow "View Order Details"
            Row(
              children: [
                Expanded(
                  child: SecondaryCTAButton(
                    text: 'Reschedule',
                    onPressed: () => context.push('/schedule'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryCTAButton(
                    text: 'Order Details',
                    onPressed: () => context.push('/order-details/${order.id}'),
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

  Widget _node(String title, String time, bool isDone, {bool isCurrent = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
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
            size: 12,
            color: isCurrent ? AppColors.textDark : Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: isDone || isCurrent ? AppColors.textDark : AppColors.textGrey)),
        Text(time, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textGrey)),
      ],
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(40, size.height - 35)
      ..cubicTo(size.width * 0.3, size.height * 0.8, size.width * 0.5, size.height * 0.2, size.width - 40, 35);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
