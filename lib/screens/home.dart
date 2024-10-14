import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/build_quote_container.dart';
import 'package:flutter_application_1/services/image_service.dart';
import 'package:flutter_application_1/services/quotes_services.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Uint8List imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  final QuotesService quoteService = QuotesService();
  final ImageService imageService = ImageService();

  Future<void> saveScreenshot() async {
    final image = await screenshotController.capture();
    if (image == null) return;

    final path = await imageService.saveImage(image);
    if (path != null) {
      showSuccessMessage("Image successfully saved at $path");
    } else {
      showErrorMessage("Failed to save image");
    }
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
      ),
    );
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
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
                await quoteService.fetchRandomQuotes();
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
            IconButton(
              onPressed: () async {
                saveScreenshot();
              },
              icon: const Icon(
                Icons.download,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: quoteService.fetchRandomQuotes(),
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
