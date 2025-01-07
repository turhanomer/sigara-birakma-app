import 'package:flutter/material.dart';

class GizlilikPolitikasiSayfasi extends StatelessWidget {
  const GizlilikPolitikasiSayfasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Gizlilik Politikası',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF6A88E5)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildCard(
                title: 'Veri Toplama ve Kullanım',
                icon: Icons.data_usage,
                content:
                    'Uygulamamız, size daha iyi bir sigara bırakma deneyimi sunmak için aşağıdaki verileri toplar ve kullanır:\n\n'
                    '• Bırakış tarihiniz\n'
                    '• Günlük içilen sigara sayısı\n'
                    '• Sigara paket fiyatı\n'
                    '• Paketteki sigara sayısı\n'
                    '• Kullanıcı hesap bilgileri',
              ),
              _buildCard(
                title: 'Veri Güvenliği',
                icon: Icons.security,
                content:
                    'Verileriniz yerel olarak cihazınızda güvenli bir şekilde saklanır. '
                    'Kişisel verileriniz üçüncü taraflarla paylaşılmaz veya satılmaz.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            leading: Container(
              padding: EdgeInsets.all(8),
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            childrenPadding: EdgeInsets.all(16),
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
