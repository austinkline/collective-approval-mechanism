import "CollectiveApprovalMechanism"

transaction(managerAddress: Address, proposalId: UInt64, approved: Bool) {
    let voter: auth(CollectiveApprovalMechanism.Vote) &CollectiveApprovalMechanism.Voter

    prepare(acct: auth(Storage) &Account) {
        if acct.storage.type(at: CollectiveApprovalMechanism.VoterStoragePath) == nil {
            let voter <- CollectiveApprovalMechanism.createVoter()
            acct.storage.save(<-voter, to: CollectiveApprovalMechanism.VoterStoragePath)
        }

        self.voter = acct.storage.borrow<auth(CollectiveApprovalMechanism.Vote) &CollectiveApprovalMechanism.Voter>(from: CollectiveApprovalMechanism.VoterStoragePath)
            ?? panic("voter not found in storage path")
    }

    execute {
        let managerCap = getAccount(managerAddress).capabilities.get<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerPublicPath)
        let manager = managerCap.borrow() ?? panic("manager not found")

        self.voter.vote(manager: manager, proposalId: proposalId, approved: approved)
    }
}