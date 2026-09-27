import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  int _selectedRating = 5;
  String _feedbackType = 'General Inquiry';
  final _feedbackController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does doorstep pickup work?',
      'a': 'Simply choose garments from the catalog, pick your date and 2-hour slot. Our verified rider arrives at your doorstep with an eco-laundry bag.'
    },
    {
      'q': 'What is the standard turnaround time?',
      'a': 'Standard wash & fold is delivered within 24-48 hours. Dry cleaning takes 48-72 hours. You can also toggle 24-Hour Express processing.'
    },
    {
      'q': 'What if an item is misplaced or stained?',
      'a': 'All garments are tagged and inspected upon arrival at our Lucknow central processing unit. Items are insured up to 10x wash charges.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Contact Us',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4 tile grid: Call Us (+91 ... , 8 AM – 8 PM), WhatsApp, Email Us, Our Office
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _contactTile(Icons.phone_in_talk, 'Call Us', AppConstants.supportPhone, '8 AM – 8 PM', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialing +91 80099 22000...')),
                  );
                }),
                _contactTile(Icons.chat, 'WhatsApp', 'Instant Chat', 'Active Now', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening WhatsApp care...')),
                  );
                }),
                _contactTile(Icons.mail_outline, 'Email Us', AppConstants.supportEmail, '24h Response', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email app...')),
                  );
                }),
                _contactTile(Icons.business_outlined, 'Our Office', 'Gomti Nagar', 'Lucknow - 226010', () {}),
              ],
            ),

            const SizedBox(height: 16),

            // Green "Need Immediate Help?" strip with "Live Chat" button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent, color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Need Immediate Help?', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('Chat with our Lucknow support team', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Starting live chat session...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaYellow,
                      foregroundColor: AppColors.textDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Text('Live Chat', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // "Share Your Feedback" card with 5-star rating, Feedback Type dropdown,
            // 500-char message box, green "Submit Feedback"
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Share Your Feedback', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                  const SizedBox(height: 10),

                  // 5-Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return IconButton(
                        icon: Icon(
                          star <= _selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => _selectedRating = star),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),

                  // Feedback Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _feedbackType,
                    decoration: InputDecoration(
                      labelText: 'Feedback Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['General Inquiry', 'Pickup Issue', 'Wash Quality', 'App Feedback']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.poppins(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _feedbackType = val);
                    },
                  ),

                  const SizedBox(height: 12),

                  // 500-char Message Box
                  TextField(
                    controller: _feedbackController,
                    maxLength: 500,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts or describe your concern...',
                      hintStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Green "Submit Feedback"
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_feedbackController.text.trim().isEmpty) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you! Your feedback has been submitted.'), backgroundColor: AppColors.primaryGreen),
                        );
                        _feedbackController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Submit Feedback', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FAQ accordion list with "View All"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Frequently Asked Questions', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                Text('View All', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primaryGreen)),
              ],
            ),
            const SizedBox(height: 10),

            AppCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _faqs.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.cardBorder),
                itemBuilder: (context, index) {
                  final f = _faqs[index];
                  return ExpansionTile(
                    title: Text(f['q']!, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(f['a']!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey, height: 1.35)),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Green closing strip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  'Lucknow Hub: Vibhuti Khand, Gomti Nagar • 8 AM to 8 PM Everyday',
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String val, String sub, VoidCallback onTap) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
          Text(val, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen), maxLines: 1),
          Text(sub, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
