class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://192.168.1.173:8080/api',
  );
  static const timeout = Duration(seconds: 30);
}


