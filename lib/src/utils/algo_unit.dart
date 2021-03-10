class Algo {
  static const MICRO_ALGOS = 'microAlgos';
  static const ALGOS = 'ALGOS';

  static const converters = {
    MICRO_ALGOS: 1,
    ALGOS: 1000000,
  };

  /// Convert an amount of Algo's to the base unit of microAlgos.
  static int toMicroAlgos(double algos) {
    return (algos * converters[ALGOS]!).round();
  }

  /// Convert an amount of microAlgo's to Algos.
  static int fromMicroAlgos(double microAlgos) {
    return (microAlgos / converters[ALGOS]!).round();
  }
}
