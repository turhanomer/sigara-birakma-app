import 'package:flutter/material.dart';
import '../veritabani.dart';

class ProfilEkrani extends StatefulWidget {
  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final Veritabani veritabani = Veritabani();
  String kullaniciAdi = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _KullaniciBilgiYukle();
  }

  void _KullaniciBilgiYukle() async {
    final kullanici = await veritabani.kullaniciGetir('user@example.com', 'password123');

    if (kullanici != null) {
      setState(() {
        kullaniciAdi = kullanici['kullaniciAdi'];
        email = kullanici['email'];
      });
    } else {
      setState(() {
        kullaniciAdi = 'Kullanıcı bulunamadı';
        email = 'E-posta bulunamadı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kullanıcı Adı: $kullaniciAdi',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'E-posta: $email',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
