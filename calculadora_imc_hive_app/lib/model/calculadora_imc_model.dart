import 'package:hive/hive.dart';

part 'calculadora_imc_model.g.dart';
@HiveType(typeId: 0)
class CalculadoraImcModel extends HiveObject{
  @HiveField(0)
  double peso = 0;

  @HiveField(1)
  double altura = 0;

  CalculadoraImcModel();

  CalculadoraImcModel.criar(this.peso, this.altura);
}
