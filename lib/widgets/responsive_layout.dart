import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

// Виджет для адаптивного макета
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });
  
  // Статические методы для проверки типа устройства
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < Breakpoints.mobile;
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.desktop;
  }
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= Breakpoints.desktop;
  
  // Получить текущий тип устройства
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) return ScreenType.mobile;
    if (width < Breakpoints.desktop) return ScreenType.tablet;
    return ScreenType.desktop;
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= Breakpoints.mobile) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}

// Типы экранов
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

// Расширение для BuildContext
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);
  ScreenType get screenType => ResponsiveLayout.getScreenType(this);
  
  // Адаптивные значения
  double get responsivePadding {
    if (isMobile) return 16;
    if (isTablet) return 24;
    return 32;
  }
  
  int get gridColumns {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }
}