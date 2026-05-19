enum AppEnvironment { dev, prod }

class AppConfig {
  AppConfig._();

  static AppEnvironment _environment = AppEnvironment.dev;

  static AppEnvironment get environment => _environment;

  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  static bool get isDev => _environment == AppEnvironment.dev;
  static bool get isProd => _environment == AppEnvironment.prod;

  static String get appName =>
      isDev ? 'HungryHub Dev' : 'HungryHub';

  static String get baseUrl => isDev
      ? 'https://dev-api.hungryhub.com'
      : 'https://api.hungryhub.com';
}