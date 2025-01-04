import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/giris_sayfasi.dart';
import 'screens/kayit_ol.dart';
import 'screens/anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sigara Bırakma',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'),
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFF6A88E5),
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: Color(0xFF6A88E5).withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
        ),
      ),
      initialRoute: '/giris',
      routes: {
        '/giris': (context) => GirisSayfasi(),
        '/kayit': (context) => KayitOlSayfasi(),
        '/anasayfa': (context) => Anasayfa(),
      },
    );
  }
}
