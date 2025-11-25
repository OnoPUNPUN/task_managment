import 'package:flutter/material.dart';

class AvatarHeader extends StatelessWidget {
  final String name;
  final VoidCallback? onToggleTheme;
  final ImageProvider avatar;

  const AvatarHeader({
    super.key,
    required this.name,
    required this.avatar,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(radius: 28, backgroundImage: avatar),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Removed theme toggle button to match design strictly if needed,
          // but keeping it invisible or removed if not in design.
          // The design doesn't show a theme toggle, so I'll remove it visually or keep it hidden.
          // For now, I'll assume we want to keep the functionality but maybe move it or hide it.
          // The user said "pixel perfect", the design has no theme toggle.
          // I will remove it from the visual tree.
        ],
      ),
    );
  }
}
