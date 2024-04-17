import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Rewriter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextRewriter(),
    );
  }
}

class TextRewriter extends StatefulWidget {
  @override
  _TextRewriterState createState() => _TextRewriterState();
}

class _TextRewriterState extends State<TextRewriter> {
  TextEditingController _textController = TextEditingController();
  String _rewrittenText = '';

  Future<void> _rewriteText(String text) async {
    String apiKey =
        'gAAAAABmID7J93Bj4tROiUTFeSsht3B5mtk-sg6o0K7tJiADAvEjpdFcHrDVnuRBvizHsdu2aQa-n0J7E5oCR62BQZ2zUapqJG9ScEx7x5L0NVQn6lUdlTKa3srGtnJp0_2KEfNNQhim';
    String endpoint = 'https://api.textcortex.com/v1/texts/rewritings';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    String model = 'chat-sophos-1';
    double temperature = 0.65;
    int maxTokens = 2048;
    String data = json.encode({
      'text': text,
      'model': model,
      'temperature': temperature,
      'max_tokens': maxTokens,
      'formality': 'default',
      'mode': 'voice_passive',
    });

    try {
      var response =
          await http.post(Uri.parse(endpoint), headers: headers, body: data);
          print("fuck you" + data);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          List<dynamic> outputs = responseBody['data']['outputs'];
          if (outputs.isNotEmpty) {
            setState(() {
              _rewrittenText = outputs[0]['text'].toString();
            });
            return;
          }
        }
        print('Failed to rewrite text: No outputs found');
      } else {
        print('Failed to rewrite text: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Rewriter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _rewriteText(_textController.text);
              },
              child: Text('Rewrite Text'),
            ),
            SizedBox(height: 20),
            Text(
              _rewrittenText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
