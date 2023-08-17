import 'dart:convert';
import 'package:infinity_scroll/models/modelo_gif.dart';
import 'package:http/http.dart' as http;

class GifProvider {
  final url =
      'https://api.giphy.com/v1/gifs/trending?api_key=081Z33Gf8OaNbdK1upYCzUqPGG90MimV&limit=10&rating=g';

  Future<List<ModeloGif>> getGifs(offset) async {
    final resp = await http.get(Uri.parse('$url&offset=$offset'));

    if (resp.statusCode == 200) {
      String body = utf8.decode(resp.bodyBytes);
      final jsonList = jsonDecode(body);
      final gifs = Gifs.fromJsonList(jsonList);
      return gifs.items;
    } else {
      throw Exception(' Ocurrio Algo ${resp.statusCode}');
    }
  }
}
