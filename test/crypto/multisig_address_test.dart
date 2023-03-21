import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test MultiSigAddress to string', () async {
    final one = Address.fromAlgorandAddress(
      'XMHLMNAVJIMAW2RHJXLXKKK4G3J3U6VONNO3BTAQYVDC3MHTGDP3J5OCRU',
    );
    final two = Address.fromAlgorandAddress(
      'HTNOX33OCQI2JCOLZ2IRM3BC2WZ6JUILSLEORBPFI6W7GU5Q4ZW6LINHLA',
    );

    final three = Address.fromAlgorandAddress(
      'E6JSNTY4PVCY3IRZ6XEDHEO6VIHCQ5KGXCIQKFQCMB2N6HXRY4IB43VSHI',
    );

    final publicKeys = [one, two, three];

    final multiSigAddr =
        MultiSigAddress(version: 1, threshold: 2, publicKeys: publicKeys);

    expect(
      multiSigAddr.toString(),
      'UCE2U2JC4O4ZR6W763GUQCG57HQCDZEUJY4J5I6VYY4HQZUJDF7AKZO5GM',
    );
  });
}
