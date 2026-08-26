import 'package:flutter/material.dart';

import '../models/abastecimento.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Abastecimento> lista = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados =
        await StorageService.carregarAbastecimentos();

    setState(() {
      lista = dados;
    });
  }

  Future<void> cadastrar() async {
    final resultado =
        await showDialog<Abastecimento>(
      context: context,
      builder: (context) {
        return const CadastroDialog();
      },
    );

    if (resultado == null) {
      return;
    }

    setState(() {
      lista.add(resultado);
    });

    await StorageService.salvarAbastecimentos(lista);
  }

  Future<void> excluir(int indice) async {
    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir abastecimento',
          ),

          content: const Text(
            'Deseja realmente excluir este abastecimento?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      lista.removeAt(indice);
    });

    await StorageService.salvarAbastecimentos(lista);
  }

  double precoMedio() {
    if (lista.isEmpty) {
      return 0;
    }

    double litros = 0;
    double valor = 0;

    for (final item in lista) {
      litros += item.litros;
      valor += item.valor;
    }

    if (litros <= 0) {
      return 0;
    }

    return valor / litros;
  }

  double? consumo(int indice) {
    if (indice == 0) {
      return null;
    }

    final atual = lista[indice];
    final anterior = lista[indice - 1];

    final distancia =
        atual.quilometragem -
        anterior.quilometragem;

    if (distancia <= 0 ||
        atual.litros <= 0) {
      return null;
    }

    return distancia / atual.litros;
  }

  double? consumoMedio() {
    if (lista.length < 2) {
      return null;
    }

    double total = 0;
    int quantidade = 0;

    for (int i = 1; i < lista.length; i++) {
      final valor = consumo(i);

      if (valor != null) {
        total += valor;
        quantidade++;
      }
    }

    if (quantidade == 0) {
      return null;
    }

    return total / quantidade;
  }

  String numero(double valor) {
    return valor
        .toStringAsFixed(2)
        .replaceAll('.', ',');
  }

  String dinheiro(double valor) {
    return 'R\$ ${numero(valor)}';
  }

  String data(String valor) {
    final partes = valor.split('-');

    if (partes.length != 3) {
      return valor;
    }

    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final mediaPreco = precoMedio();
    final mediaConsumo = consumoMedio();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF222222)
          : const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF111111)
            : const Color(0xFF4A4A4A),

        foregroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              'Abastecimentos',
              style: TextStyle(
                fontSize: 22,
              ),
            ),

            Text(
              'Histórico do veículo',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: cadastrar,

        backgroundColor: isDark
            ? Colors.white
            : const Color(0xFF222222),

        foregroundColor: isDark
            ? Colors.black
            : Colors.white,

        child: const Icon(
          Icons.add,
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 900,
          ),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(20),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_gas_station,
                                size: 30,
                              ),

                              const SizedBox(
                                width: 15,
                              ),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    'Preço médio',
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    lista.isEmpty
                                        ? 'R\$ 0,00/L'
                                        : '${dinheiro(mediaPreco)}/L',

                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(20),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.speed,
                                size: 30,
                              ),

                              const SizedBox(
                                width: 15,
                              ),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    'Consumo médio',
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    mediaConsumo == null
                                        ? '— km/L'
                                        : '${numero(mediaConsumo)} km/L',

                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Histórico',
                              style:
                                  TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Text(
                              lista.length == 1
                                  ? '1 registro'
                                  : '${lista.length} registros',
                            ),

                            const Spacer(),

                            IconButton(
                              onPressed:
                                  cadastrar,

                              icon: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        if (lista.isEmpty)
                          Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 50,
                            ),

                            child: Column(
                              children: [
                                const Text(
                                  '⛽',
                                  style:
                                      TextStyle(
                                    fontSize: 45,
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                const Text(
                                  'Nenhum abastecimento',
                                  style:
                                      TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  'Clique no botão + para cadastrar\n'
                                  'seu primeiro abastecimento.',
                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children:
                                List.generate(
                              lista.length,
                              (indice) {
                                final item =
                                    lista[indice];

                                final consumoAtual =
                                    consumo(indice);

                                return Card(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .all(15),

                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,

                                            children: [
                                              Text(
                                                data(
                                                    item.data),
                                                style:
                                                    const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 5,
                                              ),

                                              Text(
                                                '${item.combustivel}\n'
                                                '${numero(item.litros)} litros • '
                                                '${dinheiro(item.valor)}\n'
                                                '${numero(item.quilometragem)} km',
                                                style:
                                                    const TextStyle(
                                                  height:
                                                      1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if (consumoAtual !=
                                            null)
                                          Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal:
                                                  12,
                                              vertical:
                                                  8,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              color: isDark
                                                  ? const Color(
                                                      0xFF444444)
                                                  : const Color(
                                                      0xFFDDDDDD),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                4,
                                              ),
                                            ),

                                            child:
                                                Text(
                                              '${numero(consumoAtual)} km/L',
                                            ),
                                          )
                                        else
                                          const Text(
                                            '—',
                                          ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        IconButton(
                                          onPressed:
                                              () => excluir(
                                                  indice),

                                          icon:
                                              const Icon(
                                            Icons.delete,
                                            color:
                                                Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
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

class CadastroDialog
    extends StatefulWidget {
  const CadastroDialog({
    super.key,
  });

  @override
  State<CadastroDialog> createState() =>
      _CadastroDialogState();
}

class _CadastroDialogState
    extends State<CadastroDialog> {
  final formKey =
      GlobalKey<FormState>();

  final litrosController =
      TextEditingController();

  final valorController =
      TextEditingController();

  final quilometragemController =
      TextEditingController();

  String combustivel = '';

  DateTime dataSelecionada =
      DateTime.now();

  final combustiveis = [
    'Gasolina',
    'Gasolina Aditivada',
    'Etanol',
    'Diesel',
    'Diesel S10',
    'GNV',
  ];

  @override
  void dispose() {
    litrosController.dispose();
    valorController.dispose();
    quilometragemController.dispose();

    super.dispose();
  }

  Future<void> selecionarData() async {
    final resultado =
        await showDatePicker(
      context: context,

      initialDate: dataSelecionada,

      firstDate:
          DateTime(2000),

      lastDate:
          DateTime(2100),
    );

    if (resultado != null) {
      setState(() {
        dataSelecionada =
            resultado;
      });
    }
  }

  void salvar() {
    if (!formKey.currentState!
        .validate()) {
      return;
    }

    if (combustivel.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione o combustível.',
          ),
        ),
      );

      return;
    }

    final data =
        '${dataSelecionada.year.toString().padLeft(4, '0')}-'
        '${dataSelecionada.month.toString().padLeft(2, '0')}-'
        '${dataSelecionada.day.toString().padLeft(2, '0')}';

    final abastecimento =
        Abastecimento(
      data: data,

      combustivel:
          combustivel,

      litros:
          double.parse(
        litrosController.text
            .replaceAll(',', '.'),
      ),

      valor:
          double.parse(
        valorController.text
            .replaceAll(',', '.'),
      ),

      quilometragem:
          double.parse(
        quilometragemController.text
            .replaceAll(',', '.'),
      ),
    );

    Navigator.pop(
      context,
      abastecimento,
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Novo abastecimento',
      ),

      content: SizedBox(
        width: 450,

        child: Form(
          key: formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                TextFormField(
                  readOnly: true,

                  onTap:
                      selecionarData,

                  decoration:
                      InputDecoration(
                    labelText: 'Data',

                    border:
                        const OutlineInputBorder(),

                    suffixIcon:
                        const Icon(
                      Icons.calendar_today,
                    ),

                    hintText:
                        '${dataSelecionada.day.toString().padLeft(2, '0')}/'
                        '${dataSelecionada.month.toString().padLeft(2, '0')}/'
                        '${dataSelecionada.year}',
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                DropdownButtonFormField<
                    String>(
                  value:
                      combustivel.isEmpty
                          ? null
                          : combustivel,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Combustível',

                    border:
                        OutlineInputBorder(),
                  ),

                  hint: const Text(
                    'Selecione',
                  ),

                  items:
                      combustiveis.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item,
                        child:
                            Text(item),
                      );
                    },
                  ).toList(),

                  onChanged:
                      (value) {
                    setState(() {
                      combustivel =
                          value ?? '';
                    });
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          campo(
                        litrosController,
                        'Litros',
                        '35.5',
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                          campo(
                        valorController,
                        'Valor pago',
                        '215.00',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                campo(
                  quilometragemController,
                  'Quilometragem',
                  '52430',
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
                context);
          },
          child:
              const Text('Cancelar'),
        ),

        ElevatedButton(
          onPressed: salvar,
          child:
              const Text('Salvar'),
        ),
      ],
    );
  }

  Widget campo(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return TextFormField(
      controller: controller,

      keyboardType:
          const TextInputType.numberWithOptions(
        decimal: true,
      ),

      decoration:
          InputDecoration(
        labelText: label,
        hintText: hint,
        border:
            const OutlineInputBorder(),
      ),

      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return 'Obrigatório';
        }

        final numero =
            double.tryParse(
          value.replaceAll(
            ',',
            '.',
          ),
        );

        if (numero == null) {
          return 'Valor inválido';
        }

        if (label !=
                'Quilometragem' &&
            numero <= 0) {
          return 'Valor inválido';
        }

        if (label ==
                'Quilometragem' &&
            numero < 0) {
          return 'Valor inválido';
        }

        return null;
      },
    );
  }
}