import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  late Account account;

  setUp(() async {
    final words =
        // ignore: lines_longer_than_80_chars
        'awful drop leaf tennis indoor begin mandate discover uncle seven only coil atom any hospital uncover make any climb actor armed measure need above hundred';
    account = await Account.fromSeedPhrase(words.split(' '));
  });

  test('Test to application arguments', () async {
    final goldenAddress = '/ryguxRKWk6ntDikaBrIDmyhBby2B/xWUyXJVpX2ohM=';
    final addr = '726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM';
    final arguments = 'str:arg1,int:12,addr:$addr'.toApplicationArguments();

    expect(arguments.length, equals(3));
    expect(base64Encode(arguments[2]), equals(goldenAddress));
  });
}
