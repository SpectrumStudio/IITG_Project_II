import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_demo/viewModel/homePageViewModel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaquopy/chaquopy.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform= const MethodChannel("com.flutter.epic/epic");

  Future<File> cropImage(var image)async{
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path, cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop My Sample',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    GallerySaver.saveImage(croppedFile.path);
    //print(croppedFile.path);
    //result["textOutputOrError"]
    //final Directory directory = await getApplicationDocumentsDirectory();
    //print(directory.path);
    //final File file = File('${directory.path}/path.txt');
    //await file.writeAsString(croppedFile.path);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Path', croppedFile.path.toString());
    //print("Path written!");
    //print(file);
    return croppedFile;
  }

  Future<File> getImageFromSource(ImageSource source, bool toCrop)async{
    var image = await ImagePicker().getImage(source: source);
    if(image==null)
      return null;
    if(toCrop){
      var croppedImage = await cropImage(File(image.path));
      return croppedImage;
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    return File(image.path);
  }

  void Printy() async{
    String value;
    try{
      print("Java Function Printy called");
      value=await platform.invokeMethod("Printy");
    }
    catch(e)
    {
      print(e);
    }
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Picker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<HomePageViewModel>(
          create: (context) => HomePageViewModel(),
          child: Consumer<HomePageViewModel>(
            builder: (context,viewModel,child){
              return Center(
                child: Column(
                  children: [

                    const SizedBox(height: 30,),

                    if(viewModel.image==null)
                      Icon(Icons.camera,size: 100),
                    if(viewModel.image!=null)
                    //Image.file(viewModel.image),

                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: ClipOval(
                              child: Image.file(

                                  viewModel.image,
                                  fit: BoxFit.fill
                              ),

                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30,),
                    CheckboxListTile(
                      title: Text('Crop after picked',style: TextStyle(color: Colors.indigo,fontSize: 18),),

                      value: viewModel.cropAfterPicked,
                      onChanged: (value){
                        viewModel.setCropAfterPicker(value);
                      },
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        var image = await getImageFromSource(ImageSource.gallery, viewModel.cropAfterPicked);
                        if(image==null)
                          return;
                        viewModel.setImage(image);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellowAccent,
                          textStyle: TextStyle(fontSize: 18)
                      ),
                      child: Text('Get sample from gallery',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        var image = await getImageFromSource(ImageSource.camera, viewModel.cropAfterPicked);
                        if(image==null)
                          return;
                        viewModel.setImage(image);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellowAccent,
                          textStyle: TextStyle(fontSize: 18)
                      ),
                      child: Text('Get sample from camera',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        if(viewModel.image==null)
                          return;
                        var image = await cropImage(viewModel.image);
                        if(image==null)
                          return;
                        viewModel.setImage(image);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellowAccent,
                          textStyle: TextStyle(fontSize: 18,)
                      ),
                      child: Text('Crop sample',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async{
                        print("Debug:");
                        Printy();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellowAccent,
                          textStyle: TextStyle(fontSize: 18,)
                      ),
                      child: Text('Analyze',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}





