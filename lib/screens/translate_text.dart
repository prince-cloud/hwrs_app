import 'package:flutter/material.dart';
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
  String dropdownvalue = 'Spanish';
  bool isLoading = false;

  String translatedText = "";
  String translatedTo = "";

  var translate_to = [
    'Spanish',
    'French',
  ];

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
                    items: translate_to.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          dropdownvalue = newValue!;
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
                if (isLoading) {
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
                    'translate_to': 'es',
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
