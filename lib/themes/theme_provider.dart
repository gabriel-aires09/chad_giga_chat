import 'package:chad_giga_chat/themes/dark_mode.dart';
import 'package:chad_giga_chat/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  // valor booleano para verificar se o tema e dark ou nao
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // modificar os temas por meio de condicionais 
  void toggleTheme(){
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode; 
    }
  }

}