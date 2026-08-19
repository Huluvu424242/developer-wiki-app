import 'package:flutter/material.dart';
import 'screens/source_form_screen.dart';

void main() => runApp(const WikiSourceApp());

class WikiSourceApp extends StatelessWidget {
  const WikiSourceApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Developer Wiki Quellen',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const SourceFormScreen());
}
