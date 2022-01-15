import 'package:get/get.dart';
import 'package:madal_art/models/item.dart';
import 'package:madal_art/models/mandalart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataController extends GetxController {
  Database? database;
  RxMap<int, MandalArtModel> mandalart = <int, MandalArtModel>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      await _openDatabase();
      await _getMandalArtData();
    } catch (err) { throw err; }
  }

  Future<bool> updateItem(int group, int index, String content) async {
    /*
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
     */
    return false;
  }

  Future<void> _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mandalart.db');
    try {
      database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE Item (id INTEGER PRIMARY KEY, mandalArtId INTEGER, parent INTEGER, content TEXT, no INTEGER)',
          );
          await db.execute(
            'CREATE TABLE MandalArt (id INTEGER PRIMARY KEY, title TEXT, no INTEGER)',
          );
        });
    } catch (_) {}
  }

  Future<void> _getMandalArtData() async {
    if (database == null) { return; }
    int mandalartId = 0;
    try {
      final List<Map<String, dynamic>> maps = await database!.query('MandalArt');
      if (maps.length == 0) {
        mandalartId = await createMandalArt('첫 번째 만다라트');
        if (mandalartId == -1) { return; }
      } else {
        for (int index = 0; index < maps.length; index ++) {
          dynamic item = maps[index];
          mandalart[item['id']] = MandalArtModel(id: item['id'], title: item['title'], no: item['no']);
        }
      }
      final List<Map<String, dynamic>> itemMaps = await database!.rawQuery('SELECT * from Item where mandalArtId = $mandalartId');
      if (itemMaps.length == 0) {
        await createTables(mandalartId);
      } else {
        for (int index = 0; index < itemMaps.length; index ++) {
          dynamic item = itemMaps[index];
          int mId = item['mandalArtId'];
          int parent = item['parent'];
          int no = item['no'];

          if (mandalart[mId]!.items[parent] == null) {
            mandalart[mId]!.items[parent] = {};
          }
          mandalart[mId]!.items[parent]![no] = ItemModel(id: item['id'], mandalArtId: mId, group: parent, index: no, content: item['content']);
        }
      }
    } catch (_) {}
  }

  Future<int> createMandalArt(String title) async {
    if (database == null) { return -1; }
    int index = mandalart.keys.length;
    MandalArtModel newMandalArt = MandalArtModel(id: index, title: title);
    try {
      await database!.insert(
        'MandalArt',
        newMandalArt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
    mandalart[newMandalArt.id] = newMandalArt;
    return newMandalArt.id;
  }

  Future<void> createTables(int mandalartId) async {
    if (database == null) { return; }

    for (int group = 0; group < 9; group ++) {
      if (group == 4) {
        try {
          _insert(mandalartId, group, 4);
        } catch (error) { throw error; }
        continue;
      }
      for (int index = 0; index < 9; index ++) {
        try {
          await _insert(mandalartId, group, index);
        } catch (error) { throw error; }
      }
    }
  }


  Future<ItemModel> _insert(int mandalArtId, int group, int index) async {
    int id = (group * 10) + index + 1;
    ItemModel item = ItemModel(id: id, mandalArtId: mandalArtId, group: group, index: index);

    try {
      await database!.insert(
        'Item',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}

    if (mandalart[group] == null) { return item; }
    if (mandalart[group]!.items[group] == null) { mandalart[group]!.items[group] = {}; }
    mandalart[group]!.items[group]![index] = item;
    if (index == 4) {
      if (mandalart[group]!.items[4] == null) { mandalart[group]!.items[4] = {}; }
      mandalart[group]!.items[4]![group] = item;
    }
    return item;
  }
}