import 'package:chalege_accept/controllers/home_controller.dart';
import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:chalege_accept/view/auth_page.dart';
import 'package:chalege_accept/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart'; // Adicione este import no topo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA9EMBUHChhtbQqJ5XI0sizLCVwjkBYChE',
      appId: '1:331147349131:android:92ead2342672d0699dd88e',
      messagingSenderId: '331147349131',
      projectId: 'chalege-accept',
      storageBucket: 'chalege-accept.appspot.com',
    ),
  );
  setupLocators();
  runApp(MyApp());
}

//Injeção de Dependencias
void setupLocators() {
  GetIt.I.registerSingleton<HomeController>(HomeController());
  GetIt.I.registerSingleton<ProductController>(ProductController());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Definindo as cores principais da panificadora
    const Color primaryBrown = Color(0xFF6D4C41); // Brown 600
    const Color accentOrange = Color(0xFFE65100); // Orange 900
    const Color backgroundScaffold =
        Color(0xFFF9F6F4); // Um bege bem claro e limpo

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrown,
          primary: primaryBrown,
          secondary: accentOrange,
          surface: backgroundScaffold,
          background: backgroundScaffold,
        ),
        useMaterial3: true,
        // Aplicando a tipografia moderna em todo o app
        textTheme:
            GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme).copyWith(
          titleLarge: GoogleFonts.nunito(
              fontWeight: FontWeight.w800, color: primaryBrown),
          headlineSmall: GoogleFonts.nunito(
              fontWeight: FontWeight.w800, color: primaryBrown),
        ),
        // Estilizando os Cards de forma global
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: Colors.brown.withOpacity(0.1), width: 1),
          ),
          color: Colors.white,
        ),
        // Estilizando a AppBar de forma global
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        // Estilizando os botões de forma global
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return HomePage();
          }
          return const AuthPage();
        },
      ),
    );
  }
}
