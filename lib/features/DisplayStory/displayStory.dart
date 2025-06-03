import 'package:flutter/material.dart';
import 'dart:math';
import 'package:gp/core/commanWidgets/magical_background_painter.dart';
import 'package:gp/core/services/tts_service.dart';

class DisplayStory extends StatefulWidget {
  const DisplayStory({Key? key}) : super(key: key);

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

  final String _storyText =
      'Once upon a time, in a magical forest filled with wonder, there lived a small kitten named Luna. Luna wasn\'t an ordinary kitten - she had sparkling blue fur and tiny stars that twinkled in her whiskers!\n\nEvery morning, Luna would wake up to the sound of singing birds and dancing butterflies. She would stretch her tiny paws and yawn, showing her pearly white teeth. Then, she would embark on another magical adventure through the enchanted forest.\n\nOne day, Luna discovered a hidden path that led to a secret garden where flowers could talk and trees could dance. The garden was home to many magical creatures who became Luna\'s friends...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _ttsService = TTSService();
    _initializeAnimationData();
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

                          const SizedBox(height: 8),
                          Text(
                            'The Magical Forest Adventure',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=800&h=600&fit=crop',
                              height: 400,
                              width: 300,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  height: 120,
                                  width: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 120,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.pinkAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Telling your story as the Magical Cat!',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                const Text(
                                  'Once upon a time, in a magical forest filled with wonder, there lived a small kitten named Luna. Luna wasn\'t an ordinary kitten - she had sparkling blue fur and tiny stars that twinkled in her whiskers!\n\nEvery morning, Luna would wake up to the sound of singing birds and dancing butterflies. She would stretch her tiny paws and yawn, showing her pearly white teeth. Then, she would embark on another magical adventure through the enchanted forest.\n\nOne day, Luna discovered a hidden path that led to a secret garden where flowers could talk and trees could dance. The garden was home to many magical creatures who became Luna\'s friends...',
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
                              Navigator.pushNamed(context, '/magical-quiz');
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
