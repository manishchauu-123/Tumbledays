import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class ServiceCatalogScreen extends StatefulWidget {
  final String? serviceId;
  final VoidCallback? onProceedToSchedule;
  final VoidCallback? onBack;

  const ServiceCatalogScreen({
    super.key,
    this.serviceId,
    this.onProceedToSchedule,
    this.onBack,
  });

  @override
  State<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends State<ServiceCatalogScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Men', 'Women', 'Household', 'Kids'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.serviceId != null) {
        context.read<AppState>().selectServiceById(widget.serviceId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final currentService = state.selectedService;
    final allGarments = state.getGarmentsForCurrentService();

    final filteredGarments = _selectedCategory == 'All'
        ? allGarments
        : allGarments.where((g) => g.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            context.pop();
          }
        },
        customTitle: Column(
          children: [
            Text(
              currentService.title,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            Text(
              '${currentService.turnaround} Turnaround',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category Selector Chips: pill, selected = primaryGreen fill + white text
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: Colors.white,
                  labelStyle: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                );
              },
            ),
          ),

          // Garment List
          Expanded(
            child: filteredGarments.isEmpty
                ? Center(
                    child: Text('No garments in this category', style: GoogleFonts.poppins(color: AppColors.textGrey)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: filteredGarments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final garment = filteredGarments[index];
                      final qty = state.getQuantity(garment.id);

                      return AppCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.lightGreenBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(garment.icon, color: AppColors.primaryGreen, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    garment.name,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textDark),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${garment.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                      Text(
                                        ' / ${garment.unit}',
                                        style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            QuantitySelector(
                              quantity: qty,
                              onIncrement: () => state.incrementItem(garment),
                              onDecrement: () => state.decrementItem(garment.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: state.cartCount > 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.cartCount} items in bag',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                      ),
                      Text(
                        '₹${state.subtotal.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.onProceedToSchedule != null) {
                        widget.onProceedToSchedule!();
                      } else {
                        context.push('/schedule');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaYellow,
                      foregroundColor: AppColors.textDark,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Choose Pickup Slot', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
