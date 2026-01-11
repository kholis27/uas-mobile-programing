import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static const String _dbName = 'notes_app.db';
  static const int _dbVersion = 1;
  static const String table = 'notes';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            category TEXT NOT NULL,
            phone TEXT,
            email TEXT,
            whatsapp TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert(table, note.toMap());
  }

  Future<List<Note>> getNotes({String? query}) async {
    final db = await database;
    final q = query?.trim() ?? '';
    final hasQuery = q.isNotEmpty;

    final maps = await db.query(
      table,
      where:
          hasQuery ? 'title LIKE ? OR content LIKE ? OR category LIKE ?' : null,
      whereArgs: hasQuery ? ['%$q%', '%$q%', '%$q%'] : null,
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<int> updateNote(Note note) async {
    if (note.id == null) throw Exception('updateNote gagal: id null');
    final db = await database;
    return db
        .update(table, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
