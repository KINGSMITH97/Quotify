import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quotes.dart';

class BuildQuotesWrapper extends StatelessWidget {
  const BuildQuotesWrapper({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote.quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text("~${quote.author}"),
          ],
        ),
      ),
    );
  }
}
