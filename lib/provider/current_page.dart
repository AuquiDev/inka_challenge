


// import 'package:inka_challenge/initalpage.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/page/page_table_dashoard.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const TablaParticipacion();


  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 

}