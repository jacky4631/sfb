/// This enum represents the new surface colors introduced in Material Design 3.0.
///
/// The different colors represent different tones and can be used to convey
/// hierarchy, depth, and focus. They can be used as background colors for
/// surfaces such as cards, dialog boxes, or containers.
///
/// To select a surface color for a widget, use the `SurfaceColorEnum` values
/// with the `PaneContainerWidget`. The corresponding color is selected using
/// the `NewSurfaceTheme.getSurfaceColor` method and the current theme.
///
/// For more information about the new surface colors, see the Material Design 3.0
/// blog post: https://material.io/blog/tone-based-surface-color-m3
enum SurfaceColorEnum {
  /// The lowest tone color that can be used as a background for a surface.
  surface,

  /// A slightly higher tone color that can be used for low-emphasis surfaces.
  surfaceContainerLowest,

  /// A higher tone color that can be used for medium-emphasis surfaces.
  surfaceContainerLow,

  /// A higher tone color that can be used for high-emphasis surfaces.
  surfaceContainer,

  /// A higher tone color that can be used for elevated surfaces, such as dialogs.
  surfaceContainerHigh,

  /// The highest tone color that can be used as a background for a surface.
  surfaceContainerHighest,
}
