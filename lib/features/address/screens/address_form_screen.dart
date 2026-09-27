import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _nameCtrl = TextEditingController(text: 'Abhinav Saxena');
  final _phoneCtrl = TextEditingController(text: '9415012345');
  final _emailCtrl = TextEditingController(text: 'abhinav@tumbledays.com');
  final _houseCtrl = TextEditingController(text: 'Flat 402');
  final _aptCtrl = TextEditingController(text: 'Shalimar Heights');
  final _areaCtrl = TextEditingController(text: 'Vibhuti Khand');
  final _cityCtrl = TextEditingController(text: 'Lucknow');
  final _pincodeCtrl = TextEditingController(text: '226010');
  final _instructionsCtrl = TextEditingController(text: 'Please call before arriving, gate code #402');

  void _handleSave() {
    if (_houseCtrl.text.isEmpty || _areaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required address fields')),
      );
      return;
    }

    final newAddr = AddressModel(
      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
      tag: 'Custom',
      flat: '${_houseCtrl.text}, ${_aptCtrl.text}',
      street: _areaCtrl.text,
      landmark: '',
      city: _cityCtrl.text,
      pincode: _pincodeCtrl.text,
    );

    context.read<AppState>().addAddress(newAddr);
    context.push('/select-address');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintTint,
      appBar: AppHeader(
        showBack: true,
        onBack: () => context.pop(),
        customTitle: Text(
          'Pickup Address',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper (step 2 active)
            const BookingStepperWidget(currentStep: 1),

            const SizedBox(height: 16),

            // Green info strip
            const InfoStripCard(
              icon: Icons.shield_outlined,
              title: 'Verified & Safe Pickup Partners',
              subtitle: 'Our riders carry official ID cards and hygienic sanitization bags',
            ),

            const SizedBox(height: 20),

            // Icon-prefixed fields: Full Name, Mobile Number, Email (Optional),
            // House/Flat No., Apartment/Society, Area/Locality, then City + Pincode side by side
            _iconField(Icons.person_outline, 'Full Name', _nameCtrl),
            const SizedBox(height: 12),
            _iconField(Icons.phone_outlined, 'Mobile Number', _phoneCtrl, keyboard: TextInputType.phone),
            const SizedBox(height: 12),
            _iconField(Icons.mail_outline, 'Email Address (Optional)', _emailCtrl, keyboard: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _iconField(Icons.home_outlined, 'House / Flat No.', _houseCtrl),
            const SizedBox(height: 12),
            _iconField(Icons.apartment_outlined, 'Apartment / Society', _aptCtrl),
            const SizedBox(height: 12),
            _iconField(Icons.location_city_outlined, 'Area / Locality', _areaCtrl),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _iconField(Icons.map_outlined, 'City', _cityCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _iconField(Icons.pin_drop_outlined, 'Pincode', _pincodeCtrl, keyboard: TextInputType.number)),
              ],
            ),

            const SizedBox(height: 16),

            // Multiline "Delivery Instructions (Optional)" on lightGreenBg
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Instructions (Optional)',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _instructionsCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'e.g. Ring bell, leave at reception or security desk...',
                      hintStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Yellow "Continue →"
            PrimaryCTAButton(
              text: 'Continue',
              onPressed: _handleSave,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _iconField(IconData icon, String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey),
          prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
