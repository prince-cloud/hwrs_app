import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hwrs_app/constants.dart';
import 'package:image_picker/image_picker.dart';

class ConvertText extends StatefulWidget {
  const ConvertText({Key? key}) : super(key: key);

  @override
  State<ConvertText> createState() => _ConvertTextState();
}

class _ConvertTextState extends State<ConvertText> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Upload Image"),
          children: [
            SimpleDialogOption(
              child: const Text("Take Photo"),
              onPressed: () => captureImageWithCamera(),
            ),
            SimpleDialogOption(
              child: const Text("Upload Photo"),
              onPressed: () => pickImageFromGallery(),
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      //maxHeight: 720,
      //maxWidth: 1280,
    );

    setState(
      () {
        imageXFile;
      },
    );
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      //maxHeight: 720,
      //maxWidth: 1280,
    );

    setState(
      () {
        imageXFile;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //selectImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        //leading: const Text(""),
        title: const Text(
          "Convert Text",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          imageXFile == null
              ? InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.camera_alt,
                          size: 200,
                          color: Colors.black54,
                        ),
                        Text(
                          "Upload an Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            File(imageXFile!.path),
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Form(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
