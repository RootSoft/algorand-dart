import os
from pyteal import *
from pytealutils.strings import itoa

# This may be provided as a constant in pyteal, for now just hardcode
prefix = Bytes("base16", "151f7c75")

acct_param_selector = MethodSignature("acct_param(account)string")
bsqrt_selector = MethodSignature("bsqrt(uint64)uint64")
gitxn_selector = MethodSignature("gitxn(account,uint64,account,uint64)uint64")
budget_pad_selector = MethodSignature("pad()void")


@Subroutine(TealType.none)
def gitxns():

    acct_ref1 = Btoi(Txn.application_args[1])
    amt1 = Btoi(Txn.application_args[2])

    acct_ref2 = Btoi(Txn.application_args[3])
    amt2 = Btoi(Txn.application_args[4])

    return return_any(
        Seq(
            # Start building group
            InnerTxnBuilder.Begin(),
            # Set fields on first group
            InnerTxnBuilder.SetFields(
                {
                    TxnField.type_enum: TxnType.Payment,
                    TxnField.receiver: Txn.accounts[acct_ref1],
                    TxnField.amount: amt1,
                    TxnField.fee: Int(0),  # make caller cover fees
                }
            ),
            # Start building next txn in group
            InnerTxnBuilder.Next(),
            # Set fields on second group
            InnerTxnBuilder.SetFields(
                {
                    TxnField.type_enum: TxnType.Payment,
                    TxnField.receiver: Txn.accounts[acct_ref2],
                    TxnField.amount: amt2,
                    TxnField.fee: Int(0),  # make caller cover fees
                }
            ),
            # Send  group
            InnerTxnBuilder.Submit(),
            Itob(Gitxn[0].amount() + Gitxn[1].amount()),
        )
    )


@Subroutine(TealType.none)
def acct_param():
    acct_ref = Btoi(Txn.application_args[1])
    return return_string(
        Seq(
            aa := AccountParam.authAddr(acct_ref),
            mb := AccountParam.minBalance(acct_ref),
            b := AccountParam.balance(acct_ref),
            Concat(
                Bytes("Auth addr: '"),
                If(aa.hasValue(), aa.value(), Bytes("<None>")),
                Bytes("', Min balance: "),
                itoa(If(mb.hasValue(), mb.value(), Int(0))),
                Bytes(", Balance (in algos): "),
                itoa(If(b.hasValue(), b.value() / Int(1000000), Int(0))),
            ),
        )
    )


@Subroutine(TealType.none)
def bsqrt():
    # Leave it as bytes
    big_int = Txn.application_args[1]
    return return_any(Itob(Btoi(BytesSqrt(big_int))))


# Util to add length to string to make it abi compliant, will have better interface in pyteal
@Subroutine(TealType.bytes)
def string_encode(str):
    return Concat(Extract(Itob(Len(str)), Int(6), Int(2)), str)


# Util to log bytes with return prefix
@Subroutine(TealType.none)
def return_string(value):
    return Log(Concat(prefix, string_encode(value)))


# Util to log bytes with return prefix
@Subroutine(TealType.none)
def return_any(value):
    return Log(Concat(prefix, value))


def approval():
    # Define our abi handlers, route based on method selector defined above
    handlers = [
        [
            Txn.application_args[0] == acct_param_selector,
            Return(Seq(acct_param(), Int(1))),
        ],
        [
            Txn.application_args[0] == bsqrt_selector,
            Return(Seq(bsqrt(), Int(1))),
        ],
        [
            Txn.application_args[0] == gitxn_selector,
            Return(Seq(gitxns(), Int(1))),
        ],
        [
            Txn.application_args[0] == budget_pad_selector,
            Approve(),
        ],
    ]

    return Cond(
        [Txn.application_id() == Int(0), Approve()],
        [
            Txn.on_completion() == OnComplete.DeleteApplication,
            Return(Txn.sender() == Global.creator_address()),
        ],
        [
            Txn.on_completion() == OnComplete.UpdateApplication,
            Return(Txn.sender() == Global.creator_address()),
        ],
        [Txn.on_completion() == OnComplete.CloseOut, Approve()],
        [Txn.on_completion() == OnComplete.OptIn, Approve()],
        *handlers,
    )


def clear():
    return Return(Int(1))


def get_approval():
    return compileTeal(approval(), mode=Mode.Application, version=6)


def get_clear():
    return compileTeal(clear(), mode=Mode.Application, version=6)


if __name__ == "__main__":
    path = os.path.dirname(os.path.abspath(__file__))

    with open(os.path.join(path, "approval.teal"), "w") as f:
        f.write(get_approval())

    with open(os.path.join(path, "clear.teal"), "w") as f:
        f.write(get_clear())