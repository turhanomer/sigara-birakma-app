import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import 'istatistik_karti.dart';
import '../veritabani.dart';
import 'ayarlar_sayfasi.dart';
import 'veri_giris_sayfasi.dart';
import 'profil_ekrani.dart';
import 'basarimlar_sayfasi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final Veritabani _veritabani = Veritabani();
  KullaniciVerileri? _kullaniciVerileri;
  Timer? _sayac;
  int? _kullaniciId;
  int _selectedIndex = 0;

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
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VeriGirisSayfasi(kullaniciId: _kullaniciId!),
        ),
      );
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

    _gecenSure = DateTime.now().difference(_kullaniciVerileri!.birakisTarihi);

    double gunlukMaliyet = (_kullaniciVerileri!.paketFiyati /
            _kullaniciVerileri!.paketSigaraSayisi) *
        _kullaniciVerileri!.gunlukIcilenSigara;
    _birikilenPara = (gunlukMaliyet * _gecenSure.inDays);

    _icilemeyenSigara =
        (_gecenSure.inDays * _kullaniciVerileri!.gunlukIcilenSigara).floor();

    _kazanilanZaman = Duration(minutes: _icilemeyenSigara * 5);
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '$days gün $hours saat $minutes dk $seconds sn';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIstatistiklerSayfasi() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IstatistikKarti(
            baslik: 'Sigarasız Geçen Süre',
            deger: _formatDuration(_gecenSure),
            icon: Icons.timer_outlined,
          ),
          IstatistikKarti(
            baslik: 'Biriken Para',
            deger: '${_birikilenPara.toStringAsFixed(2)} TL',
            icon: Icons.currency_lira,
          ),
          IstatistikKarti(
            baslik: 'İçilmeyen Sigara',
            deger: '$_icilemeyenSigara adet',
            icon: Icons.smoke_free,
          ),
          IstatistikKarti(
            baslik: 'Kazanılan Zaman',
            deger:
                '${_kazanilanZaman.inHours} saat ${_kazanilanZaman.inMinutes % 60} dakika',
            icon: Icons.hourglass_bottom,
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A88E5),
                  Color(0xFF4B66C7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6A88E5).withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'Her geçen gün daha sağlıklısınız!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_kullaniciVerileri == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6A88E5),
          ),
        ),
      );
    }

    final List<Widget> _sayfalar = [
      _buildIstatistiklerSayfasi(),
      BasarimlarSayfasi(kullaniciId: _kullaniciId!),
      AyarlarSayfasi(kullaniciVerileri: _kullaniciVerileri!),
      ProfilEkrani(kullaniciId: _kullaniciId!),
    ];

    final List<String> _basliklar = [
      'İstatistikler',
      'Başarımlar',
      'Ayarlar',
      'Hesabım'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _basliklar[_selectedIndex],
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _sayfalar[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'İstatistikler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Başarımlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hesabım',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6A88E5),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _sayac?.cancel();
    super.dispose();
  }
}
