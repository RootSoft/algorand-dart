import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'abi_method.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class AbiMethod {
  static const TxAnyType = 'txn';

  static const RefTypeAccount = 'account';

  static const RefTypeAsset = 'asset';

  static const RefTypeApplication = 'application';

  static final Set<String> TxArgTypes = {
    TxAnyType,
    TransactionType.PAYMENT.value,
    TransactionType.KEY_REGISTRATION.value,
    TransactionType.ASSET_CONFIG.value,
    TransactionType.ASSET_TRANSFER.value,
    TransactionType.ASSET_FREEZE.value,
    TransactionType.APPLICATION_CALL.value,
  };

  static final Set<String> RefArgTypes = {
    RefTypeAccount,
    RefTypeAsset,
    RefTypeApplication,
  };

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'desc', defaultValue: '')
  final String description;

  @JsonKey(name: 'args', defaultValue: [])
  final List<Argument> arguments;

  @JsonKey(name: 'returns')
  final Returns returns;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int txnCallCount = 1;

  AbiMethod({
    required this.name,
    required this.description,
    required this.arguments,
    this.returns = const Returns(),
  }) {
    for (var arg in arguments) {
      if (TxArgTypes.contains(arg.type)) {
        txnCallCount++;
      }
    }
  }

  factory AbiMethod.fromJson(Map<String, dynamic> json) =>
      _$AbiMethodFromJson(json);

  Map<String, dynamic> toJson() => _$AbiMethodToJson(this);

  factory AbiMethod.method(String method) {
    final parsedMethod = _methodParse(method);
    final name = parsedMethod[0];
    final parsedMethodsArgs = AbiType.parseTupleContent(parsedMethod[1]);

    final args = parsedMethodsArgs
        .map((arg) => Argument(name: '', type: arg, description: ''))
        .toList();

    final returns = Returns(type: parsedMethod[2]);

    return AbiMethod(
      name: name,
      description: '',
      arguments: args,
      returns: returns,
    );
  }

  static List<String> _methodParse(String method) {
    final parentStack = ListQueue<int>();
    for (var i = 0; i < method.length; i++) {
      final char = method[i];
      if (char == '(') {
        parentStack.add(i);
      } else if (char == ')') {
        if (parentStack.isEmpty) {
          break;
        }

        var leftParentIndex = parentStack.removeLast();
        if (parentStack.isNotEmpty) {
          continue;
        }

        final result = <String>[];
        result.add(method.substring(0, leftParentIndex));
        if (leftParentIndex + 1 == i) {
          result.add('');
        } else {
          result.add(method.substring(leftParentIndex + 1, i));
        }
        result.add(method.substring(i + 1));
        return result;
      }
    }

    throw ArgumentError('method string parentheses unbalanced: $method');
  }

  String get signature {
    final argStringList = arguments.map((arg) => arg.type);

    return "$name(${argStringList.join(',')})${returns.type}";
  }

  Uint8List get selector {
    final methodBytes = utf8.encode(signature);
    final digest = sha512256.convert(methodBytes).bytes;
    return Uint8List.fromList(digest.getRange(0, 4).toList());
  }

  /// Find the ABI method with the given name in this contract.
  static AbiMethod getMethodByName(List<AbiMethod> methods, String name) {
    final filteredMethods = <AbiMethod>[];

    for (var method in methods) {
      if (method.name == name) {
        filteredMethods.add(method);
      }
    }

    if (filteredMethods.length > 1) {
      final sigs = <String>[];

      for (var idx = 0; idx < filteredMethods.length; idx++) {
        sigs[idx] = filteredMethods[idx].signature;
      }

      final found = sigs.join(',');
      throw ArgumentError(
          'found ${filteredMethods.length} methods with the same name: $found');
    }

    if (filteredMethods.isEmpty) {
      throw ArgumentError('foud 0 methods with the name $name');
    }

    return filteredMethods.first;
  }

  static bool isTxnArgOrForeignArrayArgs(String data) {
    return TxArgTypes.contains(data) || RefArgTypes.contains(data);
  }
}
