class EditingSettings {
  const EditingSettings({
    this.paint = false,
    this.erase = false,
    this.updateOnPanEnd = true,
  });

  final bool paint;
  final bool erase;
  final bool updateOnPanEnd;

  static EditingSettings get noMode => const EditingSettings(paint: false, erase: false);
  static EditingSettings get paintMode => const EditingSettings(paint: true, erase: false);
  static EditingSettings get eraseMode => const EditingSettings(paint: false, erase: true);

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
