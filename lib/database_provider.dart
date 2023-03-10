import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'cirurgico_model.dart';

class OfflineDatabaseProvider {
  static Database? _database;

  OfflineDatabaseProvider() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDatabase();
    return _database!;
  }

  Future<List<CirurgicoModel>> getCirurgicoForm() async {
    final db = await database;

    try {
      final List<CirurgicoModel> cirurgicoList = [];

      final List<Map<String, dynamic>> list = await db.query('cirurgico');

      list.forEach((element) {
        cirurgicoList.add(CirurgicoModel.fromJson(json: element));
      });

      return cirurgicoList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> saveCirurgicoForm({
    required Map<String, dynamic> data,
  }) async {
    final db = await database;

    try {
      return await db.insert('cirurgico', data);
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'victoria.db'),
      onCreate: (Database db, int version) async {
        return await db.execute(
            'CREATE TABLE cirurgico (id INTEGER PRIMARY KEY AUTOINCREMENT, nome_paciente TEXT, data_nascimento TEXT, tempo_internacao TEXT, comorbidades TEXT, fatores_risco TEXT, classificacao TEXT, complexidade TEXT, localizacao TEXT, exsudato TEXT, volumeexsudato TEXT, tecidos TEXT, bordas TEXT, comprimento TEXT, profundidade TEXT, sinaisinfeccao TEXT, dor TEXT )');
      },
      version: 1,
    );
  }

  Future<int> deleteRecordTable(String nomePaciente) async {
    final db = await database;

    try {
      return await db.rawDelete(
          'DELETE FROM cirurgico WHERE nome_paciente = ?', [nomePaciente]);
    } catch (e) {
      print(e);
      return 0;
    }
  }
}


 /*
nomePaciente: json['nome_paciente'],
      dataNascimento: json['data_nascimento'],
      tempoInternacao: json['tempo_internacao'],
      comorbidades: json['comorbidades'],
      complexidade: json['complexidade'],
      localizacao: json['localizacao'],
      exsudato: json['exsudato'],
      tecidos: json['tecidos'],
      bordas: json['bordas'],
      comprimento: json['comprimento'],
      profundidade: json['profundidade'],
      dor: json['dor'],


 */