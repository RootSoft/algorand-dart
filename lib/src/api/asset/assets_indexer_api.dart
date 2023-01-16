import 'dart:async';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/asset/asset_indexer_service.dart';
import 'package:dio/dio.dart';

class AssetsIndexerApi {
  final AlgorandApi _api;
  final AssetIndexerService _service;

  AssetsIndexerApi({
    required AlgorandApi api,
    required AssetIndexerService service,
  })  : _api = api,
        _service = service;

  /// Lookup asset information by a given asset id.
  ///
  /// Include all items including closed accounts, deleted applications,
  /// destroyed assets, opted-out asset holdings, and closed-out application
  /// localstates.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the asset information for the given asset id.
  Future<AssetResponse> getAssetById(
    int assetId, {
    bool? includeAll,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.execute<AssetResponse>(
      () => _service.getAssetById(
        assetId: assetId,
        includeAll: includeAll,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

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
      final response = await _service.getAssetsByAccount(
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
      final response = await _service.getCreatedAssetsByAccount(
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
