// lib/config/environment.dart
enum EnvType { dev, staging, prod }

class Environment {
  static EnvType current = EnvType.dev;

  static String get apiBaseUrl {
    switch (current) {
      case EnvType.dev:
        return "http://10.0.2.2:3000/api";
      case EnvType.staging:
        return "http://34.41.169.143:3000/api";
      case EnvType.prod:
        return "https://miapp.com/api";
    }
  }

  static String get appName {
    switch (current) {
      case EnvType.dev:
        return "MiApp (DEV)";
      case EnvType.staging:
        return "MiApp (STAGING)";
      case EnvType.prod:
        return "MiApp";
    }
  }
}
