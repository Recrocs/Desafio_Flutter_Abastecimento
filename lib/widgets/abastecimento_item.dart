import 'package:flutter/material.dart';

import '../models/abastecimento.dart';

class AbastecimentoItem extends StatelessWidget {
  final Abastecimento abastecimento;
  final double? consumo;
  final String dataFormatada;
  final String valorFormatado;
  final String numeroFormatado;
  final String quilometragemFormatada;
  final VoidCallback onDelete;

  const AbastecimentoItem({
    super.key,
    required this.abastecimento,
    required this.consumo,
    required this.dataFormatada,
    required this.valorFormatado,
    required this.numeroFormatado,
    required this.quilometragemFormatada,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF333333)
            : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? const Color(0xFF555555)
              : const Color(0xFFCCCCCC),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataFormatada,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${abastecimento.combustivel}\n'
                  '$numeroFormatado litros • $valorFormatado\n'
                  '$quilometragemFormatada km',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF666666),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF444444)
                  : const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              consumo == null
                  ? '—'
                  : '${consumo!.toStringAsFixed(2).replaceAll('.', ',')} km/L',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9534F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}