import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import '../veritabani.dart';

class AyarlarSayfasi extends StatefulWidget {
  final KullaniciVerileri kullaniciVerileri;

  const AyarlarSayfasi({Key? key, required this.kullaniciVerileri}) : super(key: key);

  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  final _birakisTarihiController = TextEditingController();
  final _gunlukSigaraController = TextEditingController();
  final _paketFiyatiController = TextEditingController();
  final _paketSigaraSayisiController = TextEditingController();
  final _veritabani = Veritabani();

  @override
  void initState() {
    super.initState();
    // Mevcut verileri form alanlarına doldur
    _birakisTarihiController.text = widget.kullaniciVerileri.birakisTarihi.toString().split(' ')[0];
    _gunlukSigaraController.text = widget.kullaniciVerileri.gunlukIcilenSigara.toString();
    _paketFiyatiController.text = widget.kullaniciVerileri.paketFiyati.toString();
    _paketSigaraSayisiController.text = widget.kullaniciVerileri.paketSigaraSayisi.toString();
  }

  void _verileriGuncelle() async {
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

      final guncelVeriler = KullaniciVerileri(
        id: widget.kullaniciVerileri.id,
        kullaniciId: widget.kullaniciVerileri.kullaniciId,
        birakisTarihi: tarih,
        gunlukIcilenSigara: gunlukSigara,
        paketFiyati: paketFiyati,
        paketSigaraSayisi: paketSigara,
      );

      await _veritabani.kullaniciVerileriKaydet(guncelVeriler);
      
      if (!mounted) return;
      Navigator.pop(context, guncelVeriler);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Beklenmeyen bir hata oluştu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _verileriGuncelle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _birakisTarihiController,
              decoration: InputDecoration(
                labelText: 'Bırakış Tarihi (YYYY-MM-DD)',
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