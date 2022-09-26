//import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hwrs_app/constants.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hwrs_app/services/service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  TextEditingController textController = TextEditingController();
  String audioUrl = "";
  final path = getExternalStorageDirectory();
  bool isLoading = false;

  //AudioPlayer player = AudioPlayer();
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          "Text to Speech",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              "assets/images/texttospeech.jpg",
              height: 300,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Form(
            child: Column(
              children: [
                Card(
                  elevation: 7,
                  child: TextFormInput(
                    child: TextFormField(
                      controller: textController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        label: Text(
                          "Text",
                          style: TextStyle(color: Colors.black87),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          audioUrl.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    await AssetsAudioPlayer.newPlayer().open(
                      Audio.network(
                        audioUrl,
                      ),
                      //autoPlay: true,
                      showNotification: true,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await AssetsAudioPlayer.newPlayer().open(
                            Audio.network(
                              audioUrl,
                            ),
                            //autoPlay: true,
                            showNotification: true,
                          );
                        },
                        icon: const Icon(
                          Icons.volume_mute,
                        ),
                      ),
                      const Text("Play")
                    ],
                  ),
                )
              : Container(
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (textController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Text field cannot be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      if (isLoading) {
                        return;
                      }
                      setState(
                        () {
                          isLoading = true;
                        },
                      );

                      Map data = await textToSpeech(textController.text);

                      final filename = data['filename'] as String;

                      if (data['success']) {
                        setState(
                          () {
                            isLoading = false;
                          },
                        );
                        var url = '$baseUrl$filename';

                        await AssetsAudioPlayer.newPlayer().open(
                          Audio.network(
                            url,
                          ),
                          //autoPlay: true,
                          showNotification: true,
                        );

                        setState(() {
                          audioUrl = url;
                        });
                      } else {
                        print("Server returned error");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Convert"),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.download,
        overlayColor: Colors.black,
        overlayOpacity: 0.65,
        spacing: 12,
        spaceBetweenChildren: 12,
        backgroundColor: Colors.black,
        onPress: () => openFile(url: audioUrl, filename: 'file.mp3'),
      ),
    );
  }

  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);
    if (file == null) {
      Fluttertoast.showToast(
        msg: "There is no file to download",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    print("=== Path: ${file.path}");
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
      print("=== file download error");
    }
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
