import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import 'istatistik_karti.dart';
import '../veritabani.dart';
import 'ayarlar_sayfasi.dart';
import 'veri_giris_sayfasi.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final Veritabani _veritabani = Veritabani();
  KullaniciVerileri? _kullaniciVerileri;
  Timer? _sayac;
  int? _kullaniciId;
  
  // İstatistikler
  Duration _gecenSure = Duration.zero;
  double _birikilenPara = 0;
  int _icilemeyenSigara = 0;
  Duration _kazanilanZaman = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _kullaniciId = ModalRoute.of(context)?.settings.arguments as int?;
      _verileriYukle();
    });
    _sayaciBaslat();
  }

  void _verileriYukle() async {
    if (_kullaniciId == null) return;
    
    final veriler = await _veritabani.kullaniciVerileriGetir(_kullaniciId!);
    if (veriler != null) {
      setState(() {
        _kullaniciVerileri = veriler;
        _istatistikleriGuncelle();
      });
    } else {
      // Veriler yoksa veri giriş sayfasına yönlendir
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VeriGirisSayfasi(kullaniciId: _kullaniciId!),
        ),
      );
    }
  }

  void _ayarlaraGit() async {
    final guncelVeriler = await Navigator.push<KullaniciVerileri>(
      context,
      MaterialPageRoute(
        builder: (context) => AyarlarSayfasi(
          kullaniciVerileri: _kullaniciVerileri!,
        ),
      ),
    );

    if (guncelVeriler != null) {
      setState(() {
        _kullaniciVerileri = guncelVeriler;
        _istatistikleriGuncelle();
      });
    }
  }

  void _sayaciBaslat() {
    _sayac = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_kullaniciVerileri != null) {
        setState(() {
          _istatistikleriGuncelle();
        });
      }
    });
  }

  void _istatistikleriGuncelle() {
    if (_kullaniciVerileri == null) return;

    // Geçen süreyi hesapla
    _gecenSure = DateTime.now().difference(_kullaniciVerileri!.birakisTarihi);

    // Birikilen parayı hesapla
    double gunlukMaliyet = (_kullaniciVerileri!.paketFiyati / _kullaniciVerileri!.paketSigaraSayisi) * 
                          _kullaniciVerileri!.gunlukIcilenSigara;
    _birikilenPara = (gunlukMaliyet * _gecenSure.inDays);

    // İçilmeyen sigara sayısını hesapla
    _icilemeyenSigara = (_gecenSure.inHours * _kullaniciVerileri!.gunlukIcilenSigara ~/ 24);

    // Kazanılan zamanı hesapla (her sigara 5 dakika)
    _kazanilanZaman = Duration(minutes: _icilemeyenSigara * 5);
  }

  @override
  Widget build(BuildContext context) {
    if (_kullaniciVerileri == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('İstatistikler'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _ayarlaraGit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IstatistikKarti(
              baslik: 'Sigarasız Geçen Süre',
              deger: '${_gecenSure.inDays} gün ${_gecenSure.inHours % 24} saat',
            ),
            IstatistikKarti(
              baslik: 'Biriken Para',
              deger: '${_birikilenPara.toStringAsFixed(2)} TL',
            ),
            IstatistikKarti(
              baslik: 'İçilmeyen Sigara',
              deger: '$_icilemeyenSigara adet',
            ),
            IstatistikKarti(
              baslik: 'Kazanılan Zaman',
              deger: '${_kazanilanZaman.inHours} saat ${_kazanilanZaman.inMinutes % 60} dakika',
            ),
            SizedBox(height: 24),
            Text(
              'Her geçen gün daha sağlıklısınız!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sayac?.cancel();
    super.dispose();
  }
}