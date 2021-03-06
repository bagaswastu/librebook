import 'dart:async';

import 'package:librebook/database/settings_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  static final AppDatabase _singleton = AppDatabase._();

  static AppDatabase get instance => _singleton;

  Completer<Database> _dbOpenCompleter;

  AppDatabase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'app_database.db');
    final database = await databaseFactoryIo.openDatabase(dbPath,
        version: 1, onVersionChanged: (db, oldVer, newVer) async {
      if(oldVer == 0){
        // Set default value
        SettingsDatabase().setDefaultSetting();
      }
        });
    _dbOpenCompleter.complete(database);
  }
}
