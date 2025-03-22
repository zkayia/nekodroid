import 'dart:ui';

extension SizeX on Size {
  Map<String, dynamic> toMap() => {
        "width": width,
        "height": height,
      };

  static Size fromMap(Map<String, dynamic> map) => Size(
        (map["width"] as num?)?.toDouble() ?? 0,
        (map["height"] as num?)?.toDouble() ?? 0,
      );
}
