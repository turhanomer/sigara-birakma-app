import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Veritabani {
  static Database? _veritabani;

  Future<Database> get veritabani async {
    if (_veritabani != null) return _veritabani!;
    _veritabani = await veritabaniBaslat();
    return _veritabani!;
  }

  Future<Database> veritabaniBaslat() async {
    String yol = join(await getDatabasesPath(), 'uygulama.db');
    return openDatabase(yol, onCreate: (vt, surum) async {
      await vt.execute('''
        CREATE TABLE kullanicilar(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          kullaniciAdi TEXT,
          email TEXT UNIQUE,
          sifre TEXT
        )
      ''');
    }, version: 1);
  }

  Future<void> kullaniciEkle(Map<String, dynamic> kullanici) async {
    final vt = await veritabani;
    // Tüm kullanıcıları sil
    await kullanicilariSil();
    // Yeni kullanıcı ekle
    await vt.insert('kullanicilar', kullanici,
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
}
