//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hwrs_app/constants.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hwrs_app/services/service.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  TextEditingController textController = TextEditingController();
  String audioUrl = "";

  void _requestDownload(String link) async {
    final taskId = await FlutterDownloader.enqueue(
      url: 'your download link',
      savedDir: 'the path of directory where you want to save downloaded files',
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

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
          const SizedBox(
            height: 30,
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
          Container(
            height: 100,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                if (textController.text.isEmpty) {
                  print("You need to enter a text");
                  return;
                }

                Map data = await textToSpeech(textController.text);
                print(data);
                final filename = data['filename'] as String;

                if (data['success']) {
                  var url = 'https://731e-102-176-94-129.eu.ngrok.io$filename';
                  print("========== print audio url:  $url");
                  print("============== printing fileName: $filename");
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
              child: const Text("Convert"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          /* IconButton(
            onPressed: () async {
              var testUrl =
                  "https://www.hitxgh.com/php_system/uploads/2022/07/Kwesi-Arthur-%E2%80%93-Nirvana-Ft.-Kofi-Molewww.hitxgh.com_.mp3";

              await AssetsAudioPlayer.newPlayer().open(
                Audio.network(
                  "https://49a4-102-176-94-32.eu.ngrok.io/media/audio/2022-07-24-3-18-yoDy68U.mp3",
                ),
                showNotification: true,
              );
            },
            icon: const Icon(
              Icons.audio_file,
            ),
          ), */
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.download,
        overlayColor: Colors.black,
        overlayOpacity: 0.65,
        spacing: 12,
        spaceBetweenChildren: 12,
        backgroundColor: Colors.black,
        onPress: () {
          print("button presed");
          _requestDownload(audioUrl);
        },
      ),
    );
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
