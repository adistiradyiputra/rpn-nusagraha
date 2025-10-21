class ApiConstants {
  // static const String baseUrl = 'https://expertsystem-test.rpn.co.id';
  static const String baseUrl = 'https://expertsystem.rpn.co.id';
  static const String apiKey = 'peneliti-api-key-2024';
  
  // Auth endpoints
  static const String loginEndpoint = '/API/Login/auth';
  static const String logoutEndpoint = '/API/Login/logout';
  
  // Activity endpoints
  static const String getKotaDanNegaraEndpoint = '/API/Aktivitas/getKotaDanNegara';
  static const String postAktivitasEndpoint = '/API/Aktivitas/postAktivitas';
  static const String updateAktivitasEndpoint = '/API/Aktivitas/updateAktivitas';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'X-API-KEY': apiKey,
  };
}
