// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:inka_challenge/shared_preferences/shared_global.dart';

class EventIdProvider extends ChangeNotifier {
  
  void setIdEvento(String id) {
     SharedPrefencesGlobal().saveIDEvento(id);//Guardamos en Shared Preferences 
    eventoPref = id;
    notifyListeners();
  }

  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  
  // STRING DE CACHE PREFERENCES
  String eventoPref = '';

   Future<void> caragrIdEvento() async {
    final eventoCache = await sharedPrefs.getIDEvento();
     eventoPref = eventoCache!;
     notifyListeners();
  }

}