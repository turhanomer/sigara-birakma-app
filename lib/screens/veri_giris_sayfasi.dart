import 'package:flutter/material.dart';
import '../models/kullanici_verileri.dart';
import '../veritabani.dart';

class VeriGirisSayfasi extends StatefulWidget {
  final int kullaniciId;

  const VeriGirisSayfasi({super.key, required this.kullaniciId});

  @override
  _VeriGirisSayfasiState createState() => _VeriGirisSayfasiState();
}

class _VeriGirisSayfasiState extends State<VeriGirisSayfasi> {
  final _birakisTarihiController = TextEditingController();
  final _gunlukSigaraController = TextEditingController();
  final _paketFiyatiController = TextEditingController();
  final _paketSigaraSayisiController = TextEditingController();
  final _veritabani = Veritabani();
  DateTime? _secilenTarih;

  Future<void> _tarihSec() async {
    final DateTime? secilen = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6A88E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF6A88E5),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (secilen != null) {
      setState(() {
        _secilenTarih = secilen;
        _birakisTarihiController.text = secilen.toString().split(' ')[0];
      });
    }
  }

  void _verileriKaydet() async {
    try {
      if (_secilenTarih == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lütfen bir tarih seçin')),
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

      final paketFiyati =
          double.tryParse(_paketFiyatiController.text.replaceAll(',', '.'));
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
        birakisTarihi: _secilenTarih!,
        gunlukIcilenSigara: gunlukSigara,
        paketFiyati: paketFiyati,
        paketSigaraSayisi: paketSigara,
      );

      await _veritabani.kullaniciVerileriKaydet(veriler);

      if (!mounted) return;

      // Başarılı kayıt mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bilgileriniz başarıyla kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );

      // Ana sayfaya yönlendir
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/anasayfa',
        (route) => false,
        arguments: widget.kullaniciId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Beklenmeyen bir hata oluştu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Color(0xFF6A88E5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color(0xFF6A88E5),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Sigara Bırakma Planı',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
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
                          Icons.smoke_free,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sigara Bırakma Yolculuğunuz\nBaşlıyor!',
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
                  SizedBox(height: 32),
                  _buildTextField(
                    controller: _birakisTarihiController,
                    label: 'Bırakış Tarihi',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: _tarihSec,
                  ),
                  _buildTextField(
                    controller: _gunlukSigaraController,
                    label: 'Günlük İçilen Sigara Sayısı',
                    icon: Icons.smoking_rooms,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    controller: _paketFiyatiController,
                    label: 'Paket Fiyatı (TL)',
                    icon: Icons.currency_lira,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  _buildTextField(
                    controller: _paketSigaraSayisiController,
                    label: 'Paketteki Sigara Sayısı',
                    icon: Icons.inventory_2,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: 55,
                    child: DecoratedBox(
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
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _verileriKaydet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Başla',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
