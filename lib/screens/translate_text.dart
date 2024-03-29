import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hwrs_app/constants.dart';
import 'package:hwrs_app/services/service.dart';

class TranslateText extends StatefulWidget {
  const TranslateText({Key? key}) : super(key: key);

  @override
  State<TranslateText> createState() => _TranslateTextState();
}

class _TranslateTextState extends State<TranslateText> {
  TextEditingController textController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();
  TextEditingController translateToController = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'Twi';
  bool isLoading = false;

  String translatedText = "";
  String translatedTo = "";

  /* var translate_to = [
    'Twi',
    'Hausa',
    'Spanish',
    'French',
    'Germen',
  ]; */

  var translate_to = {
    'Twi': 'tw',
    'Hausa': 'ha',
    'Spanish': 'es',
    'French': 'fr',
    'Germen': 'de',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          "Translate Text",
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
              "assets/images/texTranslate.png",
              height: 250,
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
                      /* onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              }, */
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
                const Text("Transate to: "),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: translate_to.keys.map<DropdownMenuItem>((key) {
                      return DropdownMenuItem(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (dynamic newValue) {
                      setState(
                        () {
                          dropdownvalue = newValue as String;
                          translateToController.text = newValue;
                        },
                      );
                    },
                  ),
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
                if (dropdownvalue.isEmpty) {
                  return;
                }

                if (!translate_to.containsKey(dropdownvalue)) {
                  return;
                }
                setState(
                  () {
                    isLoading = true;
                  },
                );
                final results = await translateText(
                  {
                    'text': textController.text.toString(),
                    'translate_to': translate_to[dropdownvalue],
                  },
                );
                setState(
                  () {
                    translatedText = results['translation'];
                    translatedTextController.text = results['translation'];
                    translateToController.text = results['translated_to'];
                    translatedTo = results['translated_to'];
                    isLoading = false;
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Translate"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (translatedTo.isNotEmpty)
            Card(
              elevation: 7,
              child: TextFormInput(
                child: TextFormField(
                  controller: translatedTextController,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text(
                      "Translation to $translatedTo",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
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
