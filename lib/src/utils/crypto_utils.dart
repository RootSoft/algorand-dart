extension CryptoStringExtension on String {
  String trimPadding() {
    return replaceAll(RegExp(r'='), '');
  }
}
