class Abastecimento {
  final String data;
  final String combustivel;
  final double litros;
  final double valor;
  final double quilometragem;

  Abastecimento({
    required this.data,
    required this.combustivel,
    required this.litros,
    required this.valor,
    required this.quilometragem,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'combustivel': combustivel,
      'litros': litros,
      'valor': valor,
      'quilometragem': quilometragem,
    };
  }

  factory Abastecimento.fromJson(
      Map<String, dynamic> json) {
    return Abastecimento(
      data: json['data'],
      combustivel: json['combustivel'],
      litros:
          (json['litros'] as num).toDouble(),
      valor:
          (json['valor'] as num).toDouble(),
      quilometragem:
          (json['quilometragem'] as num)
              .toDouble(),
    );
  }
}