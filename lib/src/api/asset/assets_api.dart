import 'dart:async';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/asset/algod_asset_service.dart';
import 'package:algorand_dart/src/api/asset/indexer_asset_service.dart';
import 'package:dio/dio.dart';

class AssetsApi {
  final AlgorandApi _api;
  final AlgodAssetService _algod;
  final IndexerAssetService _indexer;

  AssetsApi({
    required AlgorandApi api,
    required AlgodAssetService algod,
    required IndexerAssetService indexer,
  })  : _api = api,
        _algod = algod,
        _indexer = indexer;

  /// Lookup assets information by a given account id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the assets information for the given account id.
  Future<List<AssetHolding>> getAssetsByAddress(
    String address, {
    int? assetId,
    bool? includeAll,
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.paginate<AssetHolding>((nextToken) async {
      final response = await _indexer.getAssetsByAccount(
        address: address,
        assetId: assetId,
        includeAll: includeAll,
        limit: perPage,
        next: nextToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return PaginatedResult(
        nextToken: response.nextToken,
        items: response.assets,
      );
    });
  }

  /// Get the assets created by the given account.
  /// Given a specific account public key, this call returns the assets
  /// created by the address.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the assets.
  Future<List<Asset>> getCreatedAssetsByAddress(
    String address, {
    int? assetId,
    bool? includeAll,
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.paginate<Asset>((nextToken) async {
      final response = await _indexer.getCreatedAssetsByAccount(
        address: address,
        assetId: assetId,
        includeAll: includeAll,
        limit: perPage,
        next: nextToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return PaginatedResult(
        nextToken: response.nextToken,
        items: response.assets,
      );
    });
  }
}
