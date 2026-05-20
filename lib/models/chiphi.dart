import 'loai.dart';

class ChiPhi {
  int? id;
  String ten;
  double gia;
  Loai? loai;
  DateTime ngay;
  String? ghiChu;

  ChiPhi({
    this.id,
    required this.ten,
    required this.gia,
    this.loai,
    DateTime? ngay,
    this.ghiChu,
  }) : ngay = ngay ?? DateTime.now();

  /// FROM JSON
  factory ChiPhi.fromJson(Map<String, dynamic> json) {
    return ChiPhi(
      id: json['id'],
      ten: json['ten'] as String,
      gia: (json['gia'] as num).toDouble(),
      loai: json['loai'] != null ? Loai.fromJson(json['loai']) : null,
      ngay: DateTime.parse(json['ngay']),
      ghiChu: json['ghiChu'],
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'gia': gia,
      'loai_stt': loai?.stt,
      'ngay': ngay.toIso8601String(),
      'ghiChu': ghiChu,
    };
  }

  /// COPY WITH
  ChiPhi copyWith({
    int? id,
    String? ten,
    double? gia,
    Loai? loai,
    DateTime? ngay,
    String? ghiChu,
  }) {
    return ChiPhi(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      gia: gia ?? this.gia,
      loai: loai ?? this.loai,
      ngay: ngay ?? this.ngay,
      ghiChu: ghiChu ?? this.ghiChu,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $ten, amount: $gia)';
  }
}
