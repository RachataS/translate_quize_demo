import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';
import 'package:translate_quize/Thai_translate.dart';
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
  var save_engtxt, save_thtxt;
  var raw;
  final rawtxt = TextEditingController();
  List<String> similar_word = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translate"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.translate_sharp),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: thai_translate(), type: PageTransitionType.fade));
          },
        ),
      ),
      body: Card(
        key: formKey,
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 200),
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
              controller: rawtxt,
              onChanged: (rawtxt) async {
                if (rawtxt == "") {
                  translated = "คำแปล";
                } else {
                  try {
                    formKey.currentState?.save();
                    await translator
                        .translate(rawtxt, from: 'en', to: 'th')
                        .then((transaltion) {
                      setState(() {
                        translated = transaltion.toString();
                        //similar_word.add(transaltion.toString());
                      });
                    });
                  } catch (e) {
                    print(e);
                  }
                }
              },
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
          try {
            save_thtxt = translated;
            save_engtxt = rawtxt.text;
            print(save_engtxt);
            print(save_thtxt);
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.save_alt_outlined),
      ),
    );
  }
}
