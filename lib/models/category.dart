class Category {
  static int _counter = 0;

  int stt;
  String name;
  String icon;

  /// Tạo mới (auto tăng stt)
  Category({required this.name, required this.icon}) : stt = ++_counter;

  /// Tạo từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    final category = Category(
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

    category.stt = json['stt'] as int;

    // cập nhật counter để không bị trùng
    if (category.stt > _counter) {
      _counter = category.stt;
    }

    return category;
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {'stt': stt, 'name': name, 'icon': icon};
  }

  /// Copy dữ liệu
  Category copyWith({int? stt, String? name, String? icon}) {
    final newCategory = Category(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );

    newCategory.stt = stt ?? this.stt;
    return newCategory;
  }

  @override
  String toString() {
    return 'Category(stt: $stt, name: $name, icon: $icon)';
  }
}

List<Category> categories = [
  Category(name: "Food", icon: "food"),
  Category(name: "Shopping", icon: "shopping"),
  Category(name: "Transport", icon: "transport"),
  Category(name: "Invest", icon: "invest"),
  Category(name: "Phone", icon: "phone"),
];
