import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:translator/translator.dart';
import 'dart:convert';

import 'Thai_translate.dart';

class translate_screen extends StatefulWidget {
  const translate_screen({super.key});

  @override
  State<translate_screen> createState() => _translate_screenState();
}

class _translate_screenState extends State<translate_screen> {
  final formKey = GlobalKey<FormState>();
  GoogleTranslator translator = GoogleTranslator();
  String label = "English (US)";
  String translated = "คำแปล";
  var save_engtxt, save_thtxt, raw;
  String inlang = "en";
  String outlang = "th";
  final rawtxt = TextEditingController();
  var synonyms = [];

  Future<void> getSynonyms(String word) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.datamuse.com/words?rel_syn=$word&max=10'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List wordSynonyms = jsonData.map((item) => item['word']).toList();
        setState(() {
          synonyms = wordSynonyms;
        });
        print(synonyms);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getSynonyms(String word) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://dict.longdo.com/mobile.php?search=$word'),
  //     );
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = jsonDecode(response.body);
  //       final List wordSynonyms = jsonData.map((item) => item['word']).toList();
  //       setState(() {
  //         synonyms = wordSynonyms;
  //       });
  //       print(synonyms);
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translate"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.translate_sharp),
          onPressed: () {
            /*if (inlang == "en") {
              inlang = "th";
              outlang = "en";
              label = "English (US)";
              print(label);
            } else {
              if (inlang == "th") {
                inlang = "en";
                outlang = "th";
                label = "ไทย (TH)";
                print(label);
              }
            }*/
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
            Text(label),
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
                        .translate(rawtxt, from: inlang, to: outlang)
                        .then((transaltion) {
                      setState(() {
                        translated = transaltion.toString();
                        getSynonyms(rawtxt);
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
              '$translated\n$synonyms',
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
