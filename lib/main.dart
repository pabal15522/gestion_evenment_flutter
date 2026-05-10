import 'package:flutter/material.dart';
import 'package:gestion_evement/widget/EventWidget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
Future<void> main() async {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Gestion évènement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Eventwidget(),
    );
  }
}
