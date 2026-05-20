class Loai {
  static int _counter = 0;

  int stt;
  String ten;
  String icon;
  bool isIncome;

  /// Tạo mới (auto tăng stt)
  Loai({required this.ten, required this.icon, this.isIncome = false})
    : stt = ++_counter;

  /// Tạo từ JSON (Supabase)
  factory Loai.fromJson(Map<String, dynamic> json) {
    final category = Loai._internal(
      stt: json['stt'] as int,
      ten: json['ten'] as String,
      icon: json['icon'] as String,
      isIncome: json['is_income'] as bool? ?? false, // 👈 FIX
    );

    // tránh trùng stt
    if (category.stt > _counter) {
      _counter = category.stt;
    }

    return category;
  }

  /// Constructor nội bộ (không auto tăng)
  Loai._internal({
    required this.stt,
    required this.ten,
    required this.icon,
    required this.isIncome,
  });

  /// Convert sang JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      'stt': stt,
      'ten': ten,
      'icon': icon,
      'is_income': isIncome, // 👈 FIX
    };
  }

  /// Copy dữ liệu
  Loai copyWith({int? stt, String? ten, String? icon, bool? isIncome}) {
    return Loai._internal(
      stt: stt ?? this.stt,
      ten: ten ?? this.ten,
      icon: icon ?? this.icon,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  String toString() {
    return 'Category(stt: $stt, name: $ten, icon: $icon, isIncome: $isIncome)';
  }
}
