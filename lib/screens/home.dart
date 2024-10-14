import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/build_quote_container.dart';
import 'package:flutter_application_1/models/quotes.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Uint8List imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  Future<Quote> fetchQuotes() async {
    final response =
        await http.get(Uri.parse("https://zenquotes.io/api/random"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return Quote.fromJson(data[0]);
    } else {
      throw Exception("Failed to fetch joke");
    }
  }

  Future<String?> saveImage(Uint8List bytes) async {
    // Request storage permission
    await [Permission.storage].request();

    // Generate a unique name for the image
    String name = "quotes${DateTime.now().millisecondsSinceEpoch}";

    // Save the image
    AssetEntity? result =
        await PhotoManager.editor.saveImage(bytes, filename: name);

    // Check if the result is not null and return the file path
    if (result != null) {
      // Retrieve the file path of the saved image
      final file = await result.file;
      return file?.path; // Return the file path
    } else {
      return null; // Return null if saving failed
    }
  }

  final GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Quotify"),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  fetchQuotes();
                });
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
            IconButton(
              onPressed: () async {
                final image = await screenshotController.capture();
                if (image == null) return;
                await saveImage(image);
              },
              icon: const Icon(
                Icons.download,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: fetchQuotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Screenshot(
                  controller: screenshotController,
                  child: BuildQuotesWrapper(quote: snapshot.data!),
                )),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
