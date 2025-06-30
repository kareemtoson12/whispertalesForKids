import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp/core/commanWidgets/magical_background_painter.dart';
import 'package:gp/core/services/tts_service.dart';
import 'package:gp/features/questions/qs.dart';

class DisplayStory extends StatefulWidget {
  final String story;
  const DisplayStory({Key? key, required this.story}) : super(key: key);

  @override
  State<DisplayStory> createState() => _DisplayStoryState();
}

class _DisplayStoryState extends State<DisplayStory>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _cloudPositions;
  late List<double> _cloudRadii;
  late List<Offset> _sparklePositions;
  late List<double> _sparkleRadii;
  late TTSService _ttsService;
  bool _isPlaying = false;
  late String _storyText;
  Uint8List? _imageBytes;
  bool _isImageLoading = true;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _ttsService = TTSService();
    _initializeAnimationData();
    _storyText = widget.story;
    _generateImage();
  }

  Future<void> _generateImage() async {
    setState(() {
      _isImageLoading = true;
      _imageError = false;
    });

    try {
      const String apiUrl =
          'https://8b02-34-169-123-8.ngrok-free.app/generate-image';
      final Uri uri = Uri.parse(apiUrl);

      final requestBody = {
        'prompt': widget.story,
        'width': 1024,
        'height': 768,
        'steps': 4,
        'return_format': 'image',
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode(requestBody),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
          _isImageLoading = false;
        });
      } else {
        setState(() {
          _imageError = true;
          _isImageLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _imageError = true;
        _isImageLoading = false;
      });
    }
  }

  void _initializeAnimationData() {
    final random = Random();
    _cloudPositions = List.generate(10, (index) => Offset.zero);
    _cloudRadii = List.generate(10, (index) => random.nextDouble() * 30 + 20);
    _sparklePositions = List.generate(20, (index) => Offset.zero);
    _sparkleRadii = List.generate(20, (index) => random.nextDouble() * 3 + 1);
  }

  void _updatePositions(Size size) {
    final random = Random();
    if (_cloudPositions.first == Offset.zero) {
      _cloudPositions = List.generate(
        10,
        (index) => Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
      );
      _sparklePositions = List.generate(
        20,
        (index) => Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _toggleStoryPlayback() async {
    if (_isPlaying) {
      await _ttsService.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _ttsService.speak(_storyText);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyLines = _storyText.trim().split('\n');
    final storyTitle =
        storyLines.isNotEmpty && storyLines.first.isNotEmpty
            ? storyLines.first
            : 'Your Magical Story';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Magical Background
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _updatePositions(constraints.biggest);
                  return CustomPaint(
                    painter: MagicalBackgroundPainter(
                      animation: _controller,
                      cloudPositions: _cloudPositions,
                      cloudRadii: _cloudRadii,
                      sparklePositions: _sparklePositions,
                      sparkleRadii: _sparkleRadii,
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),

                          // Story Image
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child:
                                  _isImageLoading
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : _imageError || _imageBytes == null
                                      ? const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                      )
                                      : Image.memory(
                                        _imageBytes!,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 8),

                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _toggleStoryPlayback,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.pinkAccent,
                                    Colors.purpleAccent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pinkAccent.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  _storyText,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          MagicalQuizScreen(story: _storyText),
                                ),
                              );
                            },
                            icon: Icon(Icons.quiz, color: Colors.white),
                            label: Text('Take the Magical Quiz!'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB5D8),
                              foregroundColor: Colors.white,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              elevation: 4,
                              shadowColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
