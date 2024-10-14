import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/build_quote_container.dart';
import 'package:flutter_application_1/services/image_service.dart';
import 'package:flutter_application_1/services/quotes_services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<String?> saveScreenshot() async {
    final image = await screenshotController.capture();
    if (image == null) return null;

    final path = await imageService.saveImage(image);
    if (path != null) {
      showSuccessMessage("Image successfully saved at $path");
      return path;
    } else {
      showErrorMessage("Failed to save image");
      return null;
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

  Future<void> shareScreenshot() async {
    final path = await saveScreenshot();
    if (path != null) {
      // Share the image using its file path
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Check out this awesome quote!',
      );
    } else {
      showErrorMessage("Failed to capture screenshot for sharing");
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
            IconButton(
              onPressed: () async {
                await shareScreenshot();
              },
              icon: const Icon(
                Icons.share,
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
