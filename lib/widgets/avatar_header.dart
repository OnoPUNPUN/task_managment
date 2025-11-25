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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: avatar),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
    );
  }
}
