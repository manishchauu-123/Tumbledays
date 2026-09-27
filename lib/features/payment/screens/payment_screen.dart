import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;

  void _handlePay(AppState state) {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        final order = state.placeOrder(paymentMethod: _selectedMethod);
        setState(() => _isProcessing = false);
        context.go('/order-success/${order.id}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final methods = [
      {
        'id': 'UPI',
        'title': 'UPI (Recommended)',
        'sub': 'Google Pay, PhonePe, Paytm, BHIM',
        'logos': 'GPay / PhonePe / Paytm',
      },
      {
        'id': 'Cards',
        'title': 'Debit / Credit Card',
        'sub': 'Visa, Mastercard, RuPay, Maestro',
        'logos': 'Visa / MC / RuPay',
      },
      {
        'id': 'Wallets',
        'title': 'Digital Wallets',
        'sub': 'Amazon Pay, Mobikwik, Airtel Money',
        'logos': 'Wallets',
      },
      {
        'id': 'Netbanking',
        'title': 'Net Banking',
        'sub': 'SBI, HDFC, ICICI, Axis & all major banks',
        'logos': 'Net Banking',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Payment',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary card with thumbnail + "Change"
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreenBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.dry_cleaning, color: AppColors.primaryGreen, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.cartCount} items booked',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                        ),
                        Text(
                          '${state.selectedDate} (${state.selectedSlot})',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Change',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bill Details card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bill Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      Text('₹${state.subtotal.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (state.discountAmount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGreen)),
                        Text('-₹${state.discountAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Doorstep Delivery', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      Text('FREE', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.cardBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      Text('₹${state.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // "Select Payment Method" radio list + "100% Secure" badge top-right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Payment Method',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 12, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        '100% Secure',
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: methods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final m = methods[index];
                final isSel = m['id'] == _selectedMethod;

                return AppCard(
                  onTap: () => setState(() => _selectedMethod = m['id']!),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSel ? AppColors.primaryGreen : AppColors.textGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['title']!,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark),
                            ),
                            Text(
                              m['sub']!,
                              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        m['logos']!,
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // "Green Choice" eco strip
            const InfoStripCard(
              icon: Icons.eco,
              title: 'Green Choice & Carbon Neutral Care',
              subtitle: 'We use non-toxic eco solvents and zero single-use plastic bags',
            ),

            const SizedBox(height: 24),

            // Yellow "Pay ₹X Now →"
            PrimaryCTAButton(
              text: 'Pay ₹${state.totalAmount.toStringAsFixed(0)} Now',
              isLoading: _isProcessing,
              onPressed: () => _handlePay(state),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
