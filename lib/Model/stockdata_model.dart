class StockData {
  final String name;
  final double buyPrice;
  final double sellPrice;
  final double rate;

  StockData({
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.rate,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      name: json['name'],
      buyPrice: json['buying'].toDouble(),
      sellPrice: json['selling'].toDouble(),
      rate: json['rate'].toDouble(),
    );
  }
}
