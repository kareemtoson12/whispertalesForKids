import 'package:flutter/material.dart';
import 'dart:math';
import 'package:gp/features/login/loginView.dart';
import 'package:gp/features/DisplayStory/displayStory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateStoryView extends StatefulWidget {
  @override
  State<CreateStoryView> createState() => _CreateStoryViewState();
}

class _CreateStoryViewState extends State<CreateStoryView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _promptController = TextEditingController();

  // Add selectedType state
  int? _selectedTypeIndex;
  // Add selectedNarrator state
  int? _selectedNarratorIndex;
  // Add selectedLength state
  int? _selectedLengthIndex;

  // Common container decoration
  BoxDecoration get _containerDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
    ),
  );

  // Helper to map type index to genre string
  String? get _selectedGenre {
    switch (_selectedTypeIndex) {
      case 0:
        return 'superhero';
      case 1:
        return 'action';
      case 2:
        return 'drama';
      case 3:
        return 'thriller';
      case 4:
        return 'horror';
      case 5:
        return 'sci_fi';
      default:
        return null;
    }
  }

  // Helper to map length index to target length
  int get _targetLength {
    switch (_selectedLengthIndex) {
      case 0: // Short
        return 150;
      case 1: // Medium
        return 350;
      case 2: // Long
        return 500;
      default:
        return 100; // Default to medium
    }
  }

  // Static story content
  String get _staticStory {
    return '''One sunny morning, Luna the curious bunny found a glowing path behind her burrow. She hopped along and entered the Magical Forest, where trees whispered, flowers sang, and fireflies sparkled like stars.

Suddenly, she met a wise owl named Oliver. "The forest is losing its magic," he hooted. "Only someone kind and brave can save it."

Luna agreed to help. She followed the singing river, crossed the giggling bridge, and reached the Crystal Tree. A sad fairy sat there, her wings dull.

"I lost the Laughing Leaf," the fairy sighed. Luna searched high and low until she found the shiny leaf hiding in a squirrel's nest.

When she gave it back, the forest lit up with colors and joy returned.

"Thank you, Luna," Oliver said. "You're our hero!"

Luna smiled and hopped home, her heart glowing like the path she had found.''';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _promptController.dispose();
    super.dispose();
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
              child: CustomPaint(
                painter: MagicalBackgroundPainter(
                  animation: _controller,
                  cloudPositions: List.generate(
                    10,
                    (index) => Offset(
                      Random().nextDouble() * MediaQuery.of(context).size.width,
                      Random().nextDouble() *
                          MediaQuery.of(context).size.height,
                    ),
                  ),
                  cloudRadii: List.generate(
                    10,
                    (index) => Random().nextDouble() * 30 + 20,
                  ),
                  sparklePositions: List.generate(
                    20,
                    (index) => Offset(
                      Random().nextDouble() * MediaQuery.of(context).size.width,
                      Random().nextDouble() *
                          MediaQuery.of(context).size.height,
                    ),
                  ),
                  sparkleRadii: List.generate(
                    20,
                    (index) => Random().nextDouble() * 3 + 1,
                  ),
                ),
              ),
            ),
            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Story Type Selection
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: _containerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose Your Story Type',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    _StoryTypeButton(
                                      icon: Icons.auto_awesome,
                                      label: 'Superhero',
                                      color: Colors.red,
                                      selected: _selectedTypeIndex == 0,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 0,
                                          ),
                                    ),
                                    _StoryTypeButton(
                                      icon: Icons.flash_on,
                                      label: 'Action',
                                      color: Colors.orange,
                                      selected: _selectedTypeIndex == 1,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 1,
                                          ),
                                    ),
                                    _StoryTypeButton(
                                      icon: Icons.theater_comedy,
                                      label: 'Drama',
                                      color: Colors.purple,
                                      selected: _selectedTypeIndex == 2,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 2,
                                          ),
                                    ),
                                    _StoryTypeButton(
                                      icon: Icons.psychology,
                                      label: 'Thriller',
                                      color: Colors.blue,
                                      selected: _selectedTypeIndex == 3,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 3,
                                          ),
                                    ),
                                    _StoryTypeButton(
                                      icon: Icons.warning_rounded,
                                      label: 'Horror',
                                      color: Colors.grey[800]!,
                                      selected: _selectedTypeIndex == 4,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 4,
                                          ),
                                    ),
                                    _StoryTypeButton(
                                      icon: Icons.auto_awesome,
                                      label: 'Sci-Fi',
                                      color: Colors.purpleAccent,
                                      selected: _selectedTypeIndex == 5,
                                      onTap:
                                          () => setState(
                                            () => _selectedTypeIndex = 5,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Story Length Selection
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: _containerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose Your Story Length',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    _StoryLengthButton(
                                      label: 'Short',
                                      selected: _selectedLengthIndex == 0,
                                      onTap:
                                          () => setState(
                                            () => _selectedLengthIndex = 0,
                                          ),
                                    ),
                                    _StoryLengthButton(
                                      label: 'Medium',
                                      selected: _selectedLengthIndex == 1,
                                      onTap:
                                          () => setState(
                                            () => _selectedLengthIndex = 1,
                                          ),
                                    ),
                                    _StoryLengthButton(
                                      label: 'Long',
                                      selected: _selectedLengthIndex == 2,
                                      onTap:
                                          () => setState(
                                            () => _selectedLengthIndex = 2,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Narrator Selection
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: _containerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who Will Tell Your Story?',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _NarratorButton(
                                      icon: Icons.face_retouching_natural,
                                      label: 'Alice',
                                      color: Colors.orange[200]!,
                                      selected: _selectedNarratorIndex == 0,
                                      onTap:
                                          () => setState(
                                            () => _selectedNarratorIndex = 0,
                                          ),
                                    ),
                                    _NarratorButton(
                                      icon: Icons.face,
                                      label: 'Ben',
                                      color: Colors.blue[200]!,
                                      selected: _selectedNarratorIndex == 1,
                                      onTap:
                                          () => setState(
                                            () => _selectedNarratorIndex = 1,
                                          ),
                                    ),
                                    _NarratorButton(
                                      icon: Icons.face_retouching_natural,
                                      label: 'Clara',
                                      color: Colors.purple[200]!,
                                      selected: _selectedNarratorIndex == 2,
                                      onTap:
                                          () => setState(
                                            () => _selectedNarratorIndex = 2,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Story Prompt Input
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: _containerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    Text(
                                      'What should your story be about?',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _promptController,
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Tell me what your story should be about...\n(Leave empty for a magical surprise!)',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 15,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.purple),
                            label: Text(
                              'Back',
                              style: TextStyle(color: Colors.purple),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.purple),
                              shape: StadiumBorder(),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_selectedGenre == null ||
                                  _selectedLengthIndex == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select a story type and length.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );

                              try {
                                const String apiUrl =
                                    'https://7fa8-35-233-184-217.ngrok-free.app/generate';
                                final Uri uri = Uri.parse(apiUrl);

                                final requestBody = {
                                  'genre': _selectedGenre,
                                  'prompt': _promptController.text,
                                  'target_length': _targetLength,
                                  'max_length': 500,
                                };

                                final response = await http.post(
                                  uri,
                                  headers: {'Content-Type': 'application/json'},
                                  body: json.encode(requestBody),
                                );

                                if (!mounted) return;
                                Navigator.of(
                                  context,
                                ).pop(); // Dismiss the progress indicator

                                if (response.statusCode == 200) {
                                  final responseData = json.decode(
                                    response.body,
                                  );
                                  final String generatedStory =
                                      responseData['generated_text'];

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DisplayStory(
                                            story: generatedStory,
                                          ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to generate story: ${response.body}',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (!mounted) return;
                                Navigator.of(
                                  context,
                                ).pop(); // Dismiss the progress indicator
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('An error occurred: $e'),
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.auto_stories, color: Colors.white),
                            label: const Text('Make My Story!'),
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
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
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

class _StoryTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool selected;

  const _StoryTypeButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.35) : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: selected ? 4 : 2),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NarratorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool selected;

  const _NarratorButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                  border: Border.all(
                    color:
                        selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    width: 4,
                  ),
                  boxShadow:
                      selected
                          ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                child: CircleAvatar(
                  backgroundColor: color.withOpacity(0.3),
                  radius: 32,
                  child: Icon(icon, size: 32, color: color),
                ),
              ),
              if (selected)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(3),
                    child: Icon(Icons.check, color: Colors.white, size: 18),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryPromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _StoryPromptChip({required this.label, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryLengthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const _StoryLengthButton({
    required this.label,
    this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  // Helper to get color based on label
  Color get _buttonColor {
    switch (label.toLowerCase()) {
      case 'short':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'long':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              selected
                  ? _buttonColor.withOpacity(0.35)
                  : _buttonColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _buttonColor, width: selected ? 4 : 2),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: _buttonColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: _buttonColor,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: _buttonColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Add this extension for color darkening
extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
