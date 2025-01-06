// lib/flip_card_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flip_card.dart';
import 'card_content.dart';
import 'dart:ui';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> flashcards = [
    {
      'category': '🧮 Mathematics',
      'question': 'What is π (pi)?',
      'answer':
      '3.14159...\n\nIt is the ratio of a circle\'s circumference to its diameter',
      'difficulty': 'Medium',
      'hint': 'Think about circles!',
    },
    {
      'category': '🧬 Science',
      'question': 'What is DNA?',
      'answer':
      'Deoxyribonucleic Acid\n\nIt carries genetic instructions for development and functioning of living things',
      'difficulty': 'Hard',
      'hint': 'It\'s in every cell of your body',
    },
    {
      'category': '📚 Literature',
      'question': 'Who wrote Romeo and Juliet?',
      'answer':
      'William Shakespeare\n\nWritten between 1591-1595, it\'s one of his most famous tragedies',
      'difficulty': 'Easy',
      'hint': 'Famous English playwright',
    },
    {
      'category': '🌍 Geography',
      'question': 'What is the capital of Japan?',
      'answer': 'Tokyo\n\nIt\'s the world\'s most populous metropolitan area',
      'difficulty': 'Easy',
      'hint': 'Starts with T',
    },
    {
      'category': '🎨 Art',
      'question': 'Who painted the Mona Lisa?',
      'answer': 'Leonardo da Vinci\n\nPainted between 1503-1519',
      'difficulty': 'Medium',
      'hint': 'Italian Renaissance polymath',
    },
    {
      'category': '💻 Technology',
      'question': 'What does CPU stand for?',
      'answer':
      'Central Processing Unit\n\nIt\'s the primary component that processes instructions in a computer',
      'difficulty': 'Medium',
      'hint': 'Brain of the computer',
    },
  ];

  late List<String> categories;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    categories = ['All', ...flashcards.map((e) => e['category'] as String).toSet()];
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedCategory = categories[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCards => flashcards
      .where((card) =>
  selectedCategory == 'All' || card['category'] == selectedCategory)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        title: const Text(
          '✨ Knowledge Cards',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            onPressed: _showInfo,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: const Color(0xFF6C63FF),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0.2,
              ),
              tabs: categories.map((category) => Tab(
                text: category.length > 10 ? '${category.substring(0, 10)}...' : category,
              )).toList(),
            ),

          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF0F0F0F),
              Color(0xFF050505),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine the maximum width for each card based on screen width
                double screenWidth = constraints.maxWidth;
                int crossAxisCount = screenWidth ~/ 220; // Minimum 200px per card
                crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;
                double maxCardWidth = screenWidth / crossAxisCount - 16;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filteredCards.length,
                  itemBuilder: (context, index) {
                    final card = filteredCards[index];
                    return FlipCard(
                      key: ValueKey('${card['category']}_$index'),
                      frontContent: CardContent(
                        title: card['question'],
                        subtitle: card['category'],
                        difficulty: card['difficulty'],
                        hint: card['hint'],
                        isQuestion: true,
                      ),
                      backContent: CardContent(
                        title: card['answer'],
                        subtitle: 'Tap to flip back',
                        difficulty: card['difficulty'],
                        hint: null,
                        isQuestion: false,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to Use',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoItem(
                    icon: Icons.touch_app,
                    text: 'Tap cards to flip between questions and answers',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.category,
                    text: 'Use category tabs to filter cards',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.bar_chart,
                    text: 'Difficulty levels are color-coded',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.lightbulb_outline,
                    text: 'Use hints when you\'re stuck',
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Got it!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
