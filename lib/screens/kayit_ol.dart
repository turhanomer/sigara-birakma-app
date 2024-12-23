import 'package:flutter/material.dart';
import '../veritabani.dart';

class KayitOlSayfasi extends StatefulWidget {
  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitOlSayfasi> {
  final _kullaniciAdiController = TextEditingController();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final Veritabani veritabani = Veritabani();
  String _hataMesaj = '';

  void _kayitKullanici() async {
    if (_kullaniciAdiController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _sifreController.text.isEmpty) {
      setState(() {
        _hataMesaj = 'Lütfen tüm alanları doldurun.';
      });
      return;
    }

    final kullanici = {
      'kullaniciAdi': _kullaniciAdiController.text.trim(),
      'email': _emailController.text.trim(),
      'sifre': _sifreController.text.trim(),
    };

    try {
      final id = await veritabani.kullaniciEkle(kullanici);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/giris');
    } catch (e) {
      setState(() {
        _hataMesaj = 'Bir hata oluştu, lütfen tekrar deneyin.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kayıt Ol')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _kullaniciAdiController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            TextField(
              controller: _sifreController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _kayitKullanici,
              child: Text('Kayıt Ol'),
            ),
            SizedBox(height: 10),
            if (_hataMesaj.isNotEmpty)
              Text(
                _hataMesaj,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
