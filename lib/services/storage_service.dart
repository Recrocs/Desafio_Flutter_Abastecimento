import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/abastecimento.dart';

class StorageService {
  static const String abastecimentosKey =
      'abastecimentos';

  static const String temaKey =
      'tema';

  static Future<List<Abastecimento>>
      carregarAbastecimentos() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final dados =
        prefs.getString(
      abastecimentosKey,
    );

    if (dados == null) {
      return [];
    }

    final lista =
        jsonDecode(dados) as List;

    return lista
        .map(
          (item) =>
              Abastecimento.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .toList();
  }

  static Future<void>
      salvarAbastecimentos(
    List<Abastecimento>
        abastecimentos,
  ) async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final dados = jsonEncode(
      abastecimentos
          .map(
            (item) => item.toJson(),
          )
          .toList(),
    );

    await prefs.setString(
      abastecimentosKey,
      dados,
    );
  }

  static Future<bool>
      carregarTema() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
          temaKey,
        ) ==
        'dark';
  }

  static Future<void> salvarTema(
    bool dark,
  ) async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      temaKey,
      dark ? 'dark' : 'light',
    );
  }
}