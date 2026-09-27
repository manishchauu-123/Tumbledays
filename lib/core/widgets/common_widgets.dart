import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// 1. Tumbledays Logo
class TumbledaysLogo extends StatelessWidget {
  final double size;
  final bool isWhite;

  const TumbledaysLogo({
    super.key,
    this.size = 20,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Transform.rotate(
              angle: -0.3,
              child: Icon(
                Icons.eco,
                size: size * 1.15,
                color: isWhite ? Colors.white70 : AppColors.accentGreen,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Transform.rotate(
                angle: 0.4,
                child: Icon(
                  Icons.eco,
                  size: size * 0.85,
                  color: isWhite ? Colors.white : AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tumble',
                style: GoogleFonts.poppins(
                  fontSize: size,
                  fontWeight: FontWeight.w800,
                  color: isWhite ? Colors.white : AppColors.primaryGreen,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'days',
                style: GoogleFonts.poppins(
                  fontSize: size,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ctaYellow,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 2. AppHeader: back arrow (left), centered logo, right phone + bell with red dot badge
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;
  final VoidCallback? onCall;
  final VoidCallback? onNotification;
  final Widget? customTitle;

  const AppHeader({
    super.key,
    this.showBack = true,
    this.onBack,
    this.onMenu,
    this.onCall,
    this.onNotification,
    this.customTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: customTitle ?? const TumbledaysLogo(size: 20),
      leading: onMenu != null
          ? IconButton(
              icon: const Icon(Icons.menu, size: 24, color: AppColors.textDark),
              onPressed: onMenu,
            )
          : showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                )
              : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.phone_outlined, size: 22, color: AppColors.textDark),
          tooltip: 'Call Support',
          onPressed: onCall ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Helpline: ${AppConstants.supportPhone}')),
                );
              },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 22, color: AppColors.textDark),
              tooltip: 'Notifications',
              onPressed: onNotification ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No new notifications')),
                    );
                  },
            ),
            Positioned(
              top: 13,
              right: 13,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.statusRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

/// 3. PrimaryButton: pill-shaped, height 54, yellow #FFC107 with dark text and trailing arrow
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showTrailingArrow;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.showTrailingArrow = true,
    this.height = AppTheme.buttonHeight,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.ctaYellow,
          foregroundColor: textColor ?? AppColors.textDark,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppTheme.pillRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textDark),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppTheme.buttonLabel.copyWith(
                      color: textColor ?? AppColors.textDark,
                    ),
                  ),
                  if (showTrailingArrow) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20, color: textColor ?? AppColors.textDark),
                  ],
                ],
              ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef PrimaryCTAButton = PrimaryButton;
typedef AppButton = PrimaryButton;

/// 4. SecondaryButton: white bg + primaryGreen border + green label
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.height = AppTheme.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTheme.pillRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTheme.buttonLabel.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef SecondaryCTAButton = SecondaryButton;

/// 5. SectionTitle: reusable header with optional trailing action
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTheme.subtitle),
                ],
              ],
            ),
          ),
          if (actionText != null && onActionTap != null)
            InkWell(
              onTap: onActionTap,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14, color: AppColors.primaryGreen),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 6. InfoStrip: lightGreenBg card, leaf/calendar icon left, bold line + grey sub-line
class InfoStrip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const InfoStrip({
    super.key,
    this.icon = Icons.eco,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.cardRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightGreenBg,
          borderRadius: AppTheme.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef InfoStripCard = InfoStrip;

/// 7. FeatureRow: 4 circular light-green icon tiles
class FeatureRow extends StatelessWidget {
  const FeatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.local_shipping_outlined, 'title': 'Free Pickup\n& Delivery'},
      {'icon': Icons.verified_user_outlined, 'title': 'Trusted\nCare'},
      {'icon': Icons.eco_outlined, 'title': 'Eco-Friendly\nCleaning'},
      {'icon': Icons.thumb_up_alt_outlined, 'title': 'Satisfaction\nGuaranteed'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((f) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.lightGreenBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Icon(
                  f['icon'] as IconData,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                f['title'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Backward compatibility alias
typedef FeatureRowWidget = FeatureRow;

/// 8. BookingStepper: 3 numbered circles connected by a line
class BookingStepper extends StatelessWidget {
  final int currentStep; // 0: Select Date & Time, 1: Address Details, 2: Confirm

  const BookingStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Select Date & Time',
      'Address Details',
      'Confirm',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepBefore = index ~/ 2;
            final isCompleted = stepBefore < currentStep;
            return Expanded(
              child: Container(
                height: 2.5,
                color: isCompleted ? AppColors.primaryGreen : AppColors.cardBorder,
              ),
            );
          }

          final stepIdx = index ~/ 2;
          final isCompleted = stepIdx < currentStep;
          final isActive = stepIdx == currentStep;

          Color circleColor;
          Color textColor;

          if (isCompleted || isActive) {
            circleColor = AppColors.primaryGreen;
            textColor = Colors.white;
          } else {
            circleColor = AppColors.disabledGrey;
            textColor = AppColors.textGrey;
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: AppColors.ctaYellow, width: 2)
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${stepIdx + 1}',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIdx],
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primaryGreen : AppColors.textGrey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Backward compatibility alias
typedef BookingStepperWidget = BookingStepper;

/// 9. OrderStatusStepper: 5-node horizontal stepper for order status
class OrderStatusStepper extends StatelessWidget {
  final int currentStep; // 0 to 4

  const OrderStatusStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final nodes = [
      {'title': 'Placed', 'time': '09:00 AM'},
      {'title': 'Picked', 'time': '11:15 AM'},
      {'title': 'Wash', 'time': '02:30 PM'},
      {'title': 'Out', 'time': '05:00 PM'},
      {'title': 'Delivered', 'time': 'Pending'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(nodes.length, (index) {
        final isDone = index <= currentStep;
        final isCurrent = index == currentStep;

        return Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.ctaYellow
                    : isDone
                        ? AppColors.primaryGreen
                        : AppColors.disabledGrey,
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: AppColors.textDark, width: 2) : null,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.circle,
                size: 13,
                color: isCurrent ? AppColors.textDark : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nodes[index]['title']!,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                color: isDone ? AppColors.textDark : AppColors.textGrey,
              ),
            ),
            Text(
              nodes[index]['time']!,
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textGrey),
            ),
          ],
        );
      }),
    );
  }
}

/// 10. AddressCard: reusable card showing address details with radio selector and actions
class AddressCard extends StatelessWidget {
  final String tag;
  final String flat;
  final String street;
  final String city;
  final String pincode;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.tag,
    required this.flat,
    required this.street,
    required this.city,
    required this.pincode,
    required this.isSelected,
    this.isDefault = false,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppColors.primaryGreen : AppColors.textGrey,
                size: 22,
              ),
              const SizedBox(width: 12),
              Icon(
                tag == 'Home'
                    ? Icons.home_outlined
                    : tag == 'Office'
                        ? Icons.business_outlined
                        : Icons.location_on_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                tag,
                style: AppTheme.cardTitle,
              ),
              if (isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryGreen),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onDelete != null) ...[
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textGrey),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flat, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
                Text('$street, $city - $pincode', style: AppTheme.cardBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 11. ItemTile: cart and catalog item row with stepper and pricing
class ItemTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String subLabel;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onDelete;

  const ItemTile({
    super.key,
    required this.icon,
    required this.name,
    required this.subLabel,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Icon(icon, color: AppColors.primaryGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark),
                ),
                Text(
                  subLabel,
                  style: AppTheme.cardBody,
                ),
              ],
            ),
          ),
          QuantitySelector(
            quantity: quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
          const SizedBox(width: 10),
          Text(
            '₹${(price * quantity).toStringAsFixed(0)}',
            style: AppTheme.priceStyle.copyWith(fontSize: 14),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusRed),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}

/// 12. BillSummaryCard: standardized bill breakdown
class BillSummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double expressFee;
  final double grandTotal;

  const BillSummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    this.expressFee = 0,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bill Summary', style: AppTheme.cardTitle.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          _row('Items Total', '₹${subtotal.toStringAsFixed(0)}'),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _row('Discount', '-₹${discount.toStringAsFixed(0)}', isGreen: true),
          ],
          const SizedBox(height: 8),
          _row('Doorstep Pickup & Delivery', deliveryFee == 0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(0)}', isGreen: deliveryFee == 0),
          if (expressFee > 0) ...[
            const SizedBox(height: 8),
            _row('Express Processing', '₹${expressFee.toStringAsFixed(0)}'),
          ],
          const Divider(height: 20, color: AppColors.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount', style: AppTheme.cardTitle),
                  if (discount > 0)
                    Text(
                      'You save ₹${discount.toStringAsFixed(0)} on this order',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                    ),
                ],
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(0)}',
                style: AppTheme.priceStyle.copyWith(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.cardBody),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isGreen ? FontWeight.w700 : FontWeight.w600,
            color: isGreen ? AppColors.primaryGreen : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

/// 13. OfferTile: coupon offer card with copy and apply action
class OfferTile extends StatelessWidget {
  final String code;
  final String title;
  final String condition;
  final String badge;
  final bool isApplied;
  final bool isYellow;
  final IconData icon;
  final VoidCallback onApply;

  const OfferTile({
    super.key,
    required this.code,
    required this.title,
    required this.condition,
    required this.badge,
    required this.isApplied,
    this.isYellow = false,
    this.icon = Icons.local_offer,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: isYellow ? AppColors.ctaYellowLight : AppColors.lightGreenBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: isYellow ? AppColors.ctaYellow.withOpacity(0.5) : AppColors.cardBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(icon, color: AppColors.primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            condition,
            style: AppTheme.cardBody.copyWith(fontSize: 11),
          ),
          const Divider(height: 16, color: AppColors.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Code $code copied!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: Row(
                    children: [
                      Text(
                        code,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.copy, size: 14, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 0,
                ),
                child: Text(
                  isApplied ? 'Applied' : 'Apply',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 14. HeroBannerStack: decorative leaf/wave background in hero sections using CustomPaint
class HeroBannerStack extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HeroBannerStack({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.heroShadow,
      ),
      child: ClipRRect(
        borderRadius: AppTheme.cardRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _LeafWavePainter(),
              ),
            ),
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeafWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    // Organic leaf wave 1
    final path1 = Path()
      ..moveTo(size.width * 0.6, 0)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width, size.height * 0.15)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path1, paint);

    // Organic leaf wave 2
    final path2 = Path()
      ..moveTo(size.width * 0.4, size.height)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.6, size.width, size.height * 0.85)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, paint);

    // Leaf motif outline
    final leafPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size.width * 0.88, size.height * 0.45), 45, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 15. Standard Card: radius 16, white, 1px border #E6EFE8, soft shadow (blur 12, y+4, black 6%)
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.cardPadding),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.whiteCard,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppTheme.cardRadius,
        child: cardContent,
      );
    }
    return cardContent;
  }
}

/// 16. QuantitySelector: pill counter
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return InkWell(
        onTap: onIncrement,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                'ADD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

/// 17. ScriptTaglineBadge
class ScriptTaglineBadge extends StatelessWidget {
  const ScriptTaglineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Clean / Fresh / Confident',
          style: GoogleFonts.caveat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          width: 90,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.ctaYellow,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
