class Category {
  static int _counter = 0;

  int stt;
  String name;
  String icon;
  bool isIncome;

  /// Tạo mới (auto tăng stt)
  Category({required this.name, required this.icon, this.isIncome = false})
    : stt = ++_counter;

  /// Tạo từ JSON (Supabase)
  factory Category.fromJson(Map<String, dynamic> json) {
    final category = Category._internal(
      stt: json['stt'] as int,
      name: json['name'] as String,
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
  Category._internal({
    required this.stt,
    required this.name,
    required this.icon,
    required this.isIncome,
  });

  /// Convert sang JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      'stt': stt,
      'name': name,
      'icon': icon,
      'is_income': isIncome, // 👈 FIX
    };
  }

  /// Copy dữ liệu
  Category copyWith({int? stt, String? name, String? icon, bool? isIncome}) {
    return Category._internal(
      stt: stt ?? this.stt,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  String toString() {
    return 'Category(stt: $stt, name: $name, icon: $icon, isIncome: $isIncome)';
  }
}
