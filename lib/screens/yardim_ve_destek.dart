import 'package:flutter/material.dart';

class YardimVeDestek extends StatelessWidget {
  const YardimVeDestek({Key? key}) : super(key: key);

  Widget _buildSSSItem({
    required String soru,
    required String cevap,
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
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(16),
        childrenPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF6A88E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.help_outline,
            color: Color(0xFF6A88E5),
          ),
        ),
        title: Text(
          soru,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Text(
            cevap,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIletisimButonu({
    required String baslik,
    required String aciklama,
    required IconData icon,
    required VoidCallback onTap,
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
          baslik,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            aciklama,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
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
          'Yardım ve Destek',
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
                'Sıkça Sorulan Sorular',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A88E5),
                ),
              ),
              SizedBox(height: 16),
              _buildSSSItem(
                soru: 'Sigarayı bırakmanın faydaları nelerdir?',
                cevap:
                    'Sigarayı bırakmak sağlığınızı iyileştirir, nefes almanızı kolaylaştırır, enerji seviyenizi artırır ve kalp hastalığı riskini azaltır. Ayrıca önemli miktarda para tasarrufu yapmanızı sağlar.',
              ),
              _buildSSSItem(
                soru: 'Sigara içme isteği ile nasıl başa çıkabilirim?',
                cevap:
                    'Derin nefes alma egzersizleri yapın, su için, yürüyüşe çıkın veya sevdiğiniz bir aktiviteyle meşgul olun. Sigara içme dürtüsü genellikle 3-5 dakika içinde geçer.',
              ),
              _buildSSSItem(
                soru: 'Nikotin yerine koyma tedavisi nedir?',
                cevap:
                    'Nikotin yerine koyma tedavisi, nikotin bandı, sakız veya sprey gibi ürünlerle vücudunuza kontrollü miktarda nikotin sağlayarak sigarayı bırakmanıza yardımcı olan bir yöntemdir.',
              ),
              SizedBox(height: 32),
              Text(
                'İletişim',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A88E5),
                ),
              ),
              SizedBox(height: 16),
              _buildIletisimButonu(
                baslik: 'E-posta ile İletişim',
                aciklama: 'Sorularınız için bize e-posta gönderin',
                icon: Icons.email_outlined,
                onTap: () {
                  // TODO: E-posta gönderme işlemi
                },
              ),
              _buildIletisimButonu(
                baslik: 'Destek Hattı',
                aciklama: 'Uzmanlarımızla görüşün',
                icon: Icons.phone_outlined,
                onTap: () {
                  // TODO: Telefon açma işlemi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
