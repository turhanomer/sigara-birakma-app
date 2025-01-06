import 'package:flutter/material.dart';
import '../veritabani.dart';

class BildirimAyarlari extends StatefulWidget {
  final int kullaniciId;

  const BildirimAyarlari({Key? key, required this.kullaniciId})
      : super(key: key);

  @override
  _BildirimAyarlariState createState() => _BildirimAyarlariState();
}

class _BildirimAyarlariState extends State<BildirimAyarlari> {
  bool _gunlukHatirlatma = true;
  bool _basarimBildirimleri = true;
  bool _motivasyonMesajlari = true;
  bool _istatistikGuncellemeleri = true;
  final Veritabani _veritabani = Veritabani();

  @override
  void initState() {
    super.initState();
    _bildirimleriYukle();
  }

  Future<void> _bildirimleriYukle() async {
    // TODO: Veritabanından bildirim ayarlarını yükle
  }

  Future<void> _bildirimAyarlariniKaydet() async {
    // TODO: Veritabanına bildirim ayarlarını kaydet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bildirim ayarları kaydedildi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildBildirimSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
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
            color: Color(0xFF6A88E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xFF6A88E5),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF6A88E5),
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
          'Bildirim Ayarları',
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
            children: [
              _buildBildirimSwitch(
                title: 'Günlük Hatırlatmalar',
                subtitle: 'Her gün motivasyon mesajları ve hatırlatmalar al',
                value: _gunlukHatirlatma,
                onChanged: (value) {
                  setState(() => _gunlukHatirlatma = value);
                },
                icon: Icons.notifications_active,
              ),
              _buildBildirimSwitch(
                title: 'Başarım Bildirimleri',
                subtitle: 'Yeni bir başarım kazandığında bildirim al',
                value: _basarimBildirimleri,
                onChanged: (value) {
                  setState(() => _basarimBildirimleri = value);
                },
                icon: Icons.emoji_events,
              ),
              _buildBildirimSwitch(
                title: 'Motivasyon Mesajları',
                subtitle: 'Düzenli motivasyon mesajları al',
                value: _motivasyonMesajlari,
                onChanged: (value) {
                  setState(() => _motivasyonMesajlari = value);
                },
                icon: Icons.favorite,
              ),
              _buildBildirimSwitch(
                title: 'İstatistik Güncellemeleri',
                subtitle: 'Önemli istatistik değişikliklerinde bildirim al',
                value: _istatistikGuncellemeleri,
                onChanged: (value) {
                  setState(() => _istatistikGuncellemeleri = value);
                },
                icon: Icons.bar_chart,
              ),
              SizedBox(height: 24),
              Container(
                height: 55,
                width: double.infinity,
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
                    onPressed: _bildirimAyarlariniKaydet,
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
            ],
          ),
        ),
      ),
    );
  }
}
