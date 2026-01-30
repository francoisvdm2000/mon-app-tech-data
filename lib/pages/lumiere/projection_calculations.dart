import 'dart:math';

class ProjectionCalculations {
  static double spotDiameterMeter({
    required double distanceMeter,
    required double beamAngleDegree,
  }) {
    if (distanceMeter <= 0) return 0.0;
    if (beamAngleDegree <= 0) return 0.0;
    final halfAngleRad = (beamAngleDegree * pi / 180.0) / 2.0;
    final diameter = 2.0 * distanceMeter * tan(halfAngleRad);
    if (diameter.isNaN || diameter.isInfinite) return 0.0;
    return max(0.0, diameter);
  }

  static double beamAngleDegree({
    required double distanceMeter,
    required double spotDiameterMeter,
  }) {
    if (distanceMeter <= 0) return 0.0;
    if (spotDiameterMeter <= 0) return 0.0;
    final halfAngleRad = atan(spotDiameterMeter / (2.0 * distanceMeter));
    final angleRad = 2.0 * halfAngleRad;
    final angleDeg = angleRad * 180.0 / pi;
    if (angleDeg.isNaN || angleDeg.isInfinite) return 0.0;
    return max(0.0, angleDeg);
  }

  static double distanceMeter({
    required double beamAngleDegree,
    required double spotDiameterMeter,
  }) {
    if (beamAngleDegree <= 0) return 0.0;
    if (spotDiameterMeter <= 0) return 0.0;
    final halfAngleRad = (beamAngleDegree * pi / 180.0) / 2.0;
    final denom = 2.0 * tan(halfAngleRad);
    if (denom == 0) return 0.0;
    final distance = spotDiameterMeter / denom;
    if (distance.isNaN || distance.isInfinite) return 0.0;
    return max(0.0, distance);
  }
}
