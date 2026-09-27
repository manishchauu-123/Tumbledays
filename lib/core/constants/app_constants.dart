/// Application wide constants for Tumbledays
class AppConstants {
  AppConstants._();

  static const String appName = 'Tumbledays';
  static const String appTagline = 'Doorstep Laundry & Dry-Cleaning';
  static const String supportPhone = '+91 80099 22000';
  static const String supportEmail = 'care@tumbledays.com';
  static const String companyAddress = 'Vibhuti Khand, Gomti Nagar, Lucknow - 226010';
  static const String defaultCity = 'Lucknow';

  // Delivery & Fees
  static const double freeDeliveryThreshold = 499.0;
  static const double standardDeliveryFee = 49.0;
  static const double expressDeliveryFee = 99.0;
  static const double gstRate = 0.18;

  // Pickup Slots
  static const List<Map<String, String>> pickupSlots = [
    {'time': '08:00 AM - 11:00 AM', 'label': 'Morning'},
    {'time': '12:00 PM - 03:00 PM', 'label': 'Afternoon'},
    {'time': '04:00 PM - 07:00 PM', 'label': 'Evening'},
    {'time': '07:00 PM - 10:00 PM', 'label': 'Night'},
  ];

  // Garment Categories
  static const List<String> garmentCategories = [
    'All',
    'Men',
    'Women',
    'Household',
    'Kids',
  ];
}
