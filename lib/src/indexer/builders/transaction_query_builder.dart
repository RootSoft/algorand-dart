import 'dart:convert';

import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/indexer/builders/query_builders.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';

class TransactionQueryBuilder extends QueryBuilder<TransactionQueryBuilder> {
  static const KEY_ACCOUNT_ID = 'for_account_id';
  static const KEY_ASSET_ID = 'for_asset_id';

  final IndexerRepository indexerRepository;

  TransactionQueryBuilder({required this.indexerRepository});

  /// Lookup transactions for the given asset.
  TransactionQueryBuilder forAsset(int assetId) {
    addQueryParameter(KEY_ASSET_ID, assetId);
    return this;
  }

  /// Lookup transaction for the given account.
  TransactionQueryBuilder forAccount(String accountId) {
    addQueryParameter(KEY_ACCOUNT_ID, accountId);
    return this;
  }

  /// Only include transactions with this address in one of the transaction
  /// fields.
  TransactionQueryBuilder whereAddress(Address address) {
    addQueryParameter('address', address.encodedAddress);
    return this;
  }

  /// Combine with the address parameter to define what type of address to
  /// search for.
  TransactionQueryBuilder whereAddressRole(AddressRole role) {
    addQueryParameter('address-role', role.value);
    return this;
  }

  /// Include results after the given time.
  /// Must be an RFC 3339 formatted string.
  TransactionQueryBuilder after(DateTime dateTime) {
    addQueryParameter('after-time', dateTime.toUtc().toIso8601String());
    return this;
  }

  /// Include results before the given time.
  /// Must be an RFC 3339 formatted string.
  TransactionQueryBuilder before(DateTime dateTime) {
    addQueryParameter('before-time', dateTime.toUtc().toIso8601String());
    return this;
  }

  /// Combine with address and address-role parameters to define what type of
  /// address to search for.
  ///
  /// The close to fields are normally treated as a receiver, if you
  /// would like to exclude them set this parameter to true.
  TransactionQueryBuilder excludeCloseTo(bool excludeCloseTo) {
    addQueryParameter('exclude-close-to', excludeCloseTo);
    return this;
  }

  /// Include results for the specified round.
  TransactionQueryBuilder whereRound(int round) {
    addQueryParameter('round', round);
    return this;
  }

  /// Include results at or before the specified max-round.
  TransactionQueryBuilder beforeMaxRound(int maxRound) {
    addQueryParameter('max-round', maxRound);
    return this;
  }

  /// Include results at or after the specified min-round.
  TransactionQueryBuilder afterMinRound(int minRound) {
    addQueryParameter('min-round', minRound);
    return this;
  }

  /// Include results with the given application id.
  TransactionQueryBuilder whereApplicationId(int applicationId) {
    addQueryParameter('application-id', applicationId);
    return this;
  }

  /// Specifies a prefix which must be contained in the note field.
  TransactionQueryBuilder whereNotePrefix(String notePrefix) {
    addQueryParameter('note-prefix', base64.encode(utf8.encode(notePrefix)));
    return this;
  }

  /// Include results which include the rekey-to field.
  TransactionQueryBuilder rekeyTo(bool rekeyTo) {
    addQueryParameter('rekey-to', rekeyTo);
    return this;
  }

  /// SigType filters just results using the specified type of signature.
  TransactionQueryBuilder whereSignatureType(SignatureType signatureType) {
    addQueryParameter('sig-type', signatureType.value);
    return this;
  }

  /// Include results only with the given transaction type.
  TransactionQueryBuilder whereTransactionType(
      TransactionType transactionType) {
    addQueryParameter('tx-type', transactionType.value);
    return this;
  }

  /// Include results only with the given transaction id.
  TransactionQueryBuilder whereTransactionId(String transactionId) {
    addQueryParameter('txid', transactionId);
    return this;
  }

  /// Perform the query and fetch the transactions.
  Future<SearchTransactionsResponse> search({int? limit}) async {
    if (limit != null) {
      this.limit(limit);
    }

    // Search the transactions
    return indexerRepository.searchTransactions(parameters);
  }

  @override
  TransactionQueryBuilder me() {
    return this;
  }
}
