import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        
        // Try all possible combinations
        if (androidInfo.brand.isNotEmpty && androidInfo.model.isNotEmpty) {
          return '${androidInfo.brand.toUpperCase()} ${androidInfo.model}';
        }
        if (androidInfo.manufacturer.isNotEmpty && androidInfo.model.isNotEmpty) {
          return '${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model}';
        }
        if (androidInfo.product.isNotEmpty) {
          return androidInfo.product.toUpperCase();
        }
        if (androidInfo.device.isNotEmpty) {
          return androidInfo.device.toUpperCase();
        }
        if (androidInfo.brand.isNotEmpty) {
          return androidInfo.brand.toUpperCase();
        }
        if (androidInfo.manufacturer.isNotEmpty) {
          return androidInfo.manufacturer.toUpperCase();
        }
        
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        
        if (iosInfo.name.isNotEmpty) {
          return '${iosInfo.name} (${iosInfo.model})';
        }
        if (iosInfo.model.isNotEmpty) {
          return 'iPhone ${iosInfo.model}';
        }
        
        return 'iOS ${iosInfo.systemVersion}';
      }
      
      return 'Desktop Device';
    } catch (e) {
      if (kDebugMode) {
        print('Device info error: $e');
      }
      // Always return something specific, never generic
      if (Platform.isAndroid) {
        return 'Android Error';
      } else if (Platform.isIOS) {
        return 'iPhone Error';
      } else {
        return 'Desktop Error';
      }
    }
  }
  
  static Future<String> getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.model;
      } else {
        return 'Unknown Model';
      }
    } catch (e) {
      return 'Unknown Model';
    }
  }
  
  static Future<String> getBrand() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.brand;
      } else if (Platform.isIOS) {
        return 'Apple';
      } else {
        return 'Unknown Brand';
      }
    } catch (e) {
      return 'Unknown Brand';
    }
  }
  
  static Future<String> getOSVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      } else {
        return 'Unknown OS';
      }
    } catch (e) {
      return 'Unknown OS';
    }
  }
  
  static Future<Map<String, String>> getFullDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'deviceName': '${androidInfo.brand.toUpperCase()} ${androidInfo.model}',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'osVersion': 'Android ${androidInfo.version.release}',
          'manufacturer': androidInfo.manufacturer,
          'sdkInt': androidInfo.version.sdkInt.toString(),
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'deviceName': '${iosInfo.name} (${iosInfo.model})',
          'model': iosInfo.model,
          'brand': 'Apple',
          'osVersion': 'iOS ${iosInfo.systemVersion}',
          'systemName': iosInfo.systemName,
          'identifierForVendor': iosInfo.identifierForVendor ?? 'Unknown',
        };
      } else {
        return {
          'deviceName': 'Desktop Device',
          'model': 'Desktop Model',
          'brand': 'Desktop Brand',
          'osVersion': 'Desktop OS',
        };
      }
    } catch (e) {
      return {
        'deviceName': Platform.isAndroid ? 'Android Device' : Platform.isIOS ? 'iOS Device' : 'Mobile Device',
        'model': 'Unknown Model',
        'brand': Platform.isAndroid ? 'Android' : Platform.isIOS ? 'Apple' : 'Unknown',
        'osVersion': Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : 'Unknown',
      };
    }
  }
  
  // Alternative method with timeout
  static Future<String> getDeviceNameWithTimeout() async {
    try {
      return await Future.any([
        getDeviceName(),
        Future.delayed(const Duration(seconds: 3), () => 'Timeout Device'),
      ]);
    } catch (e) {
      return Platform.isAndroid ? 'Android Timeout' : Platform.isIOS ? 'iPhone Timeout' : 'Desktop Timeout';
    }
  }
  
  // Simple fallback method for testing
  static Future<String> getSimpleDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        
        if (kDebugMode) {
          print('=== SIMPLE DEVICE DETECTION ===');
          print('Brand: "${androidInfo.brand}"');
          print('Model: "${androidInfo.model}"');
          print('Manufacturer: "${androidInfo.manufacturer}"');
          print('Product: "${androidInfo.product}"');
          print('Device: "${androidInfo.device}"');
        }
        
        // Try different combinations - prioritize most specific
        if (androidInfo.brand.isNotEmpty && androidInfo.model.isNotEmpty) {
          final name = '${androidInfo.brand.toUpperCase()} ${androidInfo.model}';
          if (kDebugMode) print('Simple selected: $name');
          return name;
        } else if (androidInfo.manufacturer.isNotEmpty && androidInfo.model.isNotEmpty) {
          final name = '${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model}';
          if (kDebugMode) print('Simple selected: $name');
          return name;
        } else if (androidInfo.product.isNotEmpty) {
          final name = androidInfo.product.toUpperCase();
          if (kDebugMode) print('Simple selected: $name');
          return name;
        } else if (androidInfo.device.isNotEmpty) {
          final name = androidInfo.device.toUpperCase();
          if (kDebugMode) print('Simple selected: $name');
          return name;
        } else if (androidInfo.brand.isNotEmpty) {
          final name = androidInfo.brand.toUpperCase();
          if (kDebugMode) print('Simple selected: $name');
          return name;
        } else if (androidInfo.manufacturer.isNotEmpty) {
          final name = androidInfo.manufacturer.toUpperCase();
          if (kDebugMode) print('Simple selected: $name');
          return name;
        }
        
        // Last resort - return Android version
        final name = 'Android ${androidInfo.version.release}';
        if (kDebugMode) print('Simple selected: $name');
        return name;
        
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        
        if (iosInfo.name.isNotEmpty) {
          final name = '${iosInfo.name} (${iosInfo.model})';
          if (kDebugMode) print('Simple selected: $name');
          return name;
        }
        if (iosInfo.model.isNotEmpty) {
          final name = 'iPhone ${iosInfo.model}';
          if (kDebugMode) print('Simple selected: $name');
          return name;
        }
        
        final name = 'iOS ${iosInfo.systemVersion}';
        if (kDebugMode) print('Simple selected: $name');
        return name;
      }
      return 'Desktop Device';
    } catch (e) {
      if (kDebugMode) {
        print('Simple device info error: $e');
      }
      // Even in error, try to return something specific
      return Platform.isAndroid ? 'Android Simple Error' : Platform.isIOS ? 'iPhone Simple Error' : 'Desktop Simple Error';
    }
  }
  
  // Aggressive method to get device name with all possible fields
  static Future<String> getDetailedDeviceName() async {
    try {
      if (kDebugMode) {
        print('=== STARTING DEVICE DETECTION ===');
        print('Platform: ${Platform.operatingSystem}');
      }
      
      if (Platform.isAndroid) {
        if (kDebugMode) print('Getting Android info...');
        final androidInfo = await _deviceInfo.androidInfo;
        
        // Debug information
        if (kDebugMode) {
          print('=== ANDROID DEVICE INFO ===');
          print('Brand: "${androidInfo.brand}"');
          print('Model: "${androidInfo.model}"');
          print('Manufacturer: "${androidInfo.manufacturer}"');
          print('Product: "${androidInfo.product}"');
          print('Device: "${androidInfo.device}"');
          print('Board: "${androidInfo.board}"');
          print('Hardware: "${androidInfo.hardware}"');
          print('Version: "${androidInfo.version.release}"');
          print('========================');
        }
        
        // Check if all fields are empty
        bool allEmpty = androidInfo.brand.isEmpty && 
                       androidInfo.model.isEmpty && 
                       androidInfo.manufacturer.isEmpty && 
                       androidInfo.product.isEmpty && 
                       androidInfo.device.isEmpty && 
                       androidInfo.board.isEmpty && 
                       androidInfo.hardware.isEmpty;
        
        if (allEmpty) {
          if (kDebugMode) print('All Android fields are empty!');
          return 'Android Empty Fields';
        }
        
        // Direct return without fallback - try all combinations
        if (androidInfo.brand.isNotEmpty && androidInfo.model.isNotEmpty) {
          final name = '${androidInfo.brand.toUpperCase()} ${androidInfo.model}';
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.manufacturer.isNotEmpty && androidInfo.model.isNotEmpty) {
          final name = '${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model}';
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.product.isNotEmpty) {
          final name = androidInfo.product.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.device.isNotEmpty) {
          final name = androidInfo.device.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.board.isNotEmpty) {
          final name = androidInfo.board.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.hardware.isNotEmpty) {
          final name = androidInfo.hardware.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.brand.isNotEmpty) {
          final name = androidInfo.brand.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (androidInfo.manufacturer.isNotEmpty) {
          final name = androidInfo.manufacturer.toUpperCase();
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        // Last resort - return Android version
        final name = 'Android ${androidInfo.version.release}';
        if (kDebugMode) print('Selected: $name');
        return name;
        
      } else if (Platform.isIOS) {
        if (kDebugMode) print('Getting iOS info...');
        final iosInfo = await _deviceInfo.iosInfo;
        
        if (kDebugMode) {
          print('=== iOS DEVICE INFO ===');
          print('Name: "${iosInfo.name}"');
          print('Model: "${iosInfo.model}"');
          print('SystemName: "${iosInfo.systemName}"');
          print('====================');
        }
        
        if (iosInfo.name.isNotEmpty) {
          final name = '${iosInfo.name} (${iosInfo.model})';
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        if (iosInfo.model.isNotEmpty) {
          final name = 'iPhone ${iosInfo.model}';
          if (kDebugMode) print('Selected: $name');
          return name;
        }
        
        final name = 'iOS ${iosInfo.systemVersion}';
        if (kDebugMode) print('Selected: $name');
        return name;
      }
      
      return 'Desktop Device';
    } catch (e) {
      if (kDebugMode) {
        print('=== DEVICE DETECTION ERROR ===');
        print('Error: $e');
        print('Error Type: ${e.runtimeType}');
        print('Stack Trace: ${StackTrace.current}');
        print('==============================');
      }
      // Even in error, try to return something specific
      return Platform.isAndroid ? 'Android Detailed Error' : Platform.isIOS ? 'iPhone Detailed Error' : 'Desktop Detailed Error';
    }
  }
}
