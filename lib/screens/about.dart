import 'package:flutter/material.dart';
import 'package:hwrs_app/constants.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        children: const [
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text("Welcome"),
            subtitle: Text(
              "We give you the best way and convenient way to scan, translate and convert your text to audio the easiest way.",
            ),
          ),
          ListTile(
            title: Text("Scan Text"),
            subtitle: Text(
              "Scan your handwritten document to digital form the easiest way. upload your file, or take a picture and upload to scan text from your document.",
            ),
          ),
          ListTile(
            title: Text("Translate Text"),
            subtitle: Text(
              "Wondering how you can communicate with someone who doesn't understand your language? Translate your English text to different languages the easiest way.",
            ),
          ),
          ListTile(
            title: Text("Text to Speech"),
            subtitle: Text(
              "Do you feel lazy to read something? Let us read your notes, articles, and many more text for you.",
            ),
          )
        ],
      ),
    );
  }
}
