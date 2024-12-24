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
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context, 
        '/anasayfa', 
        arguments: kullanici['id'] as int
      );
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
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smoke_free,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _sifreConroller,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _KullaniciGiris,
                child: Text('Giriş Yap'),
              ),
              if (_hataMesaj.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    _hataMesaj,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/kayit');
                },
                child: Text('Hesabınız yok mu? Kayıt olun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
