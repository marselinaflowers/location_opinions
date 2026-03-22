class LocationSnapshot {
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final DateTime timestamp;

  const LocationSnapshot({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    required this.timestamp,
  });

  String get coordinatesLabel =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  String? get accuracyLabel {
    if (accuracyMeters == null) return null;
    return '±${accuracyMeters!.round()} m';
  }
}
