import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  final String url;

  Network(this.url);

  Future<dynamic> getJsonData() async {
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String jsonData = response.body;
        var parsedJson = jsonDecode(jsonData);
        print('description:::' + parsedJson);
        return parsedJson;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('There\'s a problem with json parsing');
    }
  }
}
