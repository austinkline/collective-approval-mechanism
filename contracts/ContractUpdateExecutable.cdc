import "CollectiveApprovalMechanism"

access(all) contract ContractUpdateExecutable {
    // Defines an executable that can be used to propose changes to an account's deployed contracts.
    // Mutations are executed in order, and must explicitly flag whether it is an update or not.
    access(all) resource Executable: CollectiveApprovalMechanism.Executable {
        access(all) let mutations: [ContractMutation]

        access(contract) fun run(acct: auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account) {
            for m in self.mutations {
                m.apply(acct: acct)
            }
        }

        access(all) view fun describe(): AnyStruct {
            let data: {String: AnyStruct} = {}
            return data
        }

        init(mutations: [ContractMutation]) {
            self.mutations = mutations
        }
    }

    access(all) struct ContractMutation {
        access(all) let name: String
        access(all) let content: String
        access(all) let isUpdate: Bool

        access(all) fun apply(acct: auth(Contracts) &Account) {
            if self.isUpdate {
                acct.contracts.update(name: self.name, code: self.content.utf8)
            } else {
                acct.contracts.add(name: self.name, code: self.content.utf8)
            }
        }

        init(name: String, content: String, isUpdate: Bool) {
            self.name = name
            self.content = content
            self.isUpdate = isUpdate
        }
    }

    access(all) fun createContractUpdateExecutable(mutations: [ContractMutation]): @Executable {
        return <- create Executable(mutations: mutations)
    }
}