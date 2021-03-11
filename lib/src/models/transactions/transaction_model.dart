import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Transaction {
  /// Rewards applied to close-remainder-to account.
  final int? closeRewards;

  /// Closing amount for transaction.
  final int? closingAmount;

  /// Round when the transaction was confirmed.
  final int? confirmedRound;

  /// Transaction fee.
  final int fee;

  /// First valid round for this transaction
  final int firstValid;

  /// Hash of genesis block.
  final String? genesisHash;

  /// Genesis block ID.
  final String? genesisId;

  /// Transaction ID
  final String id;

  /// Offset into the round where this transaction was confirmed.
  final int? intraRoundOffset;

  /// Last valid round for this transaction.
  final int lastValid;

  /// Fields for a payment transaction.
  @JsonKey(name: 'payment-transaction')
  final Payment? payment;

  /// Rewards applied to receiver account.
  final int? receiverRewards;

  /// Time when the block this transaction is in was confirmed.
  final int? roundTime;

  /// Sender's address.
  final String sender;

  /// Rewards applied to sender account.
  final int? senderRewards;

  /// Validation signature associated with some data.
  final TransactionSignature signature;

  /// Indicates what type of transaction this is.
  /// Different types have different fields.
  /// Valid types, and where their fields are stored:
  /// [pay] payment-transaction
  /// [keyreg] keyreg-transaction
  /// [acfg] asset-config-transaction
  /// [axfer] asset-transfer-transaction
  /// [afrz] asset-freeze-transaction
  /// [appl] application-transaction
  @JsonKey(name: 'tx-type')
  final String type;

  //final KeyregTransaction keyregTransaction;

  /// Free form data.
  final String? note;

  Transaction({
    required this.id,
    required this.fee,
    required this.firstValid,
    required this.lastValid,
    required this.sender,
    required this.type,
    required this.signature,
    this.closeRewards,
    this.closingAmount,
    this.confirmedRound,
    this.genesisHash,
    this.genesisId,
    this.intraRoundOffset,
    this.payment,
    this.receiverRewards,
    this.roundTime,
    this.senderRewards,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
