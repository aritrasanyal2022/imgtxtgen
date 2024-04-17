import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  String _prompt = ""; // To store user prompt
  String _generatedText = ""; // To store generated text
  bool _isLoading = false; // Flag for loading indicator

  // Replace with your actual API key
  final String _apiKey = "AIzaSyDoJ9XXLMOFVlH0DC82t50sMKUDZhgHUeQ";

  // Function to call the API and generate text
  Future<void> _generateText() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
      final content = [Content.text(_prompt)];

      final response = await model.generateContent(content);
      print(response.text);
      setState(() {
        _isLoading = false;

        _generatedText = response.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Text Overlay App'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Form for user input
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your prompt:',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a prompt';
                    }
                    return null;
                  },
                  onSaved: (value) => _prompt = value!,
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _generateText,
                child: Text('Generate Text'),
              ),
              SizedBox(height: 10.0),

              // Display generated text and image overlay (conditionally)
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        // Local image (adjust path as needed)
                        Image.asset('assets/white.jpg'),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                _generatedText,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
