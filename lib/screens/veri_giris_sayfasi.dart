import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import '../veritabani.dart';

class VeriGirisSayfasi extends StatefulWidget {
  final int kullaniciId;

  const VeriGirisSayfasi({Key? key, required this.kullaniciId}) : super(key: key);

  @override
  _VeriGirisSayfasiState createState() => _VeriGirisSayfasiState();
}

class _VeriGirisSayfasiState extends State<VeriGirisSayfasi> {
  final _birakisTarihiController = TextEditingController();
  final _gunlukSigaraController = TextEditingController();
  final _paketFiyatiController = TextEditingController();
  final _paketSigaraSayisiController = TextEditingController();
  final _veritabani = Veritabani();

  void _verileriKaydet() async {
    if (_birakisTarihiController.text.isEmpty ||
        _gunlukSigaraController.text.isEmpty ||
        _paketFiyatiController.text.isEmpty ||
        _paketSigaraSayisiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    try {
      final tarih = DateTime.tryParse(_birakisTarihiController.text);
      if (tarih == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçerli bir tarih giriniz (YYYY-MM-DD)')),
        );
        return;
      }

      final gunlukSigara = int.tryParse(_gunlukSigaraController.text);
      if (gunlukSigara == null || gunlukSigara <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçerli bir günlük sigara sayısı giriniz')),
        );
        return;
      }

      final paketFiyati = double.tryParse(_paketFiyatiController.text.replaceAll(',', '.'));
      if (paketFiyati == null || paketFiyati <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçerli bir paket fiyatı giriniz')),
        );
        return;
      }

      final paketSigara = int.tryParse(_paketSigaraSayisiController.text);
      if (paketSigara == null || paketSigara <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçerli bir paket sigara sayısı giriniz')),
        );
        return;
      }

      final veriler = KullaniciVerileri(
        kullaniciId: widget.kullaniciId,
        birakisTarihi: tarih,
        gunlukIcilenSigara: gunlukSigara,
        paketFiyati: paketFiyati,
        paketSigaraSayisi: paketSigara,
      );

      await _veritabani.kullaniciVerileriKaydet(veriler);
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/anasayfa',
        arguments: widget.kullaniciId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Beklenmeyen bir hata oluştu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sigara Bırakma Bilgileri')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _birakisTarihiController,
              decoration: InputDecoration(
                labelText: 'Bırakış Tarihi (YYYY-MM-DD)',
                hintText: '2024-03-21',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gunlukSigaraController,
              decoration: InputDecoration(
                labelText: 'Günlük İçilen Sigara Sayısı',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _paketFiyatiController,
              decoration: InputDecoration(
                labelText: 'Paket Fiyatı (TL)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _paketSigaraSayisiController,
              decoration: InputDecoration(
                labelText: 'Paketteki Sigara Sayısı',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verileriKaydet,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Kaydet ve Devam Et'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _birakisTarihiController.dispose();
    _gunlukSigaraController.dispose();
    _paketFiyatiController.dispose();
    _paketSigaraSayisiController.dispose();
    super.dispose();
  }
} 