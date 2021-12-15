import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatefulWidget {

  final void Function (File pickedImage) imagePickFn;

  const ImagePreview({Key? key,required this.imagePickFn}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  File? _pickedImage;

  void pickingImage() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: _pickedImage !=null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: pickingImage,
          label: Text("Upload"),
          icon: Icon(Icons.image),
        ),
      ],
    );;
  }
}
