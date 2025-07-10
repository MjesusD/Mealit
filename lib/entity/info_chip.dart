import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final chipColor = colorScheme.primary;
    final backgroundColor = chipColor.withAlpha(25);
    final borderColor = chipColor.withAlpha(77);

    return Chip(
      backgroundColor: backgroundColor,
      avatar: Icon(icon, color: chipColor, size: 20),
      label: Container(
        // Para alinear texto a la izquierda y evitar que esté centrado verticalmente
        constraints: const BoxConstraints(minWidth: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,  // Alineado a la izquierda
          children: [
            Text(label, style: textTheme.bodySmall?.copyWith(color: chipColor)),
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: chipColor,
              ),
            ),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      side: BorderSide(color: borderColor),
    );
  }
}
