import 'package:translator/translator.dart';

class Translate {
  GoogleTranslator translator = GoogleTranslator();
  String translated = "";
  translation(rawtxt, inputLanguage, outputLanguage) {
    translator
        .translate(rawtxt, from: inputLanguage, to: outputLanguage)
        .then((transaltion) {
      translated = transaltion.toString();
    });
    return translated;
  }
}
