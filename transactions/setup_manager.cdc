import "CollectiveApprovalMechanism"

transaction(voters: {Address: UFix64}) {
    prepare(acct: auth(Storage, Capabilities) &Account) {
        if acct.storage.type(at: CollectiveApprovalMechanism.ManagerStoragePath) == nil {
            let cap = acct.capabilities.account.issue<auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account>() 
            let manager <- CollectiveApprovalMechanism.createManager(acct: cap, voters: voters)
            acct.storage.save(<-manager, to: CollectiveApprovalMechanism.ManagerStoragePath)

            acct.capabilities.publish(
                acct.capabilities.storage.issue<&CollectiveApprovalMechanism.Manager>(CollectiveApprovalMechanism.ManagerStoragePath),
                at: CollectiveApprovalMechanism.ManagerPublicPath
            )
        }
    }
}