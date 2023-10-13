import 'package:calculadora_imc_app/model/calculadora_imc.dart';
import 'package:calculadora_imc_app/repositories/calculadora_imc_repository.dart';
import 'package:calculadora_imc_app/service/imc_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var calculadoraImcRepository = CalculadoraImcRepository();
  var _listaCalculos = const <CalculadoraImc>[];
  ImcService imcService = ImcService();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listarCalculos();
  }

  void listarCalculos() async {
    _listaCalculos = await calculadoraImcRepository.listar();
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
                              await calculadoraImcRepository.adicionar(
                                  CalculadoraImc(
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
            return Dismissible(
              onDismissed: (DismissDirection dismissDirection) async {
                await calculadoraImcRepository.remove(calculos.id);
                listarCalculos();
              },
              key: Key(calculos.id),
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
                      Text("IMC: ${calculos.calculo.toStringAsFixed(1)}"),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("A stiuação desse IMC é: ${imcService.calcularSituacaoImc(calculos.calculo)}", textAlign: TextAlign.center,),
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
