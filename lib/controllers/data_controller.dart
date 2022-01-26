import 'package:get/get.dart';
import 'package:madal_art/models/item.dart';
import 'package:madal_art/models/mandalart.dart';
import 'package:madal_art/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataController extends GetxController {
  Database? database;
  RxMap<int, MandalArtModel> mandalart = <int, MandalArtModel>{}.obs;
  Rx<int?> mandalartId = Rx<int?>(null);

  MandalArtModel? get currentMandalart {
    if (mandalartId.value == null) { return null; }
    return mandalart[mandalartId.value];
  }

  @override
  void onInit() async {
    super.onInit();
    try {
      await _openDatabase();
      await _getMandalArtData();
    } catch (err) { throw err; }
  }

  void changeMandalartId(int newId) {
    if (mandalartId.value == newId) { return; }
    mandalartId.value = newId;
    if (mandalart[mandalartId.value]?.items.toString() == '{}') {
      initMandalartItems(mandalartId.value!);
    }
  }

  Future<bool> updateMandalartTitle(int id, String title) async {
    if (database == null) { return false; }
    try {
      int result = await database!.rawUpdate(
        'UPDATE MandalArt SET title = ? WHERE id = ?',
        [title, id],
      );
      if (mandalart[id] != null) {
        mandalart[id]!.title = title;
        mandalart.refresh();
      }
      return result > 0;
    } catch (_) { return false; }
  }

  Future<bool> deleteMandalart(int id) async {
    if (database == null) { return false; }
    try {
      int result = await database!.rawDelete('DELETE From MandalArt WHERE id = ?', [id]);
      mandalart.remove(id);
      return result > 0;
    } catch (_) { return false; }
  }

  Future<bool> updateItem(int group, int index, String content) async {
    ItemModel? item = mandalart[mandalartId.value]?.items[group]?[index];
    if (database == null || item == null) { return false; }

    try {
      int result = await database!.rawUpdate(
        'UPDATE Item SET content = ? WHERE id = ?',
        [content, item.id],
      );
      mandalart[mandalartId.value]!.items[group]![index]!.content = content;
      mandalart.refresh();
      return result > 0;
    } catch (_) { return false; }
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
          await db.execute(
            'CREATE TABLE Todo (id INTEGER PRIMARY KEY, content TEXT, isDone BOOLEAN, parent INTEGER, mandalArtId INTEGER)',
          );
        });
    } catch (_) { }
  }

  Future<void> _getMandalArtData() async {
    if (database == null) { return; }
    int newMandalartId = -1;
    try {
      final List<Map<String, dynamic>> maps = await database!.query('MandalArt');
      if (maps.length == 0) {
        newMandalartId = await createMandalArt('첫 번째 만다라트');
        if (newMandalartId == -1) { return; }
      } else {
        for (int index = 0; index < maps.length; index ++) {
          dynamic item = maps[index];
          mandalart[item['id']] = MandalArtModel(id: item['id'], title: item['title'], no: item['no'], items: {});
          if (index == 0) { newMandalartId = item['id']; }
        }
      }
      mandalartId.value = newMandalartId;
      await initMandalartItems(newMandalartId);
    } catch (error) { print('[ERROR] : $error'); }
  }

  Future<void> initMandalartItems(int id) async {
    try {
      final List<Map<String, dynamic>> itemMaps = await database!.rawQuery('SELECT * from Item where mandalArtId = $mandalartId');
      if (itemMaps.length == 0) { return await createTables(id); }

      final List<Map<String, dynamic>> todoMaps = await database!.rawQuery('SELECT * from Todo where mandalArtId = $mandalartId');
      final Map<int, List<TodoModel>> todo = {};

      for (int index = 0; index < todoMaps.length; index ++) {
        int parent = todoMaps[index]['parent'];
        if (todo[parent] == null) { todo[parent] = []; }
        todo[parent]!.add(TodoModel.fromJson(todoMaps[index]));
      }
      for (int index = 0; index < itemMaps.length; index ++) {
        dynamic item = itemMaps[index];
        int mId = item['mandalArtId'];
        int parent = item['parent'];
        int no = item['no'];
        int id = item['id'];

        if (mandalart[mId]!.items[parent] == null) {
          mandalart[mId]!.items[parent] = {};
        }
        ItemModel newItem = ItemModel(id: id, mandalArtId: mId, group: parent, index: no, content: item['content'], todos: todo[id] ?? []);
        mandalart[mId]!.items[parent]![no] = newItem;
        if (no == 4) {
          if (mandalart[mId]!.items[4] == null) { mandalart[mId]!.items[4] = {}; }
          mandalart[mId]!.items[4]![parent] = newItem;
        }
      }
    } catch (_) { rethrow; }
  }

  Future<int> createMandalArt(String title) async {
    if (database == null) { return -1; }
    int index = mandalart.keys.length;
    MandalArtModel newMandalArt = MandalArtModel(id: index, title: title, items: {});
    try {
      int id = await database!.insert(
        'MandalArt',
        newMandalArt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      newMandalArt.id = id;
      mandalart[id] = newMandalArt;
    } catch (_) {}
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
    mandalart.refresh();
  }

  Future<ItemModel> _insert(int mandalArtId, int group, int index) async {
    ItemModel item = ItemModel(id: 0, mandalArtId: mandalArtId, group: group, index: index, todos: []);
    try {
      int id = await database!.insert(
        'Item',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      item.id = id;
    } catch (_) {}

    if (mandalart[mandalArtId] == null) { return item; }
    if (mandalart[mandalArtId]!.items[group] == null) { mandalart[mandalArtId]!.items[group] = {}; }
    mandalart[mandalArtId]!.items[group]![index] = item;
    if (index == 4) {
      if (mandalart[mandalArtId]!.items[4] == null) { mandalart[mandalArtId]!.items[4] = {}; }
      mandalart[mandalArtId]!.items[4]![group] = item;
    }
    return item;
  }

  Future<TodoModel?> createTodo(int group, int index, String content) async {
    ItemModel? item = mandalart[mandalartId.value!]?.items[group]?[index];
    if (item == null) { return null; }
    TodoModel todo = TodoModel(id: 0, parent: item.id, mandalArtId: mandalartId.value!, content: content);
    try {
      int id = await database!.insert(
        'Todo',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      todo.id = id;
    } catch (_) { return null; }
    mandalart[mandalartId.value!]!.items[group]![index]!.todos.add(todo);
    mandalart.refresh();
    return todo;
  }
}