import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  final Function(OrderModel)? onTrackOrder;
  final VoidCallback? onBack;

  const OrderHistoryScreen({
    super.key,
    this.onTrackOrder,
    this.onBack,
  });

  void _showInvoiceDialog(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TAX INVOICE', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textDark)),
                      Text('Tumbledays Laundry Services Pvt Ltd', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                      Text('Vibhuti Khand, Gomti Nagar, Lucknow - 226010', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.receipt, color: AppColors.primaryGreen, size: 24),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.cardBorder),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice No: INV-${order.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
                  Text('Date: ${order.pickupDate}', style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billed To:', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Abhinav Saxena (+91 94150 12345)', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textDark)),
                    Text(order.address, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textDark)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Items & Services:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
              const SizedBox(height: 6),
              Text(order.itemsSummary, style: GoogleFonts.poppins(fontSize: 12, height: 1.4, color: AppColors.textDark)),
              const Divider(height: 24, color: AppColors.cardBorder),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  Text('₹${order.subtotal.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pickup & Delivery', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  Text(order.deliveryFee == 0 ? 'FREE' : '₹${order.deliveryFee.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              if (order.discount > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Coupon Discount', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGreen)),
                    Text('-₹${order.discount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                  ],
                ),
              ],
              const Divider(height: 16, color: AppColors.cardBorder),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Paid', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                  Text('₹${order.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primaryGreen)),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryCTAButton(
                text: 'Download PDF Invoice',
                showTrailingArrow: false,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invoice downloaded to device!'), backgroundColor: AppColors.primaryGreen),
                  );
                },
              ),
            ],
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
          if (onBack != null) {
            onBack!();
          } else {
            context.go('/home');
          }
        },
        customTitle: Text(
          'My Laundry Orders',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: state.orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, size: 64, color: AppColors.textLight),
                    const SizedBox(height: 16),
                    Text('No orders yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    PrimaryCTAButton(
                      text: 'Book Your First Wash',
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                final isDelivered = order.status == OrderStatusEnum.delivered;

                return AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.id,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDelivered ? AppColors.lightGreenBg : AppColors.ctaYellow.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  order.status.displayName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isDelivered ? AppColors.primaryGreen : const Color(0xFFE65100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.itemsSummary,
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pickup: ${order.pickupDate} • ${order.paymentMethod}',
                        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                      ),
                      const Divider(height: 20, color: AppColors.cardBorder),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => _showInvoiceDialog(context, order),
                            icon: const Icon(Icons.receipt_outlined, size: 16, color: AppColors.primaryGreen),
                            label: Text('View Invoice', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w600, fontSize: 12)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              state.setActiveTrackingOrder(order);
                              if (onTrackOrder != null) {
                                onTrackOrder!(order);
                              } else {
                                context.push('/tracking/${order.id}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDelivered ? AppColors.lightGreenBg : AppColors.primaryGreen,
                              foregroundColor: isDelivered ? AppColors.primaryGreen : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              isDelivered ? 'View Details' : 'Track Order',
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
