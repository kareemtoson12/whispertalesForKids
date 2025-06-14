import 'package:flutter/material.dart';
import 'dart:math';
import 'package:gp/features/login/loginView.dart';
import 'package:gp/features/DisplayStory/displayStory.dart';

class CreateStoryView extends StatefulWidget {
  @override
  State<CreateStoryView> createState() => _CreateStoryViewState();
}

class _CreateStoryViewState extends State<CreateStoryView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Add selectedType state
  int? _selectedTypeIndex;
  // Add selectedNarrator state
  int? _selectedNarratorIndex;

  // Common container decoration
  BoxDecoration get _containerDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
    ),
  );

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
                                      label: 'Fantasy',
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
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
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
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );
                              await Future.delayed(Duration(seconds: 2));
                              if (context.mounted) {
                                Navigator.of(context).pop(); // Remove progress
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const DisplayStory(),
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.auto_stories, color: Colors.white),
                            label: Text('Make My Story!'),
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

// Add this extension for color darkening
extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
