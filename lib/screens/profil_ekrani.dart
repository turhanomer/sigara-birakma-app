import 'package:flutter/material.dart';
import '../veritabani.dart';
import 'profil_duzenle.dart';
import 'hakkinda_sayfasi.dart';
import 'bildirim_ayarlari.dart';
import 'dil_secenekleri.dart';
import 'yardim_ve_destek.dart';
import 'gizlilik_politikasi.dart';

class ProfilEkrani extends StatefulWidget {
  final int kullaniciId;

  const ProfilEkrani({Key? key, required this.kullaniciId}) : super(key: key);

  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final Veritabani _veritabani = Veritabani();
  String _kullaniciAdi = '';
  int? _avatarIndex;

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniGetir();
  }

  Future<void> _kullaniciBilgileriniGetir() async {
    final kullanici = await _veritabani.kullaniciGetirById(widget.kullaniciId);
    if (kullanici != null) {
      setState(() {
        _kullaniciAdi = kullanici['kullaniciAdi'] ?? '';
        _avatarIndex = kullanici['avatarIndex'];
      });
    }
  }

  Future<void> _cikisYap() async {
    Navigator.of(context).pushNamedAndRemoveUntil('/giris', (route) => false);
  }

  Future<void> _profilDuzenle() async {
    final sonuc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilDuzenle(
          kullaniciId: widget.kullaniciId,
          mevcutKullaniciAdi: _kullaniciAdi,
          mevcutAvatarIndex: _avatarIndex,
        ),
      ),
    );

    if (sonuc == true) {
      _kullaniciBilgileriniGetir();
    }
  }

  String _getAvatarPath() {
    if (_avatarIndex != null && _avatarIndex! >= 0 && _avatarIndex! < 5) {
      return 'assets/avatars/avatar${_avatarIndex! + 1}.png';
    }
    return 'assets/avatars/avatar1.png';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_getAvatarPath()),
                ),
                SizedBox(height: 16),
                Text(
                  _kullaniciAdi,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
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
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.edit, color: Color(0xFF6A88E5)),
                  title: Text(
                    'Profili Düzenle',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: _profilDuzenle,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.notifications_outlined,
                      color: Color(0xFF6A88E5)),
                  title: Text(
                    'Bildirim Ayarları',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BildirimAyarlari(
                          kullaniciId: widget.kullaniciId,
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.language, color: Color(0xFF6A88E5)),
                  title: Text(
                    'Dil Seçenekleri',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DilSecenekleri(
                          kullaniciId: widget.kullaniciId,
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Color(0xFF6A88E5)),
                  title: Text(
                    'Yardım ve Destek',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YardimVeDestek(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Color(0xFF6A88E5)),
                  title: Text(
                    'Hakkında',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HakkindaSayfasi(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined,
                      color: Color(0xFF6A88E5)),
                  title: Text(
                    'Gizlilik Politikası',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GizlilikPolitikasiSayfasi(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  onTap: _cikisYap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
