/// Implement this class to provide custom converters for a specific [Type].
///
/// [T] is the data type you'd like to convert to and from.
///
/// [S] is the type of the value stored in JSON. It must be a valid JSON type
/// such as [String], [int], or [Map<String, dynamic>].
abstract class MessagePackConverter<T, S> {
  T fromMessagePack(S msgPack);
  S toMessagePack(T object);
}
