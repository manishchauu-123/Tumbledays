import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class SchedulePickupScreen extends StatefulWidget {
  final VoidCallback? onProceedToAddress;
  final VoidCallback? onBack;

  const SchedulePickupScreen({
    super.key,
    this.onProceedToAddress,
    this.onBack,
  });

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  late String _selectedDate;
  late String _selectedSlot;
  late bool _isExpress;

  final List<String> _dates = [
    'Mon 14 Sep',
    'Tue 15 Sep',
    'Wed 16 Sep',
    'Thu 17 Sep',
    'Fri 18 Sep',
    'Sat 19 Sep',
  ];

  final List<Map<String, String>> _slots = [
    {'time': '10:00 AM - 12:00 PM', 'label': 'Morning'},
    {'time': '12:00 PM - 02:00 PM', 'label': 'Midday'},
    {'time': '02:00 PM - 04:00 PM', 'label': 'Afternoon'},
    {'time': '04:00 PM - 06:00 PM', 'label': 'Evening'},
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _selectedDate = _dates[0];
    _selectedSlot = _slots[0]['time']!;
    _isExpress = state.isExpress;
  }

  void _handleSaveAndProceed() {
    final state = context.read<AppState>();
    state.setPickupSchedule(
      date: _selectedDate,
      slot: _selectedSlot,
      isExpress: _isExpress,
    );
    if (widget.onProceedToAddress != null) {
      widget.onProceedToAddress!();
    } else {
      context.push('/address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Schedule Pickup',
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
            // Stepper (step 1 active)
            const BookingStepperWidget(currentStep: 0),

            const SizedBox(height: 16),

            // Info strip "We'll pick up your items from your location"
            const InfoStripCard(
              icon: Icons.location_on,
              title: "We'll pick up your items from your location",
              subtitle: 'Free doorstep collection anywhere across Lucknow',
            ),

            const SizedBox(height: 20),

            Text(
              'Select Pickup Date',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal scrollable date chips (Mon 14 Sep ... ) selected = green border
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final d = _dates[index];
                  final isSel = d == _selectedDate;

                  return InkWell(
                    onTap: () => setState(() => _selectedDate = d),
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.lightGreenBg : Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: isSel ? AppColors.primaryGreen : AppColors.cardBorder,
                          width: isSel ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          d,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppColors.primaryGreen : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Select Time Slot',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // 2x2 time-slot grid (10-12 Morning, 12-2 Midday, 2-4 Afternoon, 4-6 Evening) selected = yellow fill
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: _slots.length,
              itemBuilder: (context, index) {
                final slot = _slots[index];
                final isSel = slot['time'] == _selectedSlot;

                return InkWell(
                  onTap: () => setState(() => _selectedSlot = slot['time']!),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.ctaYellow : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSel ? AppColors.ctaYellow : AppColors.cardBorder,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slot['label']!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isSel ? AppColors.textDark : AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          slot['time']!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                            color: isSel ? AppColors.textDark : AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // "Express Service +₹99" checkbox row with lightning icon
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreenBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt, color: Color(0xFFE65100), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Express Service (+₹99)',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Guaranteed delivery within 24 hours',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: _isExpress,
                    activeColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) => setState(() => _isExpress = val ?? false),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Yellow "Continue →"
            PrimaryCTAButton(
              text: 'Continue',
              onPressed: _handleSaveAndProceed,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
