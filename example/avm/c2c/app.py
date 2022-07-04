import os

from pyteal import *
from pytealutils.inline import InlineAssembly
from pytealutils.strings import itoa

# This may be provided as a constant in pyteal, for now just hardcode
prefix = Bytes("base16", "151f7c75")

# These are the 2 methods we want to expose, calling MethodSignature creates the 4 byte method selector
# as described in arc-0004
call_selector = MethodSignature("call(application)string")
echo_selector = MethodSignature("echo(uint64)string")

# This method is called from off chain, it dispatches a call to the first argument treated as an application id
@Subroutine(TealType.bytes)
def call():

    # Get the reference into the applications array
    app_ref = Btoi(Txn.application_args[1])

    return Seq(
        InnerTxnBuilder.Begin(),
        InnerTxnBuilder.SetFields(
            {
                TxnField.type_enum: TxnType.ApplicationCall,
                # access the actual id specified by the 2nd app arg
                TxnField.application_id: Txn.applications[app_ref],
                # Pass the selector as the first arg to trigger the `echo` method
                TxnField.application_args: [echo_selector],
                # Set fee to 0 so caller has to cover it
                TxnField.fee: Int(0),
            }
        ),
        InnerTxnBuilder.Submit(),
        Suffix(
            # Get the 'return value' from the logs of the last inner txn
            InnerTxn.logs[0],
            Int(
                6
            ),  # TODO: last_log should give us the real last logged message, not in pyteal yet
        ),  # Trim off return (4 bytes) Trim off string length (2 bytes)
    )


# This is called from the other application, just echos some stats
@Subroutine(TealType.bytes)
def echo():
    return Concat(
        Bytes("In app id "),
        itoa(Txn.application_id()),
        Bytes(" which was called by app id "),
        itoa(Global.caller_app_id()),
    )


# Util to add length to string to make it abi compliant, will have better interface in pyteal
@Subroutine(TealType.bytes)
def string_encode(str: Expr):
    return Concat(Extract(Itob(Len(str)), Int(6), Int(2)), str)


# Util to log bytes with return prefix
@Subroutine(TealType.none)
def ret_log(value: Expr):
    return Log(Concat(prefix, string_encode(value)))


def approval():
    # Define our abi handlers, route based on method selector defined above
    handlers = [
        [
            Txn.application_args[0] == call_selector,
            Return(Seq(ret_log(call()), Int(1))),
        ],
        [
            Txn.application_args[0] == echo_selector,
            Return(Seq(ret_log(echo()), Int(1))),
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
        # Add abi handlers to main router conditional
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