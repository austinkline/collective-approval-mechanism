import Test
import "test_helpers.cdc"

access(all) fun setup() {
    deployAll()
}

access(all) fun test() {
    Test.assert(scriptExecutor("import.cdc", [])! as! Bool, message: "failed to import contract in script")
}