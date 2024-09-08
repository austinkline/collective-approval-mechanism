import "CollectiveApprovalMechanism"

transaction(managerAddress: Address, voters: {Address: UFix64}) {
    let voter: auth(CollectiveApprovalMechanism.Propose) &CollectiveApprovalMechanism.Voter

    prepare(acct: auth(Storage) &Account) {
        if acct.storage.type(at: CollectiveApprovalMechanism.VoterStoragePath) == nil {
            let voter <- CollectiveApprovalMechanism.createVoter()
            acct.storage.save(<-voter, to: CollectiveApprovalMechanism.VoterStoragePath)
        }

        self.voter = acct.storage.borrow<auth(CollectiveApprovalMechanism.Propose) &CollectiveApprovalMechanism.Voter>(from: CollectiveApprovalMechanism.VoterStoragePath)
            ?? panic("voter not found in storage path")
    }

    execute {
        let cap = getAccount(managerAddress).capabilities.get<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerPublicPath)
        let manager = cap.borrow() ?? panic("manager not found")

        let executable <- CollectiveApprovalMechanism.createChangeVotersExecutable(voters: voters)

        let title = "Update approved Voters"
        let description = "Merges the current set of voters on this manager with a new one. Any voter with an entry of 0.0 will be removed if it is already present"

        self.voter.proposeExecutable(manager: manager, executable: <-executable, title: title, description: description)
    }
}