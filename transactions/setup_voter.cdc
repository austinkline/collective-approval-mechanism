import "CollectiveApprovalMechanism"

transaction {
    prepare(acct: auth(Storage, Capabilities) &Account) {
        if acct.storage.type(at: CollectiveApprovalMechanism.VoterStoragePath) == nil {
            let voter <- CollectiveApprovalMechanism.createVoter()
            acct.storage.save(<-voter, to: CollectiveApprovalMechanism.VoterStoragePath)
        }
    }
}