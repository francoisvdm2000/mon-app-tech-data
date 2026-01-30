import 'dart:math';

class PhotometryCalculations {
  static double luxFromCandela({
    required double candela,
    required double distanceMeter,
  }) {
    if (candela <= 0 || distanceMeter <= 0) return 0.0;
    return candela / pow(distanceMeter, 2);
  }

  static double candelaFromLux({
    required double lux,
    required double distanceMeter,
  }) {
    if (lux <= 0 || distanceMeter <= 0) return 0.0;
    return lux * pow(distanceMeter, 2);
  }

  static double solidAngleSteradianFromBeamAngle({
    required double beamAngleDegree,
  }) {
    if (beamAngleDegree <= 0) return 0.0;
    // Ω = 2π (1 - cos(θ/2))
    final thetaRad = beamAngleDegree * pi / 180.0;
    final half = thetaRad / 2.0;
    final omega = 2.0 * pi * (1.0 - cos(half));
    return omega.isFinite && omega > 0 ? omega : 0.0;
  }

  static double lumensFromCandelaAndBeamAngle({
    required double candela,
    required double beamAngleDegree,
  }) {
    if (candela <= 0) return 0.0;
    final omega = solidAngleSteradianFromBeamAngle(beamAngleDegree: beamAngleDegree);
    if (omega <= 0) return 0.0;
    return candela * omega;
  }

  static double candelaFromLumensAndBeamAngle({
    required double lumens,
    required double beamAngleDegree,
  }) {
    if (lumens <= 0) return 0.0;
    final omega = solidAngleSteradianFromBeamAngle(beamAngleDegree: beamAngleDegree);
    if (omega <= 0) return 0.0;
    return lumens / omega;
  }

  static double luxFromLumensDistanceAndBeamAngle({
    required double lumens,
    required double distanceMeter,
    required double beamAngleDegree,
  }) {
    if (lumens <= 0 || distanceMeter <= 0 || beamAngleDegree <= 0) return 0.0;
    final thetaRad = beamAngleDegree * pi / 180.0;
    final radius = distanceMeter * tan(thetaRad / 2.0);
    if (!radius.isFinite || radius <= 0) return 0.0;
    final area = pi * pow(radius, 2);
    if (area <= 0) return 0.0;
    return lumens / area;
  }
}
