import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  final bool darkMode;
  final Future<void> Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  void entrar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF222222)
          : const Color(0xFFEEEEEE),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            width: 350,
            padding: const EdgeInsets.all(35),

            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF333333)
                  : Colors.white,

              borderRadius: BorderRadius.circular(8),

              border: Border.all(
                color: isDark
                    ? const Color(0xFF555555)
                    : const Color(0xFFDDDDDD),
              ),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Text(
                  '⛽',
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Abastecimentos',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Controle seus abastecimentos',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFBBBBBB)
                        : const Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF555555)
                            : const Color(0xFFEEEEEE),
                      ),

                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF555555)
                            : const Color(0xFFEEEEEE),
                      ),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        'Tema escuro',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF222222),
                        ),
                      ),

                      Switch(
                        value: darkMode,

                        onChanged: (value) async {
                          await onThemeChanged(value);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      entrar(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white
                          : const Color(0xFF222222),

                      foregroundColor: isDark
                          ? Colors.black
                          : Colors.white,

                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5),
                      ),
                    ),

                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}