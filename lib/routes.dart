import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/materi_page.dart';
import 'pages/latihan_page.dart';
import 'pages/kuis_page.dart';


final Map<String, Widget Function(BuildContext)> _routes = {
  '/': (c) => const HomePage(),
  '/materi': (c) => const MateriPage(),
  '/contoh': (c) => const LatihanPage(),
  '/quiz': (c) => const KuisPage(),

};

Route<dynamic>? appRouteGenerator(RouteSettings settings) {
  final builder = _routes[settings.name];
  if (builder == null) return null;
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade + slide up transition
      final tween =
          Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero);
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}
