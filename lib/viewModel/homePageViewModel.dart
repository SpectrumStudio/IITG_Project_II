import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier{

  var image;
  bool cropAfterPicked = false;

  Future setCropAfterPicker(bool value)async{
    this.cropAfterPicked = value;
    this.notifyListeners();
  }

  Future setImage(var file)async{
    this.image = file;
    this.notifyListeners();
  }

}