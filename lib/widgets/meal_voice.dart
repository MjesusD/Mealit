import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:mealit/entity/meal_model.dart';

class MealVoice extends StatefulWidget {
  final Meal meal;
  final VoidCallback? onClose;

  const MealVoice({super.key, required this.meal, this.onClose});

  @override
  State<MealVoice> createState() => _MealVoiceState();
}

class _MealVoiceState extends State<MealVoice> {
  final FlutterTts flutterTts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();
  bool _isSpeaking = false;
  bool _translated = false;
  String? _translatedInstructions;
  List<String>? _translatedIngredients;

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() => _isSpeaking = false);
  }

  Future<void> _speak(String langCode, {bool translated = false}) async {
    if (_isSpeaking) {
      await _stop();
      return;
    }
    setState(() => _isSpeaking = true);

    String textToSpeak;

    if (translated && _translatedIngredients != null && _translatedInstructions != null) {
      textToSpeak = 'Ingredientes: ${_translatedIngredients!.join(', ')}. '
          'Instrucciones: $_translatedInstructions';
    } else {
      final ingredientsText = widget.meal.ingredients.where((ing) => ing.trim().isNotEmpty).join(', ');
      textToSpeak = 'Ingredients: $ingredientsText. Instructions: ${widget.meal.instructions}';
    }

    await flutterTts.setLanguage(langCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(textToSpeak);

    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _translateAndSpeakAll() async {
    if (_isSpeaking) {
      await _stop();
      return;
    }

    setState(() => _isSpeaking = true);

    final translatedInstructions = await translator.translate(widget.meal.instructions, to: 'es');
    final translatedIngredients = <String>[];

    for (var ing in widget.meal.ingredients) {
      if (ing.trim().isEmpty) continue;
      final tIng = await translator.translate(ing, to: 'es');
      translatedIngredients.add(tIng.text);
    }

    setState(() {
      _translated = true;
      _translatedInstructions = translatedInstructions.text;
      _translatedIngredients = translatedIngredients;
    });

    final fullText = 'Ingredientes: ${translatedIngredients.join(', ')}. '
        'Instrucciones: ${translatedInstructions.text}';

    await flutterTts.setLanguage('es-ES');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(fullText);

    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    if (widget.onClose != null) widget.onClose!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    final ingredientsToShow =
        _translated && _translatedIngredients != null ? _translatedIngredients! : meal.ingredients;
    final instructionsToShow =
        _translated && _translatedInstructions != null ? _translatedInstructions! : meal.instructions;

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
          ...ingredientsToShow.map((e) => Text('• $e')),
          const SizedBox(height: 12),
          const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(instructionsToShow),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                label: Text(_isSpeaking ? 'Detener' : 'Leer en inglés'),
                onPressed: () => _speak('en-US'),
              ),
              ElevatedButton.icon(
                icon: Icon(_isSpeaking ? Icons.stop : Icons.translate),
                label: Text(_isSpeaking ? 'Detener' : 'Traducir y leer todo'),
                onPressed: _translateAndSpeakAll,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
