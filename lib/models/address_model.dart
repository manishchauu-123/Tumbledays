class AddressModel {
  final String id;
  final String tag; // Home, Office, Other
  final String flat;
  final String street;
  final String landmark;
  final String city;
  final String pincode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.tag,
    required this.flat,
    required this.street,
    required this.landmark,
    this.city = 'Lucknow',
    required this.pincode,
    this.isDefault = false,
  });

  String get fullAddress => '$flat, $street, $landmark, $city - $pincode';

  AddressModel copyWith({
    String? id,
    String? tag,
    String? flat,
    String? street,
    String? landmark,
    String? city,
    String? pincode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      flat: flat ?? this.flat,
      street: street ?? this.street,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
