import "CollectiveApprovalMechanism"

transaction(managerAddress: Address, proposalId: UInt64) {
    prepare(acct: &Account) {}

    execute {
        let manager = getAccount(managerAddress).capabilities.get<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerPublicPath)
            .borrow() ?? panic("failed to borrow manager for address: ".concat(managerAddress.toString()))
        manager.run(proposalId: proposalId)
    }
}