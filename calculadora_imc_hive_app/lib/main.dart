import 'package:calculadora_imc_app/model/calculadora_imc_model.dart';
import 'package:calculadora_imc_app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);
  Hive.registerAdapter(CalculadoraImcModelAdapter());
  runApp(const MyApp());
}
