import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../state/app_state.dart';

class SupportSettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SupportSettingsScreen({super.key, this.onBack});

  @override
  State<SupportSettingsScreen> createState() => _SupportSettingsScreenState();
}

class _SupportSettingsScreenState extends State<SupportSettingsScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedCategory = 'General Inquiry';

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you! Your feedback has been sent to our Lucknow care team.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    _feedbackController.clear();
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Account?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.statusRed)),
        content: Text(
          'Are you sure you want to permanently delete your Tumbledays account? All your active bookings, wallet balance, and laundry passes will be terminated.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppState>().logout();
              context.go('/onboarding');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested.'), backgroundColor: AppColors.statusRed),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusRed, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'How does Tumbledays doorstep pickup work?',
        'a': 'Simply choose garments from the catalog, pick your date and convenient 3-hour slot. Our verified rider arrives at your doorstep with an eco-laundry bag to collect and tag your clothes.'
      },
      {
        'q': 'What is the standard turnaround time?',
        'a': 'Standard wash & fold is delivered within 24-48 hours. Dry cleaning takes 48-72 hours. You can also toggle 24-Hour Express processing at checkout for priority delivery.'
      },
      {
        'q': 'Are delicate garments washed separately?',
        'a': 'Yes! Each customer batch is washed independently. Delicates, silks and woolens are processed in German eco-solvent machines with hypoallergenic conditioners.'
      },
      {
        'q': 'What if a garment is misplaced or damaged?',
        'a': 'All garments are Barcode-tagged and inspected upon arrival at our Lucknow central processing unit. In the rare event of loss or damage, items are insured up to 10x wash charges.'
      },
    ];

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
        customTitle: Text(
          'WhatsApp Care & Help',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Contact Action Cards
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connecting to WhatsApp Customer Care...')),
                      );
                    },
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                          child: const Icon(Icons.chat, color: Color(0xFF2E7D32), size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('WhatsApp Us', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text('Instant Reply', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Helpline: ${AppConstants.supportPhone}')),
                      );
                    },
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
                          child: const Icon(Icons.phone_in_talk, color: AppColors.primaryGreen, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('Call Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text('9 AM - 9 PM', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text('Frequently Asked Questions', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
            const SizedBox(height: 12),

            // FAQs Accordion AppCard
            AppCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.cardBorder),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return ExpansionTile(
                    shape: const RoundedRectangleBorder(side: BorderSide.none),
                    title: Text(faq['q']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Text(faq['a']!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Send Feedback / Issue
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Send Us a Message', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    items: ['General Inquiry', 'Pickup Issue', 'Billing Query', 'Quality Feedback']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your question or concern in detail...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryCTAButton(
                    text: 'Submit Message',
                    showTrailingArrow: false,
                    onPressed: _submitFeedback,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Danger Zone (Account Deletion) with statusRed
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delete_forever, color: AppColors.statusRed, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Account Deletion', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.statusRed)),
                        const SizedBox(height: 2),
                        Text('Permanently purge customer data and laundry history', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showDeleteAccountDialog,
                    child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.statusRed, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
