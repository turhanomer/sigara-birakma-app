import 'package:flutter/material.dart';
import '../veritabani.dart';

class DilSecenekleri extends StatefulWidget {
  final int kullaniciId;

  const DilSecenekleri({Key? key, required this.kullaniciId}) : super(key: key);

  @override
  _DilSecenekleriState createState() => _DilSecenekleriState();
}

class _DilSecenekleriState extends State<DilSecenekleri> {
  final Veritabani _veritabani = Veritabani();
  String _secilenDil = 'tr';

  @override
  void initState() {
    super.initState();
    _dilAyariniYukle();
  }

  Future<void> _dilAyariniYukle() async {
  }

  Future<void> _dilAyariniKaydet(String dilKodu) async {
    setState(() {
      _secilenDil = dilKodu;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dil ayarı güncellendi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDilSecenegi({
    required String dilKodu,
    required String dilAdi,
    required String bayrakEmoji,
  }) {
    final bool secili = _secilenDil == dilKodu;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: secili
                ? Color(0xFF6A88E5).withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            bayrakEmoji,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        title: Text(
          dilAdi,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: secili ? Color(0xFF6A88E5) : Colors.black87,
          ),
        ),
        trailing:
            secili ? Icon(Icons.check_circle, color: Color(0xFF6A88E5)) : null,
        onTap: () => _dilAyariniKaydet(dilKodu),
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
          'Dil Seçenekleri',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tercih ettiğiniz dili seçin',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              _buildDilSecenegi(
                dilKodu: 'tr',
                dilAdi: 'Türkçe',
                bayrakEmoji: '🇹🇷',
              ),
              _buildDilSecenegi(
                dilKodu: 'en',
                dilAdi: 'English',
                bayrakEmoji: '🇬🇧',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
