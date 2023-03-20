import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_algod_service.g.dart';

@RestApi()
abstract class AccountAlgodService {
  factory AccountAlgodService(Dio dio, {String baseUrl}) = _AccountAlgodService;

  @GET('/v2/accounts/{address}')
  Future<AccountInformation> getAccountByAddress({
    @Path('address') required String address,
    @Query('exclude') Exclude? exclude,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
