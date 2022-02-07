import 'package:ahmad_pro/models/prodact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHehper {
  static final DbHehper _indtance = DbHehper.internal();
  factory DbHehper() => _indtance;
  String consultantDBName = 'consultantproduct.db';
  String tableName = 'product';
  String tableVisa = 'visa';
  DbHehper.internal();
  static Database _db;
  Future<Database> createDataBase() async {
    if (_db != null) {
      return _db;
    }
    String path = join(await getDatabasesPath(), consultantDBName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int v) {
        db.execute(
          'create table $tableName(id integer primary key autoincrement ,' +
              'title varcher(50) , proImageUrl varcher(255) ,dateId integer,' +
              'consultantId integer,price double,date varcher(50),time varcher(50),type varcher(50))',
        );
        db.execute(
          'create table $tableVisa(id integer primary key autoincrement ,' +
              'cvvNumber varcher(50),exDate varcher(50),visaNumber varcher(50),type varcher(50))',
        );
      },
    );
    return _db;
  }

  Future<int> createProduct(ConsultantProdect product) async {
    Database db = await createDataBase();
    return db.insert(
      tableName,
      product.toMap(),
    );
  }

  Future<List> allProduct() async {
    Database db = await createDataBase();
    return db.query(
      tableName,
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await createDataBase();
    return db.delete(tableName, where: 'id=?', whereArgs: [id]);
  }

  Future<ConsultantProdect> getProductById(int id) async {
    Database db = await createDataBase();
    var result =
        await db.query(tableName, where: 'consultantId=?', whereArgs: [id]);
    return result.isNotEmpty ? ConsultantProdect.formMap(result.first) : null;
  }

  deleteAllProduct() async {
    Database db = await createDataBase();
    return db.delete(tableName);
  }

//////////////VISIA????????????///////////
  Future<int> createvisa(CustomVisa visa) async {
    Database db = await createDataBase();
    return db.insert(
      tableVisa,
      visa.toMap(),
    );
  }

  Future<List> allvisa() async {
    Database db = await createDataBase();
    return db.query(
      tableVisa,
    );
  }

  Future<int> deletevisa(int id) async {
    Database db = await createDataBase();
    return db.delete(tableVisa, where: 'id=?', whereArgs: [id]);
  }

  deleteAllvisa() async {
    Database db = await createDataBase();
    return db.delete(tableVisa);
  }
}
