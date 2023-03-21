import 'dart:math';

class Algo {
  static const MICRO_ALGOS = 'microAlgos';
  static const ALGOS = 'ALGOS';

  static const converters = {
    MICRO_ALGOS: 1,
    ALGOS: 1000000,
  };

  /// Convert an amount of Algo's to the base unit of microAlgos.
  static BigInt toMicroAlgos(double algos) {
    return BigInt.from((algos * converters[ALGOS]!).round());
  }

  /// Convert an amount of microAlgo's to Algos.
  static double fromMicroAlgos(int microAlgos) {
    return microAlgos / converters[ALGOS]!;
  }

  /// Format a given amount with the decimals.
  static int format(double amount, int decimals) {
    return (amount * (pow(10, decimals))).toInt();
  }
}
