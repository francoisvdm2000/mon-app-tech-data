import 'dart:math';

class LaserSafetyConstants {
  // Seuils indicatifs (comme sur ta capture)
  static const double mpeNohd = 25.4; // W/m²
  static const double mpeSzed = 1.0;  // W/m²
  static const double mpeCzed = 0.05; // W/m²
}

class LaserInputs {
  final double powerMilliwatt; // mW
  final double divergenceMilliradian; // mrad (angle plein)
  final double outputDiameterMillimeter; // mm

  const LaserInputs({
    required this.powerMilliwatt,
    required this.divergenceMilliradian,
    required this.outputDiameterMillimeter,
  });

  double get powerWatt => powerMilliwatt / 1000.0;
  double get divergenceRad => divergenceMilliradian / 1000.0;
  double get outputDiameterMeter => outputDiameterMillimeter / 1000.0;
}

class LaserResults {
  final double nohdMeter;
  final double czedMeter;
  final double szedMeter;

  const LaserResults({
    required this.nohdMeter,
    required this.czedMeter,
    required this.szedMeter,
  });
}

class TargetDistanceAssessment {
  final double powerMaxWattAtTarget;
  final double usagePercent;
  final double recommendedMaxPercent;
  final bool isWithinLimit;

  const TargetDistanceAssessment({
    required this.powerMaxWattAtTarget,
    required this.usagePercent,
    required this.recommendedMaxPercent,
    required this.isWithinLimit,
  });
}

class LaserCalculations {
  static double beamDiameterAtDistanceMeter({
    required double outputDiameterMeter,
    required double divergenceRad,
    required double distanceMeter,
  }) {
    if (outputDiameterMeter <= 0 || divergenceRad <= 0 || distanceMeter < 0) return 0.0;
    return outputDiameterMeter + divergenceRad * distanceMeter;
  }

  static double distanceForMpe({
    required double powerWatt,
    required double outputDiameterMeter,
    required double divergenceRad,
    required double mpeWattPerSquareMeter,
  }) {
    if (powerWatt <= 0) return 0.0;
    if (outputDiameterMeter <= 0) return 0.0;
    if (divergenceRad <= 0) return 0.0;
    if (mpeWattPerSquareMeter <= 0) return 0.0;

    final double dMpe = sqrt((4.0 * powerWatt) / (pi * mpeWattPerSquareMeter));
    final double z = (dMpe - outputDiameterMeter) / divergenceRad;

    if (z.isNaN || z.isInfinite) return 0.0;
    return max(0.0, z);
  }

  static LaserResults computeZones(LaserInputs inputs) {
    final p = inputs.powerWatt;
    final d0 = inputs.outputDiameterMeter;
    final theta = inputs.divergenceRad;

    final nohd = distanceForMpe(
      powerWatt: p,
      outputDiameterMeter: d0,
      divergenceRad: theta,
      mpeWattPerSquareMeter: LaserSafetyConstants.mpeNohd,
    );

    final czed = distanceForMpe(
      powerWatt: p,
      outputDiameterMeter: d0,
      divergenceRad: theta,
      mpeWattPerSquareMeter: LaserSafetyConstants.mpeCzed,
    );

    final szed = distanceForMpe(
      powerWatt: p,
      outputDiameterMeter: d0,
      divergenceRad: theta,
      mpeWattPerSquareMeter: LaserSafetyConstants.mpeSzed,
    );

    return LaserResults(nohdMeter: nohd, czedMeter: czed, szedMeter: szed);
  }

  static double maxAllowedPowerAtDistanceWatt({
    required double outputDiameterMeter,
    required double divergenceRad,
    required double distanceMeter,
    required double mpeWattPerSquareMeter,
  }) {
    if (outputDiameterMeter <= 0 || divergenceRad <= 0 || distanceMeter < 0) return 0.0;
    if (mpeWattPerSquareMeter <= 0) return 0.0;

    final d = beamDiameterAtDistanceMeter(
      outputDiameterMeter: outputDiameterMeter,
      divergenceRad: divergenceRad,
      distanceMeter: distanceMeter,
    );
    if (d <= 0) return 0.0;

    return (mpeWattPerSquareMeter * pi * pow(d, 2)) / 4.0;
  }

  static TargetDistanceAssessment assessAtTargetDistance({
    required LaserInputs inputs,
    required double targetDistanceMeter,
  }) {
    final p = inputs.powerWatt;
    final d0 = inputs.outputDiameterMeter;
    final theta = inputs.divergenceRad;

    final pMax = maxAllowedPowerAtDistanceWatt(
      outputDiameterMeter: d0,
      divergenceRad: theta,
      distanceMeter: targetDistanceMeter,
      mpeWattPerSquareMeter: LaserSafetyConstants.mpeNohd,
    );

    if (p <= 0 || pMax <= 0) {
      return const TargetDistanceAssessment(
        powerMaxWattAtTarget: 0.0,
        usagePercent: 0.0,
        recommendedMaxPercent: 0.0,
        isWithinLimit: true,
      );
    }

    final usage = (p / pMax) * 100.0;
    final within = usage <= 100.0;

    final recommendedMaxPercent = within ? 100.0 : (pMax / p) * 100.0;

    return TargetDistanceAssessment(
      powerMaxWattAtTarget: pMax,
      usagePercent: usage,
      recommendedMaxPercent: max(0.0, min(100.0, recommendedMaxPercent)),
      isWithinLimit: within,
    );
  }
}
