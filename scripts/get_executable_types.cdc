import "CollectiveApprovalMechanism"

access(all) fun main(managerAddress: Address): [String] {
    let manager = getAccount(managerAddress).capabilities.get<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerPublicPath)
        .borrow() ?? panic("manager not found")
    let approvedTypes: [String] = []

    let approved = manager.getApprovedExecutableTypes()
    for type in approved.keys {
        if approved[type] == true {
            approvedTypes.append(type.identifier)
        }
    }

    return approvedTypes
}