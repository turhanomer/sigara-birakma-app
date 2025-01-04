import 'package:flutter/material.dart';
import '../veritabani.dart';

class KayitOlSayfasi extends StatefulWidget {
  const KayitOlSayfasi({super.key});

  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitOlSayfasi> {
  final _kullaniciAdiController = TextEditingController();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final Veritabani veritabani = Veritabani();
  String _hataMesaj = '';

  void _kayitKullanici() async {
    if (_kullaniciAdiController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _sifreController.text.isEmpty) {
      setState(() {
        _hataMesaj = 'Lütfen tüm alanları doldurun.';
      });
      return;
    }

    final kullanici = {
      'kullaniciAdi': _kullaniciAdiController.text.trim(),
      'email': _emailController.text.trim(),
      'sifre': _sifreController.text.trim(),
    };

    try {
      final id = await veritabani.kullaniciEkle(kullanici);
      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/giris',
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _hataMesaj = 'Bir hata oluştu, lütfen tekrar deneyin.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Kayıt Ol',
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
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                'Hesabınızı Oluşturun',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: _kullaniciAdiController,
                label: 'Kullanıcı Adı',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'E-posta',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _sifreController,
                label: 'Şifre',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
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
                    onPressed: _kayitKullanici,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_hataMesaj.isNotEmpty)
                Text(
                  _hataMesaj,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
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
        obscureText: isPassword,
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
            color: Colors.grey[600],
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
}
