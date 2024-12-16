/// Represents the settings for editing a Nonogram.
class EditingSettings {
  /// Creates a new instance of [EditingSettings].
  const EditingSettings({
    this.paint = false,
    this.erase = false,
    this.updateOnPanEnd = true,
  });

  /// Whether the paint mode is enabled.
  final bool paint;

  /// Whether the erase mode is enabled.
  final bool erase;

  /// Whether to update on pan end.
  final bool updateOnPanEnd;

  /// A constant instance of [EditingSettings] with no mode enabled.
  static const EditingSettings noMode = EditingSettings();

  /// A constant instance of [EditingSettings] with paint mode enabled.
  static const EditingSettings paintMode = EditingSettings(paint: true);

  /// A constant instance of [EditingSettings] with erase mode enabled.
  static const EditingSettings eraseMode = EditingSettings(erase: true);

  /// Creates a copy of the current [EditingSettings] with the given parameters.
  ///
  /// Returns a new instance of [EditingSettings] with the updated values.
  EditingSettings copyWith({
    bool? paint,
    bool? erase,
    bool? updateOnPanEnd,
  }) {
    return EditingSettings(
      paint: paint ?? this.paint,
      erase: erase ?? this.erase,
      updateOnPanEnd: updateOnPanEnd ?? this.updateOnPanEnd,
    );
  }
}
