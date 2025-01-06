import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../models/kullanici_verileri.dart';
import '../veritabani.dart';

class AyarlarSayfasi extends StatefulWidget {
  final KullaniciVerileri kullaniciVerileri;

  const AyarlarSayfasi({super.key, required this.kullaniciVerileri});

  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  final _birakisTarihiController = TextEditingController();
  final _gunlukSigaraController = TextEditingController();
  final _paketFiyatiController = TextEditingController();
  final _paketSigaraSayisiController = TextEditingController();
  final _veritabani = Veritabani();
  DateTime? _secilenTarih;
  String _kullaniciAdi = '';

  @override
  void initState() {
    super.initState();
    _secilenTarih = widget.kullaniciVerileri.birakisTarihi;
    _birakisTarihiController.text =
        widget.kullaniciVerileri.birakisTarihi.toString().split(' ')[0];
    _gunlukSigaraController.text =
        widget.kullaniciVerileri.gunlukIcilenSigara.toString();
    _paketFiyatiController.text =
        widget.kullaniciVerileri.paketFiyati.toString();
    _paketSigaraSayisiController.text =
        widget.kullaniciVerileri.paketSigaraSayisi.toString();
    _kullaniciBilgileriniGetir();
  }

  Future<void> _kullaniciBilgileriniGetir() async {
    final kullanici = await _veritabani
        .kullaniciGetirById(widget.kullaniciVerileri.kullaniciId);
    if (kullanici != null && mounted) {
      setState(() {
        _kullaniciAdi = kullanici['kullaniciAdi'] ?? '';
      });
    }
  }

  Future<void> _tarihSec() async {
    final DateTime? secilen = await showDatePicker(
      context: context,
      initialDate: _secilenTarih ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6A88E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF6A88E5),
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                fontFamily: 'Poppins',
              ),
              labelSmall: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          child: Container(
            child: child,
          ),
        );
      },
    );

    if (secilen != null) {
      setState(() {
        _secilenTarih = secilen;
        _birakisTarihiController.text =
            "${secilen.day.toString().padLeft(2, '0')}.${secilen.month.toString().padLeft(2, '0')}.${secilen.year}";
      });
    }
  }

  void _verileriGuncelle() async {
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

      final guncelVeriler = KullaniciVerileri(
        id: widget.kullaniciVerileri.id,
        kullaniciId: widget.kullaniciVerileri.kullaniciId,
        birakisTarihi: _secilenTarih!,
        gunlukIcilenSigara: gunlukSigara,
        paketFiyati: paketFiyati,
        paketSigaraSayisi: paketSigara,
      );

      await _veritabani.kullaniciVerileriKaydet(guncelVeriler);

      if (!mounted) return;

      // Başarılı kayıt mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ayarlar başarıyla kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );

      // Ana sayfayı yeniden yükle
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/anasayfa',
        (route) => false,
        arguments: widget.kullaniciVerileri.kullaniciId,
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

  Future<void> _istatistikleriSifirla() async {
    try {
      // Önce mevcut verileri sil
      await _veritabani
          .kullaniciVerileriniSifirla(widget.kullaniciVerileri.kullaniciId);

      // Yeni veriler oluştur (sadece temel bilgilerle)
      final yeniVeriler = KullaniciVerileri(
        kullaniciId: widget.kullaniciVerileri.kullaniciId,
        birakisTarihi: DateTime.now(),
        gunlukIcilenSigara: widget.kullaniciVerileri.gunlukIcilenSigara,
        paketFiyati: widget.kullaniciVerileri.paketFiyati,
        paketSigaraSayisi: widget.kullaniciVerileri.paketSigaraSayisi,
      );

      // Yeni verileri kaydet
      await _veritabani.kullaniciVerileriKaydet(yeniVeriler);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('İstatistikler sıfırlandı!'),
          backgroundColor: Colors.green,
        ),
      );

      // Ana sayfaya yönlendir
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/anasayfa',
        (route) => false,
        arguments: widget.kullaniciVerileri.kullaniciId,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sifirlamaDialogGoster() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Uyarı',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sigara içtiniz, sıfırlama yapmak istediğinize emin misiniz?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Bu işlem:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Bırakış tarihinizi şu ana güncelleyecek\n• Tüm istatistikler sıfırdan başlayacak\n• Bu işlem geri alınamaz',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Sıfırla',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _istatistikleriSifirla();
              },
            ),
          ],
        );
      },
    );
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                      onPressed: _verileriGuncelle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Kaydet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 55,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade400,
                          Colors.red.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _sifirlamaDialogGoster,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Sigara İçtim Başa Sar',
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
