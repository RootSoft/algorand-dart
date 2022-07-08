class Array {
  static void copy(
    List<int> source,
    int sourceOffset,
    List<int> target,
    int targetOffset,
    int length,
  ) {
    target.setRange(targetOffset, targetOffset + length, source, sourceOffset);
  }
}
