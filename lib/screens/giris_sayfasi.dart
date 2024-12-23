import 'package:flutter/material.dart';
import '../veritabani.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _emailController = TextEditingController();
  final _sifreConroller = TextEditingController();
  final Veritabani veritabani = Veritabani();
  String _hataMesaj = '';

  void _KullaniciGiris() async {
    final email = _emailController.text.trim();
    final sifre = _sifreConroller.text.trim();

    final kullanici = await veritabani.kullaniciGetir(email, sifre);

    if (kullanici != null) {
      Navigator.pushReplacementNamed(context, '/anasayfa', arguments: kullanici['kullaniciAdi']);
    } else {
      setState(() {
        _hataMesaj = 'E-posta veya şifre hatalı!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            TextField(
              controller: _sifreConroller,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _KullaniciGiris,
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 10),
            if (_hataMesaj.isNotEmpty)
              Text(
                _hataMesaj,
                style: TextStyle(color: Colors.red),
              ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/kayit');
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
