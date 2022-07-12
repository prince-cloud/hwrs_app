import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hwrs_app/constants.dart';
import 'package:hwrs_app/services/service.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  TextEditingController textController = TextEditingController();
  String audioUrl = "";

  AudioPlayer player = AudioPlayer();

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
                audioUrl =
                    "http://172.20.10.2:8000/media/audio/2022-07-12-0-58-MdvqROk.mp3";

                /* if (textController.text.isEmpty) {
                  print("You need to enter a text");
                  return;
                }

                Map data = await textToSpeech(textController.text);
                print(data);
                final filename = data['filename'] as String;

                if (data['success']) {
                  //audioUrl = data['filename'];
                  audioUrl =
                      "http://172.20.10.2:8000/media/audio/2022-07-12-0-58-MdvqROk.mp3";

                  print("========== print audio url:  $audioUrl");
                  print("============== printing file name: $filename");

                  var url = 'http://172.20.10.2:8000$audioUrl';
                  await player.play(UrlSource(url));
                } else {
                  print("Server returned error");
                } */
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
        ],
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
