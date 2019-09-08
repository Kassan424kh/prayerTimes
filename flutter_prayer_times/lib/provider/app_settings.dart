import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/app_settings.dart';

class AppSettingsProvider with ChangeNotifier{
  Future<Map<String, dynamic>> get _appSettings async => await AppSettings.jsonFromAppSettingsFile;
  Future<Map<String, dynamic>> get _defaultSettings async =>  await AppSettings.jsonFromDefaultAppSettingsFile;
  Future<Map<String, dynamic>> get _settings  async => await _appSettings != null? await _appSettings: await _defaultSettings;

  Map<String, dynamic> _setSettings;

  AppSettingsProvider() {
    _settings.then((s) async => _setSettings = await s);
  }

  Future<Map<String, dynamic>> getAppSettings() async => _setSettings;
  updateAppSettings(newSettings) async {
    _setSettings.clear();
    _setSettings.addAll(newSettings);
  }
}