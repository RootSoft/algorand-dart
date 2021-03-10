import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/utils/transformers/message_pack_converter.dart';

class NoteTransformer implements MessagePackConverter<String?, Uint8List?> {
  const NoteTransformer();

  @override
  String? fromMessagePack(Uint8List? msgPack) => '';

  @override
  Uint8List? toMessagePack(String? note) =>
      note != null ? Uint8List.fromList(utf8.encode(note)) : null;
}
