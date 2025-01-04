import 'package:flutter/material.dart';
import '../veritabani.dart';

class ProfilDuzenle extends StatefulWidget {
  final int kullaniciId;
  final String mevcutKullaniciAdi;
  final int? mevcutAvatarIndex;

  const ProfilDuzenle({
    Key? key,
    required this.kullaniciId,
    required this.mevcutKullaniciAdi,
    this.mevcutAvatarIndex,
  }) : super(key: key);

  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  final _kullaniciAdiController = TextEditingController();
  final _veritabani = Veritabani();
  int? _secilenAvatarIndex;

  final List<String> _avatarlar = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
  ];

  @override
  void initState() {
    super.initState();
    _kullaniciAdiController.text = widget.mevcutKullaniciAdi;
    _secilenAvatarIndex = widget.mevcutAvatarIndex;
  }

  Future<void> _profilGuncelle() async {
    if (_kullaniciAdiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı adı boş olamaz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _veritabani.kullaniciGuncelle(
        widget.kullaniciId,
        _kullaniciAdiController.text.trim(),
        _secilenAvatarIndex ?? 0,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil başarıyla güncellendi'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAvatarSecici() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          final isSelected = _secilenAvatarIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _secilenAvatarIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFF6A88E5) : Colors.transparent,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    AssetImage('assets/avatars/avatar${index + 1}.png'),
                backgroundColor: Colors.grey[200],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profili Düzenle',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profil Fotoğrafı',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildAvatarSecici(),
            SizedBox(height: 32),
            Container(
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
                controller: _kullaniciAdiController,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Color(0xFF6A88E5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 32),
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
                  onPressed: _profilGuncelle,
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
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kullaniciAdiController.dispose();
    super.dispose();
  }
}
