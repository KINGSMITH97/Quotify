import 'dart:convert';
import 'package:flutter_application_1/models/quotes.dart';
import 'package:http/http.dart' as http;

class QuotesService {
  static const String baseUrl = "https://zenquotes.io/api";

  Future<Quote> fetchRandomQuotes() async {
    final response = await http.get(Uri.parse("$baseUrl/random"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Quote.fromJson(data[0]);
    } else {
      throw Exception("Failed to fetch quote: ${response.statusCode}");
    }
  }
}
