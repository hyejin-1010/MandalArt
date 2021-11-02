import 'package:get/get.dart';
import 'package:madal_art/models/mandalart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataController extends GetxController {
  Database? database;
  RxMap<int, Map<int, MandalArtModel>> data = RxMap<int, Map<int, MandalArtModel>>();

  void initialize() async {
    data = RxMap<int, Map<int, MandalArtModel>>();

    try {
      await _openDatabase();
      await _getMandalArtData();
    } catch (err) { throw err; }

    update();
  }

  Future<bool> updateItem(int group, int index, String content) async {
    MandalArtModel? item = data[group]?[index];
    if (item == null || database == null) { return false; }
    try {
      int result = await database!.rawUpdate(
        'UPDATE MandalArt SET content = ? WHERE id = ?',
        [content, item.id],
      );
      data[group]![index]!.content = content;
      data.refresh();
      return result > 0;
    } catch (_) { return false; }
  }

  Future<void> _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mandalart.db');
    database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE MandalArt (id INTEGER PRIMARY KEY, parent INTEGER, no INTEGER, content TEXT)'
        );
      });
    // deleteDatabase(path);
  }

  Future<void> _getMandalArtData() async {
    if (database == null) { return; }
    final List<Map<String, dynamic>> maps = await database!.query('MandalArt');
    if (maps.length == 0) { return _initTable(); }
    if (data[4] == null) { data[4] = {}; }
      for (Map<String, dynamic> json in maps) {
      MandalArtModel item = MandalArtModel.fromJson(json);
      if (data[item.group] == null) { data[item.group] = {}; }
      data[item.group]![item.index] = item;
      if (item.index == 4) { data[4]![item.group] = item; }
    }
  }

  Future<MandalArtModel> _insert(int group, int index) async {
    int id = (group * 10) + index + 1;
    MandalArtModel item = MandalArtModel(id: id, group: group, index: index);
    await database!.insert(
      'MandalArt',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    data[group]![index] = item;
    if (index == 4) {
      if (data[4] == null) { data[4] = {}; }
      data[4]![group] = item;
    }
    return item;
  }

  void _initTable() async {
    if (database == null) { return; }

    for (int group = 0; group < 9; group ++) {
      if (group == 4) {
        try {
          _insert(group, 4);
        } catch (error) { throw error; }
        continue;
      }
      data[group] = {};
      for (int index = 0; index < 9; index ++) {
        try {
          await _insert(group, index);
        } catch (error) { throw error; }
      }
    }
  }
}