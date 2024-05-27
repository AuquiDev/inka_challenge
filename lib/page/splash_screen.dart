
// ignore_for_file: library_private_types_in_public_api

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:inka_challenge/login_page.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({Key? key}) : super(key: key);

  @override
  _SplahScreenState createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  bool _showHomePage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showHomePage = true;
      });
    });
    
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginPage()),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: gradientBackground(),
              ),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: Image.asset(
                    'assets/img/logo_small.png',
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: Image.asset(
                    'assets/img/logo_smallar.png',
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showHomePage ? 1.0 : 0.0,
                  duration: const Duration(seconds: 4),
                  child: const LoginPage(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

BoxDecoration gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF171717), // Negro con un toque de gris
          Color(0xFF232323), // Gris oscuro
          Color(0xFF222222), // Gris más oscuro
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }