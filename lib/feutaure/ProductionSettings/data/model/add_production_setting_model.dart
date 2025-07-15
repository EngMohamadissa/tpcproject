class ProductionSettings {
  final double totalProduction;
  final String type; // 'estimated' or 'real'
  final double profitRatio;
  final int month;
  final int year;
  final String? notes;

  ProductionSettings({
    required this.totalProduction,
    required this.type,
    required this.profitRatio,
    required this.month,
    required this.year,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'total_production': totalProduction,
        'type': type,
        'profit_ratio': profitRatio,
        'month': month,
        'year': year,
        'notes': notes,
      };

  factory ProductionSettings.fromJson(Map<String, dynamic> json) {
    return ProductionSettings(
      totalProduction: double.parse(json['total_production'].toString()),
      type: json['type'],
      profitRatio: double.parse(json['profit_ratio'].toString()),
      month: json['month'],
      year: json['year'],
      notes: json['notes'],
    );
  }
}
