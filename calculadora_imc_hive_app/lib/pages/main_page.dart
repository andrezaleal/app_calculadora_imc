import 'package:calculadora_imc_app/model/calculadora_imc_model.dart';
import 'package:calculadora_imc_app/repositories/calculadora_imc_repository.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CalculadoraImcRepository calculadoraImcRepository;
  var _listaCalculos = const <CalculadoraImcModel>[];
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listarCalculos();
  }

  void listarCalculos() async {
    calculadoraImcRepository = await CalculadoraImcRepository.carregar();
    _listaCalculos = calculadoraImcRepository.obterDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora Imc")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pesoController.text = "";
          alturaController.text = "";
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    title: const Text("Adicionar Calculo Imc"),
                    content: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: "Peso"),
                          controller: pesoController,
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: "Altura"),
                          controller: alturaController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () async {
                            try {
                              await calculadoraImcRepository.salvar(
                                  CalculadoraImcModel.criar(
                                      double.parse(pesoController.text),
                                      double.parse(alturaController.text)));
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text("Calculadora IMC"),
                                      content: const Text(
                                          "Informe uma altura e peso válidos"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    );
                                  });
                              return;
                            }

                            Navigator.pop(context);
                            listarCalculos();
                            setState(() {});
                          },
                          child: const Text("Salvar")),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView.builder(
          itemCount: _listaCalculos.length,
          itemBuilder: (BuildContext bc, int index) {
            var calculos = _listaCalculos[index];
            var imc = calculadoraImcRepository.calculo(calculos.peso, calculos.altura);
            return Dismissible(
              onDismissed: (DismissDirection dismissDirection) async {
                await calculadoraImcRepository.excluir(calculos);
                listarCalculos();
              },
              key: Key(calculos.peso.toString()),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 8,
                shadowColor: Colors.grey,
                child: ListTile(
                  title: Column(
                    children: [
                      Text("Peso: ${calculos.peso}"),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("Altura: ${calculos.altura.toStringAsFixed(2)}"),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("IMC: ${imc.toStringAsFixed(1)}"),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "A stiuação desse IMC é: ${calculadoraImcRepository.calcularSituacaoImc(imc)}",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
