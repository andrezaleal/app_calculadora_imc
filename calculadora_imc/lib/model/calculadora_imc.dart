import 'package:flutter/material.dart';

class CalculadoraImc {
  String _id = UniqueKey().toString();
  double _peso = 0;
  double _altura = 0;

  CalculadoraImc(this._peso, this._altura);

  String get id => _id;

  double get peso => _peso;

  set peso(double peso) {
    _peso = peso;
  }

  double get altura => _altura;

  set altura(double altura) {
    _altura = altura;
  }

  double get calculo => peso/(altura*altura);

}
