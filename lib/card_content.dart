// lib/card_content.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class CardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String difficulty;
  final String? hint;
  final bool isQuestion;

  const CardContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.isQuestion,
    this.hint,
  });

  Color _getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4ADE80);
      case 'medium':
        return const Color(0xFFFACC15);
      case 'hard':
        return const Color(0xFFF43F5E);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double scale = width / 200; // Base width for scaling
        scale = scale.clamp(0.6, 1.0); // Prevent extreme scaling

        return Container(
          padding: EdgeInsets.all(14 * scale), // Reduced padding to prevent overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDifficultyBadge(scale),
              SizedBox(height: 12 * scale), // Reduced spacing
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * scale, // Reduced font size
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5 * scale,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 8 * scale), // Reduced spacing
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14 * scale, // Reduced font size
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2 * scale,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (hint != null && isQuestion) _buildHint(scale),
              SizedBox(height: 8 * scale), // Reduced spacing
              _buildFlipIndicator(scale),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultyBadge(double scale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20 * scale), // Reduced radius
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8 * scale, sigmaY: 8 * scale),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(20 * scale),
            border: Border.all(
              color: _getDifficultyColor().withOpacity(0.3),
              width: 1.0 * scale, // Reduced border width
            ),
            boxShadow: [
              BoxShadow(
                color: _getDifficultyColor().withOpacity(0.2),
                blurRadius: 6 * scale, // Reduced blur radius
                offset: Offset(0, 1 * scale), // Reduced offset
              ),
            ],
          ),
          child: Text(
            difficulty,
            style: TextStyle(
              color: _getDifficultyColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14 * scale, // Reduced font size
              letterSpacing: 0.5 * scale,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHint(double scale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16 * scale), // Reduced radius
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8 * scale, sigmaY: 8 * scale),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8 * scale),
          padding: EdgeInsets.all(12 * scale), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.8 * scale, // Reduced border width
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 14 * scale, // Reduced icon size
                  ),
                  SizedBox(width: 6 * scale), // Reduced spacing
                  Expanded(
                    child: Text(
                      'Hint',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 12 * scale, // Reduced font size
                        letterSpacing: 0.3 * scale,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6 * scale), // Reduced spacing
              Text(
                hint ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12 * scale, // Reduced font size
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2 * scale,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlipIndicator(double scale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20 * scale), // Reduced radius
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8 * scale, sigmaY: 8 * scale),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20 * scale),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.8 * scale, // Reduced border width
            ),
          ),
          child: Row(
            children: [
              Icon(
                isQuestion ? Icons.touch_app : Icons.flip_camera_android,
                color: Colors.white.withOpacity(0.6),
                size: 14 * scale, // Reduced icon size
              ),
              SizedBox(width: 6 * scale), // Reduced spacing
              Expanded(
                child: Text(
                  isQuestion ? 'Tap to reveal answer' : 'Tap to flip back',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12 * scale, // Reduced font size
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2 * scale,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
