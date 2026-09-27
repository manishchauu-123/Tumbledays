import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onProceedToPayment;
  final VoidCallback? onBack;

  const CartScreen({
    super.key,
    this.onProceedToPayment,
    this.onBack,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  void _applyCoupon(AppState state) {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    final success = state.applyCoupon(code);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon or minimum order not met')),
      );
    } else {
      _couponController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon "$code" applied!'), backgroundColor: AppColors.primaryGreen),
      );
    }
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
          'Your Cart',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title "Your Cart" + "Review your items before booking", "Clear Cart" chip top-right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Cart',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
                    ),
                    Text(
                      'Review your items before booking',
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey),
                    ),
                  ],
                ),
                ActionChip(
                  label: Text('Clear Cart', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.statusRed)),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.cardBorder),
                  onPressed: () => state.clearCart(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Item rows = thumbnail, name, service sub-label, per-unit price, − qty + stepper, line total, delete icon
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.cartItems[index];

                return AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreenBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.garment.icon, color: AppColors.primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.garment.name,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark),
                            ),
                            Text(
                              '${state.selectedService.title} • ₹${item.garment.price.toStringAsFixed(0)}/${item.garment.unit}',
                              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      QuantitySelector(
                        quantity: item.quantity,
                        onIncrement: () => state.incrementItem(item.garment),
                        onDecrement: () => state.decrementItem(item.garment.id),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '₹${item.totalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusRed),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => state.decrementItem(item.garment.id),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // "Add More Items" green row
            InkWell(
              onTap: () => context.push('/catalog'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle, color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add More Items',
                      style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Yellow "Apply Coupon" card with code input + green Apply + "View All Offers"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ctaYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.ctaYellow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Apply Coupon',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                      ),
                      InkWell(
                        onTap: () => context.push('/offers'),
                        child: Text(
                          'View All Offers',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _couponController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: 'Enter Coupon Code',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _applyCoupon(state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                        child: Text('Apply', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ],
                  ),
                  if (state.appliedCoupon != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${state.appliedCoupon!.code} applied (-₹${state.discountAmount.toStringAsFixed(0)})',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bill Summary card (Items Total, Discount in green, Pickup & Delivery = FREE,
            // Total Amount highlighted with "You save ₹X")
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bill Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items Total', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
                      Text('₹${state.subtotal.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  if (state.discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                        Text('-₹${state.discountAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryGreen)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pickup & Delivery', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
                      Text('FREE', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.cardBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Amount', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                          if (state.discountAmount > 0)
                            Text(
                              'You save ₹${state.discountAmount.toStringAsFixed(0)} on this order',
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                            ),
                        ],
                      ),
                      Text(
                        '₹${state.totalAmount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Yellow "Proceed to Address →"
            PrimaryCTAButton(
              text: 'Proceed to Address',
              onPressed: () => context.push('/address-form'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
