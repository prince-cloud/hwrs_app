import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hwrs_app/constants.dart';
import 'package:hwrs_app/global.dart';
import 'package:hwrs_app/services/service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ConvertText extends StatefulWidget {
  const ConvertText({Key? key}) : super(key: key);

  @override
  State<ConvertText> createState() => _ConvertTextState();
}

class _ConvertTextState extends State<ConvertText> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController docText = TextEditingController();
  String error = "";
  bool isLoading = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        //leading: const Text(""),
        title: const Text(
          "Scan Text",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          imageXFile == null
              ? Column(
                  children: [
                    Image.asset("assets/images/ocr.jpg"),
                    InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Click to Upload Image",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
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
                  ],
                ),
          if (imageXFile != null)
            Container(
              height: 100,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  if (isLoading) {
                    return;
                  }
                  setState(
                    () {
                      isLoading = true;
                    },
                  );
                  if (imageXFile == null) {
                    return;
                  } else {
                    final Map response = await upload_file(
                      imageXFile!.path.toString(),
                    );
                    setState(
                      () {
                        docText.text = response['docText'];
                        isLoading = false;
                      },
                    );
                  }
                  setState(
                    () {},
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Scan"),
              ),
            ),
          if (docText.text.isNotEmpty)
            Card(
              elevation: 7,
              child: TextFormInput(
                child: TextFormField(
                  controller: docText,
                  minLines: 2,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    label: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Scanned Text",
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.ios_share_outlined,
        overlayColor: Colors.black,
        overlayOpacity: 0.65,
        spacing: 12,
        spaceBetweenChildren: 12,
        backgroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.picture_as_pdf,
              size: 17,
            ),
            label: 'Export .pdf',
            onTap: () {
              if (docText.text == '') return;
              _createPDF(docText.text);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createPDF(String text) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    page.graphics.drawString(
      text,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        18,
      ),
    );
    List<int> bytes = await document.save();
    document.dispose();

    saveAndLauchFile(bytes, 'output.pdf');
  }
}

class TextFormInput extends StatelessWidget {
  final Widget child;

  const TextFormInput({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: size.width * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
