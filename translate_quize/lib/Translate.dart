import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:translate_quize/savetext.dart';
import 'package:translator/translator.dart';

class translate_screen extends StatefulWidget {
  const translate_screen({super.key});

  @override
  State<translate_screen> createState() => _translate_screenState();
}

class _translate_screenState extends State<translate_screen> {
  final formKey = GlobalKey<FormState>();
  GoogleTranslator translator = GoogleTranslator();
  String translated = "คำแปล";
  var raw;
  Save_Eng save = Save_Eng();
  final rawtxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translate"),
        centerTitle: true,
      ),
      body: Card(
        key: formKey,
        margin: const EdgeInsets.all(12),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("English (US)"),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: "Enter Text",
              ),
              onSaved: (var text) {
                //save.engtxt = text;
              },
              controller: rawtxt,
            ),
            const Divider(
              height: 32,
            ),
            Text(
              translated,
              style: const TextStyle(
                  fontSize: 28,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          formKey.currentState?.save();
          print(save.engtxt);
          print(rawtxt.text);
          translator
              .translate(rawtxt.text, from: 'en', to: 'th')
              .then((transaltion) {
            setState(() {
              translated = transaltion.toString();
            });
          });
          print("translated = $translated");
        },
        child: Icon(Icons.g_translate),
      ),
    );
  }
}
