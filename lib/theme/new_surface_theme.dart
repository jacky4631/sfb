import 'package:flutter/material.dart';

import 'surface_color_enum.dart';

/// Provides methods for getting the appropriate surface color based on the selected
/// [SurfaceColorEnum] and the current [Theme] in [BuildContext].
class NewSurfaceTheme {
  /// Returns the surface color based on the [selectedColor] and the current [Theme]
  /// in [context].
  ///
  /// [SurfaceColorEnum.surface] returns the surface color from the current theme.
  ///
  /// [SurfaceColorEnum.surfaceContainerLowest] to [SurfaceColorEnum.surfaceContainerHigh]
  /// return the surface color tinted based on the elevation, with increasing opacity.
  ///
  /// [SurfaceColorEnum.surfaceContainerHighest] returns the surface variant color from
  /// the current theme.
  static Color getSurfaceColor(SurfaceColorEnum selectedColor, BuildContext context) {
    switch (selectedColor) {
      case SurfaceColorEnum.surface:
        return Theme.of(context).colorScheme.surface;
      case SurfaceColorEnum.surfaceContainerLowest:
        return Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
      case SurfaceColorEnum.surfaceContainerLow:
        return ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1,
        );
      case SurfaceColorEnum.surfaceContainer:
        return ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          2,
        );
      case SurfaceColorEnum.surfaceContainerHigh:
        return ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          3,
        );
      case SurfaceColorEnum.surfaceContainerHighest:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  static Color getSurfaceColorWithSeed(SurfaceColorEnum selectedColor, Color seedColor, BuildContext context) {
    switch (selectedColor) {
      case SurfaceColorEnum.surface:
        return ColorScheme.fromSeed(seedColor: seedColor).surface;
      case SurfaceColorEnum.surfaceContainerLowest:
        return Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
      case SurfaceColorEnum.surfaceContainerLow:
        return ElevationOverlay.applySurfaceTint(
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surface,
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surfaceTint,
          1,
        );
      case SurfaceColorEnum.surfaceContainer:
        return ElevationOverlay.applySurfaceTint(
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surface,
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surfaceTint,
          2,
        );
      case SurfaceColorEnum.surfaceContainerHigh:
        return ElevationOverlay.applySurfaceTint(
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surface,
          ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surfaceTint,
          3,
        );
      case SurfaceColorEnum.surfaceContainerHighest:
        return ColorScheme.fromSeed(seedColor: seedColor, brightness: Theme.of(context).brightness).surfaceContainerHighest;
    }
  }
}
