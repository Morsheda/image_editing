import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
//import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  getImageFile(ImageSource source) async {
    //Clicking or picking image
    var image = await picker.getImage(source: source);
    //Cropping image
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
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    setState(() {_image=File(croppedFile.path);});
  }

  Future<void> getimageditor() async {
    final geteditimage =   Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return ImageEditorPro(
            appBarColor: Colors.blue,
            bottomBarColor: Colors.blue,
          );
        }
    )).then((geteditimage){
      if(geteditimage != null){
        setState(() {_image=geteditimage;});
      }
    }).catchError((er){print(er);});

  }
                    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _image == null
        ? Text("No Image Selected")
        : Image.file(_image, height: 200, width: 200),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 2,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => getImageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          ),
          SizedBox(
            width: 2,
          ),
          FloatingActionButton.extended(
            label: Text("Edit"),
            onPressed: () async => getimageditor(),
            heroTag: UniqueKey(),
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}


