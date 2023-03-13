from pyteal import *

def on_create():
    return Seq(
        Approve(),
    )

def on_setup():
    return Seq(
        # Allocate a box called "BoxA" of byte size 100 and ignore the return value
        Pop(App.box_create(Bytes("BoxA"), Int(42))),

        # write to box `poemLine` with new value
        App.box_put(Bytes("BoxA"), Bytes("The lone and level sands stretch far away.")),

        Approve(),
    )

def on_delete():
    return Seq(
        Approve(),
    )

def approval_program():
    program = Cond(
        [Txn.application_id() == Int(0), on_create()],
        [Txn.on_completion() == OnComplete.NoOp, on_setup()],
        [Txn.on_completion() == OnComplete.DeleteApplication, on_delete()],
        [
            Or(
                Txn.on_completion() == OnComplete.OptIn,
                Txn.on_completion() == OnComplete.CloseOut,
                Txn.on_completion() == OnComplete.UpdateApplication,
            ),
            Reject(),
        ],
    )

    return program

def clear_state_program():
    return Approve()

if __name__ == "__main__":
    with open("../build/approval.teal", "w") as f:
        compiled = compileTeal(approval_program(), mode=Mode.Application, version=8)
        f.write(compiled)

    with open("../build/clear_state.teal", "w") as f:
        compiled = compileTeal(clear_state_program(), mode=Mode.Application, version=8)
        f.write(compiled)