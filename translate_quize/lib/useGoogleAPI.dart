import 'package:http/http.dart' as http;
import 'dart:convert';

void translateText() async {
  String originalText = 'dog';
  String targetLanguage = 'th';

  String apiKey = 'YOUR_API_KEY'; // Replace with your actual API key

  String apiUrl =
      'https://translation.googleapis.com/language/translate/v2?key=$apiKey&q=$originalText&source=en&target=$targetLanguage';

  var response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    String translatedText = data['data']['translations'][0]['translatedText'];
    List<String> synonyms = data['data']['translations'][0]
            ['alternativeTranslations'][0]['words']
        .cast<String>();

    print(translatedText); // Output: สุนัข
    print(
        synonyms); // Output: [หมา, ปอมเมอร์เรนย์, สัตว์เลี้ยง, สัตว์น้อย, ลูกสุนัข]
  } else {
    print('Translation failed with status code: ${response.statusCode}');
  }
}
