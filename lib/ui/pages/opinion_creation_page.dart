import 'package:flutter/material.dart';
import 'package:location_opinions/services/opinion_service.dart';

class OpinionCreationPage extends StatefulWidget {
  const OpinionCreationPage({super.key});

  @override
  State<OpinionCreationPage> createState() => _OpinionCreationPageState();
}

class _OpinionCreationPageState extends State<OpinionCreationPage> {

  final TextEditingController _textController = TextEditingController();


  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('"Share" Opinion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              minLines: 3,
              decoration: const InputDecoration(
                labelText: 'What say you?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75, // 50% bigger than default (default is about 48% of width)
              height: 72, // 50% bigger than default button height (default is 48)
              child: ElevatedButton(
                onPressed: () {
                  OpinionService().createOpinion(text: _textController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('"Share"', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}