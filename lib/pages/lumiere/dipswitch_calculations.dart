class DipSwitchCalculations {
  // 9 interrupteurs : 1,2,4,8,16,32,64,128,256
  static const List<int> weights = [1, 2, 4, 8, 16, 32, 64, 128, 256];

  static List<bool> addressToSwitches(int address) {
    if (address < 0) address = 0;
    if (address > 511) address = 511; // max encodable sur 9 bits
    final sw = List<bool>.filled(9, false);
    var remaining = address;
    for (int i = weights.length - 1; i >= 0; i--) {
      if (remaining >= weights[i]) {
        sw[i] = true;
        remaining -= weights[i];
      }
    }
    return sw;
  }

  static int switchesToAddress(List<bool> switches) {
    var sum = 0;
    for (int i = 0; i < 9 && i < switches.length; i++) {
      if (switches[i]) sum += weights[i];
    }
    return sum;
  }
}
