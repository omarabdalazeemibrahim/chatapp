import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function (File pickedImage) imagePickFn;

   UserImagePicker( this.imagePickFn) ;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  final ImagePicker _picker = ImagePicker();
  late File _pickedImage  = File("");


  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.pickImage(source: src);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage);
    } else {
      print("No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.greenAccent,
          backgroundImage:
               FileImage(_pickedImage) ,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.camera_alt_outlined),
              label: Text(
                "Add Image \n from Camera",textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.image_outlined),
                label: Text(
                  "Add Image \n from Gallery",textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ))
          ],
        )
      ],
    );
  }
}
