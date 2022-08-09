from pyteal import *
from pytealutils.debug import log_stats


def replicate():
    return Seq(
        app_prog := AppParam.approvalProgram(Global.current_application_id()),
        clear_prog := AppParam.clearStateProgram(Global.current_application_id()),
        my_balance := AccountParam.balance(Global.current_application_address()),
        Assert(app_prog.hasValue()),
        Assert(clear_prog.hasValue()),
        Assert(my_balance.hasValue()),
        Log(Itob(Global.opcode_budget())),
        If(
            Btoi(Txn.application_args[0]) > Int(0),
            Seq(
                # Create the app
                InnerTxnBuilder.Begin(),
                InnerTxnBuilder.SetFields(
                    {
                        TxnField.type_enum: TxnType.ApplicationCall,
                        TxnField.approval_program: app_prog.value(),
                        TxnField.clear_state_program: clear_prog.value(),
                        TxnField.fee: Int(0),
                    }
                ),
                InnerTxnBuilder.Submit(),
                ## Fund and call it
                InnerTxnBuilder.Begin(),
                InnerTxnBuilder.SetFields(
                    {
                        TxnField.type_enum: TxnType.Payment,
                        TxnField.receiver: Sha512_256(
                            Concat(
                                Bytes("appID"), Itob(InnerTxn.created_application_id())
                            )
                        ),
                        TxnField.amount: my_balance.value() - Int(1_000_000),
                        TxnField.fee: Int(0),
                    }
                ),
                InnerTxnBuilder.Next(),
                InnerTxnBuilder.SetFields(
                    {
                        TxnField.type_enum: TxnType.ApplicationCall,
                        TxnField.application_id: InnerTxn.created_application_id(),
                        TxnField.on_completion: OnComplete.DeleteApplication,
                        TxnField.application_args: [
                            Itob(Btoi(Txn.application_args[0]) - Int(1))
                        ],
                        TxnField.fee: Int(0),
                    }
                ),
                InnerTxnBuilder.Submit(),
            ),
        ),
        Int(1),
    )


def approval():
    return Cond(
        [Txn.application_id() == Int(0), Approve()],
        [Txn.application_args.length() == Int(1), Return(replicate())],
    )


def clear():
    return Approve()


def get_approval():
    return compileTeal(approval(), mode=Mode.Application, version=6)


def get_clear():
    return compileTeal(clear(), mode=Mode.Application, version=6)


if __name__ == "__main__":
    with open("approval.teal", "w") as f:
        f.write(get_approval())
    with open("clear.teal", "w") as f:
        f.write(get_clear())