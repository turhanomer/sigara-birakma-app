import 'package:flutter/material.dart';
import 'screens/giris_sayfasi.dart';
import 'screens/kayit_ol.dart';
import 'screens/anasayfa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/giris',
      routes: {
        '/giris': (context) => GirisSayfasi(),
        '/kayit': (context) => KayitOlSayfasi(),
        '/anasayfa': (context) => Anasayfa(),
      },
    );
  }
}
