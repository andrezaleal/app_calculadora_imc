import 'package:calculadora_imc_app/model/calculadora_imc.dart';

class CalculadoraImcRepository{
  List<CalculadoraImc> _lista = [];

  Future<void> adicionar(CalculadoraImc calculo) async{
    await Future.delayed(Duration(microseconds: 200));
    _lista.add(calculo);
  }

  Future<List<CalculadoraImc>> listar() async{
     await Future.delayed(Duration(microseconds: 200));
     return _lista;
  }

   Future<void> remove(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _lista.remove(_lista.where((calculo) => calculo.id == id).first);
  }



}