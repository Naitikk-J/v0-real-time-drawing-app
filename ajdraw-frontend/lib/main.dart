import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/connect_screen.dart';
import 'theme/style.dart';
import 'controllers/draw_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawController()),
      ],
      child: MaterialApp(
        title: 'AJdraw',
        theme: AppTheme.lightTheme,
        home: const ConnectScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
