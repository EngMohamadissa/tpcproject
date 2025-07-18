class MonthlyProfitModel {
  final String month;
  final double totalProfit;

  MonthlyProfitModel({
    required this.month,
    required this.totalProfit,
  });

  factory MonthlyProfitModel.fromJson(Map<String, dynamic> json) {
    return MonthlyProfitModel(
      month: json['month'] as String,
      totalProfit: (json['total_profit'] as num).toDouble(),
    );
  }
}
