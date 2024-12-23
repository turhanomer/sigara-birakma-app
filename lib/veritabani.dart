import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/kullanici_verileri.dart';

class Veritabani {
  static Database? _veritabani;

  Future<Database> get veritabani async {
    if (_veritabani != null) return _veritabani!;
    _veritabani = await veritabaniBaslat();
    return _veritabani!;
  }

  Future<Database> veritabaniBaslat() async {
    String yol = join(await getDatabasesPath(), 'uygulama.db');
    return openDatabase(
      yol, 
      onCreate: (vt, surum) async {
        await vt.execute('''
          CREATE TABLE kullanicilar(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullaniciAdi TEXT,
            email TEXT UNIQUE,
            sifre TEXT
          )
        ''');
        await vt.execute('''
          CREATE TABLE kullanici_verileri(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullanici_id INTEGER,
            birakis_tarihi TEXT,
            gunluk_icilen_sigara INTEGER,
            paket_fiyati REAL,
            paket_sigara_sayisi INTEGER,
            FOREIGN KEY (kullanici_id) REFERENCES kullanicilar (id)
          )
        ''');
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE kullanici_verileri(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              kullanici_id INTEGER,
              birakis_tarihi TEXT,
              gunluk_icilen_sigara INTEGER,
              paket_fiyati REAL,
              paket_sigara_sayisi INTEGER,
              FOREIGN KEY (kullanici_id) REFERENCES kullanicilar (id)
            )
          ''');
        }
      },
    );
  }

  Future<int> kullaniciEkle(Map<String, dynamic> kullanici) async {
    final vt = await veritabani;
    return await vt.insert('kullanicilar', kullanici,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> kullanicilariSil() async {
    final vt = await veritabani;
    await vt.delete('kullanicilar');
  }

  Future<Map<String, dynamic>?> kullaniciGetir(String email, String sifre) async {
    final vt = await veritabani;
    List<Map<String, dynamic>> sonuc = await vt.query(
      'kullanicilar',
      where: 'email = ? AND sifre = ?',
      whereArgs: [email, sifre],
    );
    return sonuc.isNotEmpty ? sonuc.first : null;
  }

  Future<void> kullaniciVerileriKaydet(KullaniciVerileri veriler) async {
    final vt = await veritabani;
    await vt.insert('kullanici_verileri', veriler.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<KullaniciVerileri?> kullaniciVerileriGetir(int kullaniciId) async {
    final vt = await veritabani;
    final List<Map<String, dynamic>> maps = await vt.query(
      'kullanici_verileri',
      where: 'kullanici_id = ?',
      whereArgs: [kullaniciId],
    );

    if (maps.isEmpty) return null;
    return KullaniciVerileri.fromMap(maps.first);
  }
}
