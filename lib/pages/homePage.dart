import 'dart:ffi';
import 'dart:io';
import 'dart:core';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:image_picker_demo/pages/list_view_history.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_demo/viewModel/homePageViewModel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'login.dart';
import 'mlPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel("com.flutter.epic/epic");
  String RGBI = "";
  var RGBIlist;
  var forOpti;
  var optiR, optiG, optiB;
  var R, G, B, I;
  var data;
  late Color color;
  String Temp = "";

  Future<File> cropImage(var image) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop My Sample',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    //GallerySaver.saveImage(croppedFile.path);
    //print(croppedFile.path);
    //result["textOutputOrError"]
    //final Directory directory = await getApplicationDocumentsDirectory();
    //print(directory.path);
    //final File file = File('${directory.path}/path.txt');
    //await file.writeAsString(croppedFile.path);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Path', croppedFile!.path.toString());
    //print("Path written!");
    //print(file);
    Temp = await Printy();
    forOpti = Temp.split(" ");
    optiR = double.parse(forOpti[0]);
    optiR = optiR.toInt();
    optiG = double.parse(forOpti[1]);
    optiG = optiG.toInt();
    optiB = double.parse(forOpti[2]);
    optiB = optiB.toInt();
    color = Color.fromARGB(255, optiR, optiG, optiB);
    print(optiR.toString());
    //print("Inside cropImage, Temp is =" + Temp);
    return croppedFile;
  }

  Future<File> getImageFromSource(ImageSource source, bool toCrop) async {
    var image = await ImagePicker().getImage(source: source);
    //if(image==null)
    //  return null;
    if (toCrop) {
      var croppedImage = await cropImage(File(image!.path));
      //Printy();
      return croppedImage;
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    return File(image!.path);
  }

  Future<String> Printy() async {
    String value;
    try {
      print("Java Function Printy called");
      value = await platform.invokeMethod("Printy");
      RGBI = value;
      RGBIlist = RGBI.split(" ");
      print("Red Value:" + RGBIlist[0]);
      R = RGBIlist[0];
      print("Green Value:" + RGBIlist[1]);
      G = RGBIlist[1];
      print("Blue Value:" + RGBIlist[2]);
      B = RGBIlist[2];
      print("Intensity Value:" + RGBIlist[3]);
      I = RGBIlist[3];
      // Fluttertoast.showToast(
      //     msg: "R:$R, G:$G, B:$B, I:$I",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } catch (e) {
      print(e);
    }
    return RGBI;
  }

  Widget buildColorPicker() => SlidePicker(
        pickerColor: color,
        enableAlpha: false,
        showLabel: true,
        //palleteType:PaletteType.hsv,
        onColorChanged: (color) => setState(() => this.color = color),
      );

  void pickColor(BuildContext buildContext) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Color optimizer"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            buildColorPicker(),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Text(
                  "Select",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  optiR = color.red;
                  optiG = color.green;
                  optiB = color.blue;
                  R = color.red.toString();
                  G = color.green.toString();
                  B = color.blue.toString();
                  Navigator.of(context).pop();
                })
          ])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //left: 20,
          //right: 20,
          left: 130,
          top: Get.height * 0.17,
          child: Container(
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/flask.png'),
                //fit: BoxFit.fill,
              ),
              //shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 24.0,
                spreadRadius: 16.0,
                color: Colors.black.withOpacity(0.2))
          ]),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white.withOpacity(0.3),
                    )),
                child: ChangeNotifierProvider<HomePageViewModel>(
                  create: (context) => HomePageViewModel(),
                  child: Consumer<HomePageViewModel>(
                    builder: (context, viewModel, child) {
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            if (viewModel.image == null)
                              FaIcon(
                                FontAwesomeIcons.cameraRetro,
                                size: 150,
                                color: Color.fromARGB(150, 0, 32, 63),
                              ),
                            if (viewModel.image != null)
                              //Image.file(viewModel.image),

                              // Column(

                              //   children[],: Padding(
                              //     //padding: const EdgeInsets.only(left: 20, right: 20),
                              //     padding: const EdgeInsets.all(16.0),
                              //     child: ClipOval(
                              //       child: Image.file(
                              //         viewModel.image,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Center(
                                child: CircleAvatar(
                                  radius: 105,
                                  backgroundColor: Colors.blueAccent,
                                  child: CircleAvatar(
                                    radius: 100,
                                    foregroundImage: Image.file(
                                      viewModel.image,
                                    ).image,
                                    //child: Image.file(viewModel.image),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                            // CheckboxListTile(
                            //   title: Text(
                            //     'Crop after picked',
                            //     style: TextStyle(color: Colors.indigo, fontSize: 18),
                            //   ),
                            //   value: viewModel.cropAfterPicked,
                            //   onChanged: (value) {
                            //     viewModel.setCropAfterPicker(value!);
                            //   },
                            // ),
                            SizedBox(
                              height: 40,
                              width: 300,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  var image = await getImageFromSource(
                                      ImageSource.gallery,
                                      viewModel.cropAfterPicked);
                                  if (image == null) return;
                                  viewModel.setImage(image);
                                  print(Temp);
                                },
                                child: Text(
                                  'Get sample from Gallery',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              height: 40,
                              width: 300,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  var image = await getImageFromSource(
                                      ImageSource.camera,
                                      viewModel.cropAfterPicked);
                                  if (image == null) return;
                                  viewModel.setImage(image);
                                },
                                child: Text(
                                  'Get sample from Camera',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              height: 40,
                              width: 300,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (viewModel.image == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.white,
                                        duration: const Duration(seconds: 2),
                                        content: Text(
                                          "Please select an Image",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }
                                  var image = await cropImage(viewModel.image);
                                  if (image == null) return;
                                  viewModel.setImage(image);
                                },
                                child: Text(
                                  'Crop sample',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (viewModel.image != null)
                              FlatButton(
                                onPressed: () {
                                  color =
                                      Color.fromARGB(255, optiR, optiG, optiB);
                                  print("color is:" + color.toString());
                                  pickColor(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (viewModel.image != null)
                              new Text(
                                "Tap the circle to optimise the RGB values.",
                                style: TextStyle(fontSize: 17),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 40,
                              width: 180,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  print("Debug:");
                                  if (R == null || G == null || B == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.white,
                                        duration: const Duration(seconds: 2),
                                        content: Text(
                                          "No Image selected",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MlPage(
                                              red: R,
                                              green: G,
                                              blue: B,
                                              intensity: I)),
                                    );
                                    //addData();
                                  }
                                  //print("RGBI:"+RGBISuccess.toString());
                                  //SharedPreferences prefs = await SharedPreferences.getInstance();
                                  //var RGBI = (prefs.getString('RGBI')??'');
                                },
                                child: Text(
                                  'Analyze',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 40,
                              width: 180,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListViewHistory(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'History',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
