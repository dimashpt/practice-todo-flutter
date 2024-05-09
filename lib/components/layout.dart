import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('MainLayout'));

  final StatefulNavigationShell navigationShell;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();

    // remove splash screen after 2 seconds, this is just a demo
    // in real app, you should remove it after your app is ready
    Future.delayed(Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _goBranch,
        currentIndex: widget.navigationShell.currentIndex,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'navbar.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'navbar.settings'.tr(),
          ),
        ],
      ),
    );
  }
}
