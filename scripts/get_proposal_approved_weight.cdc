import "CollectiveApprovalMechanism"

access(all) fun main(managerAddress: Address, proposalId: UInt64): UFix64 {
    let manager = getAccount(managerAddress).capabilities.get<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerPublicPath)
        .borrow() ?? panic("manager not found")
    let proposal = manager.borrowProposal(proposalId: proposalId)
        ?? panic("proposal not found")

    return proposal.getApprovalWeight()
}