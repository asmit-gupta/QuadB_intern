import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ShowDetailPage extends StatelessWidget {
  final Map<String, dynamic> show;

  const ShowDetailPage({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageOriginal = show['show']['image'] != null
        ? show['show']['image']['original']
        : null;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.network(
                    imageOriginal,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0, left: 0.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Text(
                show['show']['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (show['show']['genres'] != null)
                    ...List.generate(
                      show['show']['genres'].length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(7),
                        child: Text(
                          show['show']['genres'][index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    'Status: ${show['show']['status']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Language: ${show['show']['language']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Html(
                data: show['show']['summary'] ?? 'No summary available.',
                style: {
                  // Customize the style if needed
                  'body': Style(
                    fontSize: const FontSize(16),
                    color: Colors.white,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(children: [
                const Text(
                  'Available at: ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  show['show']['webChannel'] != null
                      ? show['show']['webChannel']['name']
                      : 'Not specified',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
