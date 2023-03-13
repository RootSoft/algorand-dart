abstract class QueryBuilder<T extends QueryBuilder<T>> {
  final Map<String, dynamic> parameters = {};

  /// Include results with the given asset id.
  T whereAssetId(int assetId) {
    addQueryParameter('asset-id', assetId);
    return me();
  }

  /// Results should have an amount greater than this value.
  /// MicroAlgos are the default currency unless an asset-id is provided,
  /// in which case the asset will be used.
  T whereCurrencyIsGreaterThan(int amount) {
    addQueryParameter('currency-greater-than', amount);
    return me();
  }

  /// Results should have an amount less than this value.
  /// MicroAlgos are the default currency unless an asset-id is provided,
  /// in which case the asset will be used.
  T whereCurrencyIsLessThan(int amount) {
    addQueryParameter('currency-less-than', amount);
    return me();
  }

  /// Include all items including closed accounts, deleted applications,
  /// destroyed assets, opted-out asset holdings, and closed-out
  /// application localstates.
  T includeAll(bool includeAll) {
    addQueryParameter('include-all', includeAll);
    return me();
  }

  /// The next page of results.
  /// Use the next token provided by the previous results.
  T next(String? next) {
    addQueryParameter('next', next);
    return me();
  }

  /// Maximum number of results to return.
  T limit(int limit) {
    addQueryParameter('limit', limit);
    return me();
  }

  /// Add an additional query parameter.
  T addQueryParameter(String parameter, dynamic value) {
    parameters[parameter] = value;
    return me();
  }

  T me();
}
