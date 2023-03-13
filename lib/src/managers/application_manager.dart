import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';
import 'package:algorand_dart/src/utils/crypto_utils.dart';

class ApplicationManager {
  /// Repository used to perform transaction related tasks.
  final ApplicationRepository applicationRepository;

  /// Repository used to perform transaction related tasks.
  final TransactionRepository transactionRepository;

  ApplicationManager({
    required this.applicationRepository,
    required this.transactionRepository,
  });

  /// Compile TEAL source code to binary, produce its hash
  ///
  /// Given TEAL source code in plain text, return base64 encoded program bytes
  /// and base32 SHA512_256 hash of program bytes (Address style).
  ///
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  Future<TealCompilation> compileTEAL(String sourceCode) async {
    return await applicationRepository.compileTEAL(sourceCode);
  }

  /// Executes TEAL program(s) in context and returns debugging information
  /// about the execution.
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  /// /v2/teal/dryrun
  Future<DryRunResponse> dryrun(DryRunRequest request) async {
    return await applicationRepository.dryrun(request);
  }

  /// Create a new Algorand Stateful Smart Contract.
  /// This is a helper function to create a new application on the blockchain.
  ///
  /// Throws [AlgorandException] if unable to create the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> createApplication({
    required Account account,
    required TEALProgram approvalProgram,
    required TEALProgram clearProgram,
    required StateSchema globalStateSchema,
    required StateSchema localStateSchema,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationCreateTransactionBuilder()
          ..sender = account.address
          ..approvalProgram = approvalProgram
          ..clearStateProgram = clearProgram
          ..globalStateSchema = globalStateSchema
          ..localStateSchema = localStateSchema
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Create a new Algorand Stateful Smart Contract from the given source code.
  /// This is a helper function to create a new application on the blockchain.
  ///
  /// Throws [AlgorandException] if unable to create the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> createApplicationFromSource({
    required Account account,
    required String approvalProgramSource,
    required String clearProgramSource,
    required StateSchema globalStateSchema,
    required StateSchema localStateSchema,
  }) async {
    // Compile the programs
    final approvalProgram = await compileTEAL(approvalProgramSource);
    final clearProgram = await compileTEAL(clearProgramSource);

    return await createApplication(
      account: account,
      approvalProgram: approvalProgram.program,
      clearProgram: clearProgram.program,
      globalStateSchema: globalStateSchema,
      localStateSchema: localStateSchema,
    );
  }

  /// Opt in to the smart contract.
  /// This is a helper function to opt in to an existing smart contract.
  ///
  /// Before any account, including the creator of the smart contract,
  /// can begin to make Application Transaction calls that use local state,
  /// it must first opt into the smart contract.
  ///
  /// This prevents accounts from being spammed with smart contracts.
  /// To opt in, an ApplicationCall transaction of type OptIn needs to be
  /// signed and submitted by the account desiring to opt into the
  /// smart contract.
  ///
  /// Throws [AlgorandException] if unable to opt into the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> optIn({
    required Account account,
    required int applicationId,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationOptInTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Call a Stateful Smart Contract.
  /// This is a helper function to easily call a stateful smart contract and
  /// pass arguments to it.
  ///
  /// Arguments can be passed to any of the supported application transaction
  /// calls, including create.
  ///
  /// The number and type can also be different for any subsequent calls to the
  /// stateful smart contract.
  ///
  /// Once an account has opted into a stateful smart contract it can begin to
  /// make calls to the contract.
  /// These calls will be in the form of ApplicationCall transactions that can
  /// be submitted with goal or the SDK.
  ///
  /// Depending on the individual type of transaction as described in
  /// The Lifecycle of a Stateful Smart Contract, either the ApprovalProgram or
  /// the ClearStateProgram will be called.
  ///
  /// Generally, individual calls will supply application arguments.
  ///
  /// Throws [AlgorandException] if unable to call the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> call({
    required Account account,
    required int applicationId,
    String? arguments,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationCallTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..arguments = arguments?.toApplicationArguments()
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Updates an existing Stateful Smart Contract.
  /// This is a helper function to easily update a stateful smart contract.
  ///
  /// A stateful smart contract’s programs can be updated at any time.
  /// This is done by an ApplicationCall transaction type of UpdateApplication.
  /// This operation can be done with goal or the SDKs and requires passing the
  /// new programs and specifying the application ID.
  ///
  /// The one caveat to this operation is that global or local state
  /// requirements for the smart contract can never be updated.
  ///
  /// Throws [AlgorandException] if unable to update the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> update({
    required Account account,
    required int applicationId,
    required TEALProgram approvalProgram,
    required TEALProgram clearProgram,
    String? arguments,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationUpdateTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..approvalProgram = approvalProgram
          ..clearStateProgram = clearProgram
          ..arguments = arguments?.toApplicationArguments()
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Discontinue use of the application by sending a close out transaction.
  /// This will remove the local state for this application from the user's
  /// account.
  ///
  /// Accounts use this transaction to close out their participation in the
  /// contract. This call can fail based on the TEAL logic, preventing the
  /// account from removing the contract from its balance record.
  ///
  /// Throws [AlgorandException] if unable to close out the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> close({
    required Account account,
    required int applicationId,
    String? arguments,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationCloseOutTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..arguments = arguments?.toApplicationArguments()
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Deletes an existing Stateful Smart Contract.
  /// This is a helper function to easily delete a stateful smart contract.
  ///
  /// To delete a smart contract, an ApplicationCall transaction of type
  /// DeleteApplication must be submitted to the blockchain.
  /// The ApprovalProgram handles this transaction type and if the call returns
  /// true the application will be deleted.
  ///
  /// The approval program defines the creator as the only account able to
  /// delete the application. This removes the global state,
  /// but does not impact any user's local state.
  ///
  /// Throws [AlgorandException] if unable to delete the application or send
  /// the transaction.
  /// Returns the transaction id.
  Future<String> delete({
    required Account account,
    required int applicationId,
    String? arguments,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationDeleteTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..arguments = arguments?.toApplicationArguments()
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Clear the local state for an application at any time, even if the
  /// application was deleted by the creator.
  ///
  /// Similar to CloseOut, but the transaction will always clear a contract
  /// from the account’s balance record whether the program succeeds or fails.
  ///
  /// Throws [AlgorandException] if unable to clear the local state of the
  /// application or send the transaction.
  /// Returns the transaction id.
  Future<String> clearState({
    required Account account,
    required int applicationId,
    String? arguments,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (ApplicationClearStateTransactionBuilder()
          ..sender = account.address
          ..applicationId = applicationId
          ..arguments = arguments?.toApplicationArguments()
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }
}
