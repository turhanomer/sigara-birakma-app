import 'package:flutter/material.dart';
import '../db_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DBHelper dbHelper = DBHelper();
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    // Burada, mevcut giriş yapan kullanıcıyı göstereceğiz.
    // Bu örnekte kullanıcıyı sabit bir e-posta ve şifre ile alıyoruz.
    final user = await dbHelper.getUser('user@example.com', 'password123');

    if (user != null) {
      setState(() {
        username = user['username'];
        email = user['email'];
      });
    } else {
      setState(() {
        username = 'Kullanıcı bulunamadı';
        email = 'E-posta bulunamadı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kullanıcı Adı: $username',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'E-posta: $email',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
