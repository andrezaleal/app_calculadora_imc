import 'package:calculadora_imc_app/model/calculadora_imc_model.dart';
import 'package:hive/hive.dart';

class CalculadoraImcRepository{
  static late Box _box;

  CalculadoraImcRepository._criar();

 static Future<CalculadoraImcRepository> carregar() async {
    if (Hive.isBoxOpen('tarefaHiveModel')) {
      _box = Hive.box('tarefaHiveModel');
    } else {
      _box = await Hive.openBox('tarefaHiveModel');
    }
    return CalculadoraImcRepository._criar();
  }

  salvar(CalculadoraImcModel calculadoraImcModel) {
    _box.add(calculadoraImcModel);
  }

  excluir(CalculadoraImcModel calculadoraImcModel) {
    calculadoraImcModel.delete();
  }

  double calculo(double peso, double altura) {
    return peso / (altura * altura);
  }

   String calcularSituacaoImc(double imc) {
    if (imc < 16) {
      return "Magreza grave";
    } else if (imc > 16 && imc < 17) {
      return "Magreza moderada";
    } else if (imc > 17 && imc < 18.5) {
      return "Magreza leve";
    } else if (imc > 18.5 && imc < 25) {
      return "Saudável";
    } else if (imc > 25 && imc < 30) {
      return "Sobrepeso";
    } else if (imc > 30 && imc < 35) {
      return "Obesidade Grau I";
    } else if (imc > 35 && imc < 40) {
      return "Obesidade Grau II (severa)";
    } else {
      return "Obesidade Grau III (mórbida)";
    }
  }

  List<CalculadoraImcModel> obterDados(){
    return _box.values.cast<CalculadoraImcModel>().toList();
  }

}