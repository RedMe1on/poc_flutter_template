// Брейкпоинты для адаптивного дизайна
class Breakpoints {
  // Мобильные устройства
  static const double mobile = 600;
  
  // Планшеты
  static const double tablet = 900;
  
  // Десктопы
  static const double desktop = 1200;
}

// Утилиты для определения типа устройства
class ResponsiveUtils {
  static bool isMobile(double width) => width < Breakpoints.mobile;
  static bool isTablet(double width) => 
      width >= Breakpoints.mobile && width < Breakpoints.desktop;
  static bool isDesktop(double width) => width >= Breakpoints.desktop;
  
  // Количество колонок в сетке
  static int gridColumns(double width) {
    if (isMobile(width)) return 2;
    if (isTablet(width)) return 3;
    return 4;
  }
  
  // Отступы
  static double padding(double width) {
    if (isMobile(width)) return 16;
    if (isTablet(width)) return 24;
    return 32;
  }
}