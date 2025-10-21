class FeatureService {
  static final FeatureService _instance = FeatureService._internal();
  factory FeatureService() => _instance;
  FeatureService._internal();

  // Map untuk menyimpan status fitur
  final Map<String, bool> _featureStatus = {
    'expert_system': true,  // Sudah tersedia
    'e_proposal': false,    // Belum tersedia
    'e_monev': false,       // Belum tersedia
    'sppd': false,          // Belum tersedia
    'cuti': false,          // Belum tersedia
    'presensi': false,      // Belum tersedia
    'pelatihan': false,     // Belum tersedia
    'pengobatan': false,    // Belum tersedia
    'nusareka': false,      // Belum tersedia
    'nusafina': false,      // Belum tersedia
  };

  /// Mengecek apakah fitur tersedia
  bool isFeatureAvailable(String featureKey) {
    return _featureStatus[featureKey] ?? false;
  }

  /// Mengupdate status fitur
  void updateFeatureStatus(String featureKey, bool isAvailable) {
    _featureStatus[featureKey] = isAvailable;
  }

  /// Mendapatkan semua status fitur
  Map<String, bool> getAllFeatureStatus() {
    return Map.from(_featureStatus);
  }

  /// Mengaktifkan fitur
  void enableFeature(String featureKey) {
    _featureStatus[featureKey] = true;
  }

  /// Menonaktifkan fitur
  void disableFeature(String featureKey) {
    _featureStatus[featureKey] = false;
  }
}
