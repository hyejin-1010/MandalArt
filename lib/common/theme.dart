class CommonTheme {
  static double baseSize = 14.0;

  static void setBaseSize(double newBaseSize) {
    baseSize = newBaseSize;
  }

  static double get xxSmall { return baseSize - 6.0; }
  static double get xSmall { return baseSize - 4.0; }
  static double get small { return baseSize - 2.0; }
  static double get medium { return baseSize; }
  static double get large { return baseSize + 2.0; }
}