import 'package:algorand_dart/src/api/algod/algod_eval_delta.dart';

class ApplyData {
  final BigInt closingAmount;
  final BigInt assetClosingAmount;
  final BigInt senderRewards;
  final BigInt receiverRewards;
  final BigInt closeRewards;
  final AlgodEvalDelta? evalDelta;
  final BigInt configAsset;
  final BigInt applicationId;

  ApplyData({
    BigInt? closingAmount,
    BigInt? assetClosingAmount,
    BigInt? senderRewards,
    BigInt? receiverRewards,
    BigInt? closeRewards,
    this.evalDelta,
    BigInt? configAsset,
    BigInt? applicationId,
  })  : closingAmount = closingAmount ?? BigInt.zero,
        assetClosingAmount = assetClosingAmount ?? BigInt.zero,
        senderRewards = senderRewards ?? BigInt.zero,
        receiverRewards = receiverRewards ?? BigInt.zero,
        closeRewards = closeRewards ?? BigInt.zero,
        configAsset = configAsset ?? BigInt.zero,
        applicationId = applicationId ?? BigInt.zero;

  factory ApplyData.fromMessagePack(Map<String, dynamic> data) {
    final applyData = ApplyData(
      closingAmount: BigInt.from(data['ca'] as int? ?? 0),
      assetClosingAmount: BigInt.from(data['aca'] as int? ?? 0),
      senderRewards: BigInt.from(data['rs'] as int? ?? 0),
      receiverRewards: BigInt.from(data['rr'] as int? ?? 0),
      closeRewards: BigInt.from(data['rc'] as int? ?? 0),
      configAsset: BigInt.from(data['caid'] as int? ?? 0),
      applicationId: BigInt.from(data['apid'] as int? ?? 0),
      evalDelta: data['dt'] != null
          ? AlgodEvalDelta.fromJson(data['dt'] as Map<String, dynamic>)
          : null,
    );

    return applyData;
  }
}
