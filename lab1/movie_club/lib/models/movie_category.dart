import 'package:flutter/material.dart';

enum MovieCategory {
  action('Action', Icons.local_fire_department),
  comedy('Comedy', Icons.sentiment_very_satisfied),
  drama('Drama', Icons.theater_comedy),
  animation('Animation', Icons.animation),
  sciFi('Sci-Fi', Icons.rocket_launch),
  horror('Horror', Icons.dark_mode);

  final String label;
  final IconData icon;

  const MovieCategory(this.label, this.icon);

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      MovieCategory.action => colorScheme.error,
      MovieCategory.comedy => colorScheme.tertiary,
      MovieCategory.drama => colorScheme.secondary,
      MovieCategory.animation => colorScheme.primary,
      MovieCategory.sciFi => colorScheme.primaryContainer,
      MovieCategory.horror => colorScheme.onSurfaceVariant,
    };
  }
}
