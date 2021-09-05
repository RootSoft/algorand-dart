import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('Test to application arguments', () async {
    final goldenAddress = '/ryguxRKWk6ntDikaBrIDmyhBby2B/xWUyXJVpX2ohM=';
    final addr = '726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM';
    final arguments = 'str:arg1,int:12,addr:$addr'.toApplicationArguments();

    expect(arguments.length, equals(3));
    expect(base64Encode(arguments[2]), equals(goldenAddress));
  });
}
