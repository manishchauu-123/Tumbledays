import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  late ServiceItem _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<AppState>().selectedService;
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
          'Select Service',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Service',
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 2),
            Text(
              'Choose what you need cleaned',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 20),

            // 2x3 card grid, each card = pastel circle icon, name, 2-line description;
            // selected card shows green check badge top-right
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final s = state.services[index];
                final isSel = s.id == _selected.id;

                return InkWell(
                  onTap: () {
                    setState(() => _selected = s);
                    state.selectService(s);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.lightGreenBg : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSel ? AppColors.primaryGreen : AppColors.cardBorder,
                        width: isSel ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        if (isSel)
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightGreenBg,
                                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                              ),
                              child: Icon(s.icon, color: AppColors.primaryGreen, size: 22),
                            ),
                            const Spacer(),
                            Text(
                              s.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, height: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.startingPrice,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Feature row at bottom
            const FeatureRowWidget(),

            const SizedBox(height: 24),

            // Yellow "Schedule Pickup →" button
            PrimaryCTAButton(
              text: 'Schedule Pickup',
              onPressed: () {
                state.selectService(_selected);
                context.push('/catalog/${_selected.id}');
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
