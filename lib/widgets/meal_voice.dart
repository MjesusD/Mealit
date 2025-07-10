import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:mealit/entity/meal_model.dart';

class MealVoice extends StatefulWidget {
  final Meal meal;

  const MealVoice({super.key, required this.meal});

  @override
  State<MealVoice> createState() => _MealVoiceState();
}

class _MealVoiceState extends State<MealVoice> {
  final FlutterTts flutterTts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();
  bool _isSpeaking = false;
  bool _translated = false;
  String? _translatedText;

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() => _isSpeaking = false);
  }

  Future<void> _speak(String text, String langCode) async {
    if (_isSpeaking) {
      await _stop();
      return;
    }
    setState(() => _isSpeaking = true);
    await flutterTts.setLanguage(langCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _translateAndSpeak(String text) async {
    if (_isSpeaking) {
      await _stop();
      return;
    }
    setState(() => _isSpeaking = true);
    final translation = await translator.translate(text, to: 'es');
    setState(() {
      _translatedText = translation.text;
      _translated = true;
    });
    await flutterTts.setLanguage('es-ES');
    await flutterTts.speak(_translatedText!);
    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(meal.imageUrl),
          ),
          const SizedBox(height: 12),
          const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...meal.ingredients.map((e) => Text('• $e')),
          const SizedBox(height: 12),
          const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_translated ? _translatedText ?? meal.instructions : meal.instructions),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                label: Text(_isSpeaking ? 'Detener' : 'Leer en inglés'),
                onPressed: () => _speak(meal.instructions, 'en-US'),
              ),
              ElevatedButton.icon(
                icon: Icon(_isSpeaking ? Icons.stop : Icons.translate),
                label: Text(_isSpeaking ? 'Detener' : 'Traducir y leer'),
                onPressed: () => _translateAndSpeak(meal.instructions),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
