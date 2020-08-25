import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_demo/viewModel/homePageViewModel.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {

  Future<File> cropImage(var image)async{
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop My Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
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
    return File(image.path);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomePageViewModel>(
        create: (context) => HomePageViewModel(),
        child: Consumer<HomePageViewModel>(
          builder: (context,viewModel,child){
            return Center(
              child: Column(
                children: [
                  if(viewModel.image==null)
                    Icon(Icons.camera,size: 70),
                  if(viewModel.image!=null)
                    Image.file(viewModel.image,height: 200),
                  CheckboxListTile(
                    title: Text('Crop after picked'),
                    value: viewModel.cropAfterPicked,
                    onChanged: (value){
                      viewModel.setCropAfterPicker(value);
                    },
                  ),
                  FlatButton(
                    onPressed: ()async{
                      var image = await getImageFromSource(ImageSource.gallery, viewModel.cropAfterPicked);
                      if(image==null)
                        return;
                      viewModel.setImage(image);
                    },
                    child: Text('Get image from Gallery'),
                  ),
                  FlatButton(
                    onPressed: ()async{
                      var image = await getImageFromSource(ImageSource.camera, viewModel.cropAfterPicked);
                      if(image==null)
                        return;
                      viewModel.setImage(image);
                    },
                    child: Text('Get image from Camera'),
                  ),
                  FlatButton(
                    onPressed: () async{
                      if(viewModel.image==null)
                        return;
                      var image = await cropImage(viewModel.image);
                      if(image==null)
                        return;
                      viewModel.setImage(image);
                    },
                    child: Text('Crop Image'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
