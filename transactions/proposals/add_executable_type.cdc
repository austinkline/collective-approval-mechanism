import "CollectiveApprovalMechanism"

transaction(managerAddress: Address, executableTypeIdentifier: String, approved: Bool) {
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

        let executableType = CompositeType(executableTypeIdentifier) ?? panic("invalid executable type")
        let executable <- CollectiveApprovalMechanism.createChangeApprovedTypeExecutable(executableType: executableType, approved: approved)

        let title = "Change executable type approval for type ".concat(executableTypeIdentifier).concat(" to ").concat(approved ? "true": "false")
        let description = "Alters the approval of the proposed executable type."
            .concat("If approved is set to true, this will allow the executable to be used by this manager in future proposals.")
            .concat("If approved is set to false, current proposals of the given executable type will not be permitted, ")
            .concat("and future proposals with this executable type will not be able to be added")
        self.voter.proposeExecutable(manager: manager, executable: <-executable, title: title, description: description)
    }
}