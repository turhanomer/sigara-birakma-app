import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import 'istatistik_karti.dart';
import '../veritabani.dart';
import 'ayarlar_sayfasi.dart';
import 'veri_giris_sayfasi.dart';
import 'profil_ekrani.dart';

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
        (_gecenSure.inHours * _kullaniciVerileri!.gunlukIcilenSigara ~/ 24);

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
            icon: Icons.savings_outlined,
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
      AyarlarSayfasi(kullaniciVerileri: _kullaniciVerileri!),
      ProfilEkrani(kullaniciId: _kullaniciId!),
    ];

    final List<String> _basliklar = ['İstatistikler', 'Ayarlar', 'Hesabım'];

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Icon(Icons.bar_chart, size: 32),
                ),
                label: 'İstatistikler',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Icon(Icons.settings, size: 32),
                ),
                label: 'Ayarlar',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Icon(Icons.person, size: 32),
                ),
                label: 'Hesabım',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF6A88E5),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.8,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              height: 1.8,
            ),
            onTap: _onItemTapped,
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(size: 32),
            unselectedIconTheme: IconThemeData(size: 32),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            iconSize: 32,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          ),
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
